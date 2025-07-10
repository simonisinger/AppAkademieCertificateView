import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:app_akademie_certificate_lib/app_akademie_certificate_lib.dart';
import 'package:app_akademie_certificate_view/certificate_data_check.dart';
import 'package:app_akademie_certificate_view/generated/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart';

void main() {
  runApp(AppAkademieCertificateView());
}

class AppAkademieCertificateView extends StatelessWidget {
  const AppAkademieCertificateView({super.key});

  @override
  Widget build(BuildContext context) {
    final crypto = CertificateCrypto();
    final certificate = Certificate();
    final String digestIdentifierHex = 'AAAAAA';
    certificate.certificateNumber = 'AAA-AAA-AAA';
    certificate.name = 'Max Mustermann';

    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seeds = List<int>.generate(32, (_) => random.nextInt(255));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    final keyGen = RSAKeyGenerator();
    keyGen.init(
        ParametersWithRandom(
            RSAKeyGeneratorParameters(
                BigInt.parse('65537'), 2048, 64
            ),
            secureRandom
        )
    );
    final AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> pair = keyGen.generateKeyPair();
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: CertificateDataCheck(
          base64UrlData: base64UrlEncode(certificate.writeToBuffer()),
          publicKey: pair.publicKey,
          digestIdentifierHex: digestIdentifierHex,
          signature: base64UrlEncode(
              base64Url.decode(
                  crypto.encrypt(certificate, pair.privateKey, digestIdentifierHex).split('/').last
              )
          )
      ),
    );
  }
}
