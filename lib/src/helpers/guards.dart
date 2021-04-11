import '../constants.dart';
import '../exceptions.dart';

/// Helper method for cleaner implementation
void validateGuard(Guard guard) {
  guard.validate();
}

/// Abstract class for guards
abstract class Guard {
  /// Constructor
  const Guard();

  /// Message of exception if condition
  /// does not pass
  String get message;

  @override
  String toString() => '$message';

  /// Condition that needs to be true to pass
  bool condition();

  /// Validates
  void validate() {
    if (!condition()) {
      throw PkgInternalError(message);
    }
  }
}

/// Throws [PkgInternalError] if current directory
/// does not have a pubspec.yaml
class GuardHasPubspec extends Guard {
  @override
  String get message {
    return 'Can only run command on the root of a Dart project.';
  }

  @override
  bool condition() => pubpsecFile.existsSync();
}

/// Makes sure tempDir exists. Throws [PkgInternalError] if cannot
/// create a temp directory for safe operations
class GuardTempDirExists extends Guard {
  @override
  String get message {
    return 'Could not create temp directory for safe operations';
  }

  @override
  bool condition() => pubpsecFile.existsSync();
}
