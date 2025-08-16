import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ig_agency_app/dependencies/local_storage/local_storage_manager.dart';
import 'package:ig_agency_app/shared/extensions/object.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: LocalStorageManager)
class SharePreferenceImpl extends LocalStorageManager {
  SharePreferenceImpl(this._prefs, this._secureStorage);

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<bool> keyExists(LocalStorageKeys key, {bool isSecure = false}) async {
    if (isSecure) {
      return await _secureStorage.containsKey(
        key: key.name,
        aOptions: _getAndroidOptions(),
      );
    } else {
      return _prefs.containsKey(key.name);
    }
  }

  @override
  Future<T?> getValue<T>(
    LocalStorageKeys key, {
    T Function(Map<String, dynamic>)? fromJson,
    bool isSecure = false,
  }) async {
    if (isSecure) {
      return (await _secureStorage.read(
        key: key.name,
        aOptions: _getAndroidOptions(),
      ))?.as<T?>();
    } else {
      switch (T) {
        case const (int):
          return _prefs.getInt(key.name) as T?;
        case const (double):
          return _prefs.getDouble(key.name) as T?;
        case const (String):
          return _prefs.getString(key.name) as T?;
        case const (bool):
          return _prefs.getBool(key.name) as T?;
        default:
          assert(
            fromJson != null,
            'fromJson must be provided for Object values',
          );
          if (fromJson != null) {
            final stringObject = _prefs.getString(key.name);
            if (stringObject == null) {
              return null;
            }
            final jsonObject = jsonDecode(stringObject) as Map<String, dynamic>;
            return fromJson(jsonObject);
          }
      }
    }

    return null;
  }

  @override
  Future<T?> getValueString<T>(
    String key, {
    T Function(Map<String, dynamic>)? fromJson,
    bool isSecure = false,
  }) async {
    if (isSecure) {
      return (await _secureStorage.read(
        key: key,
        aOptions: _getAndroidOptions(),
      ))?.as<T?>();
    } else {
      switch (T) {
        case const (int):
          return _prefs.getInt(key) as T?;
        case const (double):
          return _prefs.getDouble(key) as T?;
        case const (String):
          return _prefs.getString(key) as T?;
        case const (bool):
          return _prefs.getBool(key) as T?;
        default:
          assert(
            fromJson != null,
            'fromJson must be provided for Object values',
          );
          if (fromJson != null) {
            final stringObject = _prefs.getString(key);
            if (stringObject == null) {
              return null;
            }
            final jsonObject = jsonDecode(stringObject) as Map<String, dynamic>;
            return fromJson(jsonObject);
          }
      }
    }

    return null;
  }

  @override
  Future<void> setValue<T>(
    LocalStorageKeys key,
    T value, {
    bool isSecure = false,
  }) async {
    if (isSecure) {
      return await _secureStorage.write(
        key: key.name,
        value: value.toString(),
        aOptions: _getAndroidOptions(),
      );
    } else {
      switch (T) {
        case const (int):
          _prefs.setInt(key.name, value as int);
          break;
        case const (double):
          _prefs.setDouble(key.name, value as double);
          break;
        case const (String):
          _prefs.setString(key.name, value as String);
          break;
        case const (bool):
          _prefs.setBool(key.name, value as bool);
          break;
        default:
          final stringObject = jsonEncode(value);
          _prefs.setString(key.name, stringObject);
      }
    }
  }

  @override
  Future<void> setValueString<T>(
    String key,
    T value, {
    bool isSecure = false,
  }) async {
    if (isSecure) {
      return await _secureStorage.write(
        key: key,
        value: value.toString(),
        aOptions: _getAndroidOptions(),
      );
    } else {
      switch (T) {
        case const (int):
          _prefs.setInt(key, value as int);
          break;
        case const (double):
          _prefs.setDouble(key, value as double);
          break;
        case const (String):
          _prefs.setString(key, value as String);
          break;
        case const (bool):
          _prefs.setBool(key, value as bool);
          break;
        default:
          final stringObject = jsonEncode(value);
          _prefs.setString(key, stringObject);
      }
    }
  }

  @override
  Future<void> deleteKey(LocalStorageKeys key, {bool isSecure = false}) async {
    if (isSecure) {
      await _secureStorage.delete(
        key: key.name,
        aOptions: _getAndroidOptions(),
      );
    } else {
      _prefs.remove(key.name);
    }
  }

  @override
  Future<void> deleteStringKey(String key, {bool isSecure = false}) async {
    if (isSecure) {
      await _secureStorage.delete(key: key, aOptions: _getAndroidOptions());
    } else {
      _prefs.remove(key);
    }
  }

  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  @override
  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }
}
