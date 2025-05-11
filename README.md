# Flutter Bitcoin & Dogecoin Wallet Generator

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A lightweight, secure Flutter application for generating Bitcoin and Dogecoin wallets. Create hierarchical deterministic (HD) wallets using BIP32, BIP39, and BIP44 standards.

## 🔑 Key Features

- **Secure Mnemonic Generation**: Create BIP39 compliant seed phrases
- **HD Wallet Support**: Implements BIP32/44 standards for deterministic key derivation
- **Multi-Coin Support**: Currently generates Bitcoin and Dogecoin wallets
- **Offline Capability**: Generate wallets without an internet connection
- **Open Source**: Transparent security for cryptocurrency wallet generation

## 🚀 Getting Started

### Prerequisites

- Flutter 3.0 or higher
- Dart 3.0 or higher

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/flutter_bitcoin_doge_walletgen.git
```

2. Navigate to the project directory:
```bash
cd flutter_bitcoin_doge_walletgen
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application:
```bash
flutter run
```

## 💻 Usage

```dart
// Create a new wallet service instance
final WalletService service = WalletServiceImpl();

// Generate a new mnemonic phrase
final String mnemonic = await service.generateMnemonic();

// Create a Bitcoin wallet
final bitcoinWallet = await service.createWalletFromMnemonic('bitcoin', mnemonic);

// Create a Dogecoin wallet
final dogeWallet = await service.createWalletFromMnemonic('doge', mnemonic);

// Access wallet information
print('Bitcoin Address: ${bitcoinWallet["address"]}');
print('Bitcoin Private Key: ${bitcoinWallet["privateKey"]}');
```

## 🛠️ Technical Details

The wallet generator implements the following cryptographic standards:

- **BIP32**: Hierarchical Deterministic Wallets
- **BIP39**: Mnemonic code for generating deterministic keys
- **BIP44**: Multi-Account Hierarchy for Deterministic Wallets

### Derivation Paths

- Bitcoin: `m/44'/0'/0'/0/0`
- Dogecoin: `m/44'/3'/0'/0/0`

### Dependencies

- `bip32`: For HD wallet generation
- `bip39`: For mnemonic phrase generation
- `bs58check`: For Base58Check encoding
- `crypto`: For cryptographic functions
- `pointycastle`: For RIPEMD160 digest

## 🔄 Extending the Project

To add support for additional cryptocurrencies:

1. Implement a new method in the `WalletServiceImpl` class
2. Add the appropriate derivation path for the cryptocurrency
3. Configure the correct address prefixes for the desired network

Example for adding Litecoin support:

```dart
Future<Map<String, dynamic>> _generateLitecoinToken(Uint8List seed) async {
  final hdWallet = bip32.BIP32.fromSeed(seed);
  final derivationPath = "m/44'/2'/0'/0/0"; // Litecoin path
  
  // Implementation details...
}
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Made with ❤️ for the flutter community
