import 'package:flutter/foundation.dart';
import '../../data/models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Login user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock user data
      _currentUser = User(
        id: 'user_123',
        email: email,
        name: 'Test User',
        createdAt: DateTime.now(),
      );
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required int age,
    required String gender,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock user data
      _currentUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        age: age,
        gender: gender,
        createdAt: DateTime.now(),
      );
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Check if user is logged in (on app start)
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Check stored token/session
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock: No user logged in
      _isAuthenticated = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
