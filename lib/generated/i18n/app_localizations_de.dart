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
}
