import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart';

class RSAParser {
  RSAParser._();

  static RSAPublicKey parsePublicKeyFromPem(String pemString) {
    final parser = RSAKeyParser();
    return parser.parse(pemString) as RSAPublicKey;
  }

  static RSAPrivateKey parsePrivateKeyFromPem(String pemString) {
    final parser = RSAKeyParser();
    return parser.parse(pemString) as RSAPrivateKey;
  }
}
