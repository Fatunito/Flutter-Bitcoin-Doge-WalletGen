import 'dart:typed_data';

import 'package:bs58check/bs58check.dart' as bs58check show encode;
import 'package:crypto/crypto.dart';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:pointycastle/digests/ripemd160.dart' show RIPEMD160Digest;

abstract class WalletService {
  Future<String> generateMnemonic();
  Future<Map<String, dynamic>> createWalletFromMnemonic(
    String coin,
    String mnemonic,
  );
}

class WalletServiceImpl implements WalletService {
  @override
  Future<String> generateMnemonic() async {
    return bip39.generateMnemonic(strength: 128);
  }

  @override
  Future<Map<String, dynamic>> createWalletFromMnemonic(
    String coin,
    String mnemonic,
  ) async {
    try {
      final seed = bip39.mnemonicToSeed(mnemonic);
      final tokens = await _generateTokensFromSeed(coin, seed);
      return tokens;
    } catch (e) {
      throw Exception('Failed to create wallet: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> _generateTokensFromSeed(
    String coin,
    Uint8List seed,
  ) async {
    switch (coin) {
      case "bitcoin":
        return await _generateBitcoinToken(seed);
      case "doge":
        return await _generateDogecoinToken(seed);
      default:
        return {};
    }
  }

  Future<Map<String, dynamic>> _generateBitcoinToken(Uint8List seed) async {
    final hdWallet = bip32.BIP32.fromSeed(seed);
    final derivationPath = "m/44'/0'/0'/0/0"; // Bitcoin standard path

    final child = hdWallet.derivePath(derivationPath);

    if (child.privateKey == null) {
      throw Exception("Failed to derive Bitcoin private key.");
    }

    final privateKey = child.toWIF();
    final publicKey = child.publicKey;

    final sha256Hash = sha256.convert(publicKey).bytes;
    final ripemd160Hash = RIPEMD160Digest().process(
      Uint8List.fromList(sha256Hash),
    );

    final addressBytes = Uint8List.fromList(
      [0x00] + ripemd160Hash,
    );
    final address = bs58check.encode(addressBytes);

    return {
      "address": address,
      "privateKey": privateKey,
    };
  }

  Future<Map<String, dynamic>> _generateDogecoinToken(Uint8List seed) async {
    final hdWallet = bip32.BIP32.fromSeed(seed);
    final derivationPath = "m/44'/3'/0'/0/0";

    final child = hdWallet.derivePath(derivationPath);

    if (child.privateKey == null) {
      throw Exception("Failed to derive Dogecoin private key.");
    }

    final publicKey = child.publicKey;

    final sha256Hash = sha256.convert(publicKey).bytes;
    final ripemd160Hash = RIPEMD160Digest().process(
      Uint8List.fromList(sha256Hash),
    );

    final addressBytes = Uint8List.fromList([0x1E] + ripemd160Hash);
    final address = bs58check.encode(addressBytes);

    final privateKeyRaw = child.privateKey!;

    final prefix = [0x9E];
    List<int> suffix = [0x01];

    final wifBytes = Uint8List.fromList(prefix + privateKeyRaw + suffix);
    final privateKeyWIF = bs58check.encode(wifBytes);

    return {
      "address": address,
      "privateKey": privateKeyWIF,
    };
  }
}
