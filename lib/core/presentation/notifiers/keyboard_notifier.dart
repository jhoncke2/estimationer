import 'package:flutter/cupertino.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class KeyboardNotifier extends ChangeNotifier{
  bool _isActive;
  
  KeyboardNotifier(){
    _isActive = false;
    KeyboardVisibilityNotification().addNewListener(onChange: (bool isActive){
      _isActive = isActive;
      notifyListeners();
    });
  }

  bool get isActive => _isActive;

}