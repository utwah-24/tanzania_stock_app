import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  String _userName = 'Utwah';

  String get userName => _userName;

  bool updateUserName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed == _userName) {
      return false;
    }

    _userName = trimmed;
    notifyListeners();
    return true;
  }
}
