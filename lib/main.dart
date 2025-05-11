
import 'package:flutter_bitcoin_doge_walletgen/wallet_service.dart';

void main() async {
  final WalletService service = WalletServiceImpl();

  // Generate a new mnemonic phrase
  final String mnemonic = await service.generateMnemonic();
  print('Generated Mnemonic: $mnemonic\n');

  // Define a list of coins to generate wallets for
  final List<String> coins = ['bitcoin', 'doge'];

  // Create wallets for each coin
  for (final coin in coins) {
    final Map<String, dynamic> wallet = await service.createWalletFromMnemonic(coin, mnemonic);
    print('$coin Wallet Address: ${wallet["address"]}');
    print('$coin Private Key: ${wallet["privateKey"]}\n');
  }
}
