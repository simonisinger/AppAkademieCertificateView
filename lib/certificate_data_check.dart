import 'dart:convert';

import 'package:app_akademie_certificate_lib/app_akademie_certificate_lib.dart';
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
    bool validation = CertificateCrypto().validate(
        publicKey,
        base64Url.decode(base64UrlData),
        base64Url.decode(signature),
        digestIdentifierHex
    );
    Color color = validation ? Colors.green : Colors.red;
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
            child: Text(
                validation ? 'Der eingescannte QR Code ist gültig'
                    : 'Der eingescannte QR Code ist ungültig',
                style: TextStyle(
                  color: color
                ),
            ),
          ),
        ),
      ),
    );
  }
}
