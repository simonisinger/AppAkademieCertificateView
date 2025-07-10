import 'dart:convert';
import 'dart:typed_data';

import 'package:app_akademie_certificate_lib/app_akademie_certificate_lib.dart';
import 'package:app_akademie_certificate_view/generated/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart';

class CertificateDataCheck extends StatelessWidget {
  final String base64UrlData;
  final String signature;
  final RSAPublicKey publicKey;
  final String digestIdentifierHex;
  const CertificateDataCheck({super.key, required this.base64UrlData, required this.publicKey, required this.digestIdentifierHex, required this.signature});


  @override
  Widget build(BuildContext context) {
    final Base64Codec base64Url = Base64Codec.urlSafe();
    Uint8List data = base64Url.decode(base64UrlData);
    bool validation = CertificateCrypto().validate(
        publicKey,
        data,
        base64Url.decode(signature),
        digestIdentifierHex
    );
    Color color = validation ? Colors.green : Colors.red;
    AppLocalizations localizations = AppLocalizations.of(context)!;
    Certificate certificate = Certificate.fromBuffer(data);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(
                color: color,
                width: 2
              ),
              //color: validation ? Colors.greenAccent : Colors.redAccent
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    validation ? localizations.validQrCode : localizations.invalidQrCode,
                    style: TextStyle(
                      color: color
                    ),
                ),
                SizedBox(height: 16,),
                Text(
                  localizations.certificateName(certificate.name),
                  style: TextStyle(
                      color: color
                  ),
                ),
                Text(
                  localizations.certificateNumber(certificate.certificateNumber),
                  style: TextStyle(
                      color: color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
