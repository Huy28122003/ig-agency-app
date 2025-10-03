enum LocalStorageKeys {
  email,
  password,
  isDarkMode,
  isInAppAlerts,
  accessToken,
  profileInfo,
  deviceId,
}

abstract class LocalStorageManager {
  Future<bool> keyExists(LocalStorageKeys key, {bool isSecure = false});

  Future<T?> getValue<T>(
    LocalStorageKeys key, {
    T Function(Map<String, dynamic>)? fromJson,
    bool isSecure = false,
  });

  Future<void> setValue<T>(
    LocalStorageKeys key,
    T value, {
    bool isSecure = false,
  });

  Future<T?> getValueString<T>(
    String key, {
    T Function(Map<String, dynamic>)? fromJson,
    bool isSecure = false,
  });

  Future<void> setValueString<T>(String key, T value, {bool isSecure = false});

  Future deleteKey(LocalStorageKeys key, {bool isSecure = false});

  Future deleteStringKey(String key, {bool isSecure = false});

  Future<void> deleteAll();
}
