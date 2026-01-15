import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/utils/logger.dart';

/// Local storage service using SharedPreferences
class StorageService {
  late SharedPreferences _prefs;

  /// Initialize storage
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    AppLogger.info('Storage service initialized');
  }

  /// Save string value
  Future<bool> saveString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      AppLogger.error('Error saving string: $key', e);
      return false;
    }
  }

  /// Get string value
  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      AppLogger.error('Error getting string: $key', e);
      return null;
    }
  }

  /// Save int value
  Future<bool> saveInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      AppLogger.error('Error saving int: $key', e);
      return false;
    }
  }

  /// Get int value
  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      AppLogger.error('Error getting int: $key', e);
      return null;
    }
  }

  /// Save bool value
  Future<bool> saveBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      AppLogger.error('Error saving bool: $key', e);
      return false;
    }
  }

  /// Get bool value
  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      AppLogger.error('Error getting bool: $key', e);
      return null;
    }
  }

  /// Save object as JSON
  Future<bool> saveObject(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = json.encode(value);
      return await _prefs.setString(key, jsonString);
    } catch (e) {
      AppLogger.error('Error saving object: $key', e);
      return false;
    }
  }

  /// Get object from JSON
  Map<String, dynamic>? getObject(String key) {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      AppLogger.error('Error getting object: $key', e);
      return null;
    }
  }

  /// Remove value
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      AppLogger.error('Error removing key: $key', e);
      return false;
    }
  }

  /// Clear all data
  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      AppLogger.error('Error clearing storage', e);
      return false;
    }
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
