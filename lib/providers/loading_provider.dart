import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void start() {
    _isLoading = true;
    notifyListeners();
  }

  void stop() {
    _isLoading = false;
    notifyListeners();
  }
}
