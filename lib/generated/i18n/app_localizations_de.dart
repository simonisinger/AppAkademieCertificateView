// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get invalidQrCode => 'Der eingescannte QR Code ist ungültig';

  @override
  String get validQrCode => 'Der eingescannte QR Code ist gültig';

  @override
  String certificateName(String name) {
    return 'Name: $name';
  }

  @override
  String certificateNumber(String number) {
    return 'Zertifikatsnummer: $number';
  }

  @override
  String get scanQrCodeTitle => 'QR-Code scannen';

  @override
  String get scanQrCodeInstruction =>
      'Bitte scannen Sie den QR-Code eines App Akademie Zertifikats mit der Kamera Ihres Handys.';

  @override
  String get noQrCodeProvided => 'Kein QR-Code bereitgestellt';

  @override
  String get completionCertificate => 'Abschlusszertifikat';

  @override
  String get participationConfirmation => 'Teilnahmebescheinigung';

  @override
  String get credits =>
      'Entwickelt von den Batch #9 Teilnehmern Simon Isinger und Jürgen Kuck';
}
