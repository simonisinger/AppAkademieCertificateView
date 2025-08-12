import 'package:app_akademie_certificate_view/certificate_data_check.dart';
import 'package:app_akademie_certificate_view/generated/i18n/app_localizations.dart';
import 'package:app_akademie_certificate_view/rsa_parser.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AppAkademieCertificateView());
}

class AppAkademieCertificateView extends StatelessWidget {
  const AppAkademieCertificateView({super.key});

  @override
  Widget build(BuildContext context) {
    final url =
        'https://cert.app-akademie.com/CgNEYXYSDAizm-zEBhCwwu-4AxoMCLOF_M8GEIjxv7sDIPgKKgUAAQIDBDIFMTMzMzM6BAABAgNCBwABAgMEBQZIAQ==/JdYuHIovAqYjGC33MsbQBHQYtXvZRU0n3oUzzrLGBxvFRt9mLS-rdgN3Eo2SOqKE2pF3uVGScYzK37A9PcRGVtIHvKWQGu1r07zNsDdbGa3Zmylq5l6VHszOwOThbqCYgWWR-mLDt6HrOA2XnNwFTg8Afwyb58EyRz36Ltcyv2cVImwXuaMPHidMGAjZt9Zqwzi7YNgkUyUWXInZfkkjzHXY2OqIUNyg00YRWp9soVqy4g4mlMxtz_0Gpnw_JnykmRWIvYHTbtaO4onGSyhhHS8ZYXWi8UDpdcs-rEPzrFGSqYQ2TViKcZQacBec8qse2Heq0z_jZeN4VPdNp4vCRg==';
    final parts = url.split('/');
    final urlData = parts[parts.length - 2];
    final signature = parts[parts.length - 1];
    final digestIdentifierHex = 'AAAAAA';
    final publicKeyPem = '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAo9ozzgqbhI2+12qYoY1O
D7rGr7nuWmdng0rIRcQ/0ryyv4bylilOBgkfSNNzbLs6BvSAyVEk4tnH9BOD6jtA
bo7fyCRvN5ZZvHTV63JZZCQLW7h9kRgA7R6+RsBN11bNC97NCiDZXaJNujMZNR/C
MdyCGtIdTNKHVs/GKIA0dTsTsdWJ1KUfFswKJYJkttIaXuB2oRlr9olVA8PKKZl1
hE3pW3WbaN4sb4Y+KTtyXSvKgfF/jskKd9+eX0kohGR+L2ANN5MbgfYA76Bbl2Sb
+tzPfvJCdhM/igKEQ5VgTP1BtFbQLnqL1CwnI2jPBsk/eKMg3Qup8iUpDZtwVpj5
sQIDAQAB
-----END PUBLIC KEY-----
''';
    final publicKey = RSAParser.parsePublicKeyFromPem(publicKeyPem);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: CertificateDataCheck(
        base64UrlData: urlData,
        publicKey: publicKey,
        digestIdentifierHex: digestIdentifierHex,
        signature: signature,
      ),
    );
  }
}
