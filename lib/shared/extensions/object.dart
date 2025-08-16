extension ObjectExtension on Object {
  T? as<T>() {
    if (this is T) {
      return this as T;
    }

    return null;
  }
}