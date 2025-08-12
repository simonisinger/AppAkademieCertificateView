import 'package:app_akademie_certificate_view/certificate_data_check.dart';
import 'package:app_akademie_certificate_view/generated/i18n/app_localizations.dart';
import 'package:app_akademie_certificate_view/qr_code_scan_screen.dart';
import 'package:app_akademie_certificate_view/rsa_parser.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

const int totalModules = 4;
const int totalBadges = 7;
void main() {
  String? urlCode;
  try {
    final uri = Uri.parse(web.window.location.href);
    final pathSegments = uri.pathSegments;
    urlCode = pathSegments.isNotEmpty ? pathSegments.join('/') : null;
  } catch (e) {
    urlCode = null;
  }
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
  runApp(
    AppAkademieCertificateView(
      urlCode: urlCode,
      digestIdentifierHex: digestIdentifierHex,
      publicKeyPem: publicKeyPem,
    ),
  );
}

class AppAkademieCertificateView extends StatelessWidget {
  final String? urlCode;
  final String digestIdentifierHex;
  final String publicKeyPem;
  const AppAkademieCertificateView({
    super.key,
    required this.urlCode,
    required this.digestIdentifierHex,
    required this.publicKeyPem,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Akademie Zertifikat Viewer',
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.lightBlueAccent,
        ),
      ),
      themeMode: ThemeMode.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('de', 'DE'),
      home:
          urlCode == null || urlCode!.isEmpty
              ? const QrCodeScanScreen()
              : _buildCertificateView(),
    );
  }

  Widget _buildCertificateView() {
    final publicKey = RSAParser.parsePublicKeyFromPem(publicKeyPem);
    return CertificateDataCheck(
      base64UrlData: _urlParts.base64UrlData,
      publicKey: publicKey,
      digestIdentifierHex: digestIdentifierHex,
      signature: _urlParts.signature,
    );
  }

  ({String signature, String base64UrlData}) get _urlParts {
    if (urlCode == null || urlCode!.isEmpty) {
      return (signature: '', base64UrlData: '');
    }
    try {
      final parts = urlCode!.split('/');
      return (signature: parts.last, base64UrlData: parts[parts.length - 2]);
    } catch (_) {
      return (signature: '', base64UrlData: '');
    }
  }
}
