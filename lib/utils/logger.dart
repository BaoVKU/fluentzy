class Logger {
  static void error(String message) {
    print("\x1B[31m[LOGGER] $message\x1B[0m");
  }

  static void errorWithTag(String tag, String message) {
    print("\x1B[31m[$tag] $message\x1B[0m");
  }

  static void success(String message) {
    print("\x1B[32m[SUCCESS] $message\x1B[0m");
  }

  static void warning(String message) {
    print("\x1B[33m[WARNING] $message\x1B[0m");
  }
}
