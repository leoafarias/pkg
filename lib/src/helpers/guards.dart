import 'package:args/args.dart';

import '../constants.dart';
import '../exceptions.dart';

// TODO: Add option to try to recover from the condition
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
  bool condition(ArgResults argResults);

  /// Validates
  void validate(ArgResults argResults) {
    if (!condition(argResults)) {
      throw PkgUsageException(message);
    }
  }

  /// Throws [PkgUsageException] if current directory
  /// does not have a pubspec.yaml
  // ignore: non_constant_identifier_names
  static Guard get HasPubspec => _GuardHasPubspec();

  /// Makes sure a package name was passed
  // ignore: non_constant_identifier_names
  static Guard get HasPackageArg => _GuardHasPackageArg();
}

/// Throws [PkgUsageException] if current directory
/// does not have a pubspec.yaml
class _GuardHasPubspec extends Guard {
  @override
  String get message {
    return 'Can only run command on the root of a Dart project.';
  }

  @override
  bool condition(_) => pubpsecFile.existsSync();
}

// /// Makes sure tempDir exists. Throws [PkgUsageException] if cannot
// /// create a temp directory for safe operations
// class GuardTempDirExists extends Guard {
//   @override
//   String get message {
//     return 'Could not create temp directory for safe operations';
//   }

//   @override
//   bool condition() => pubpsecFile.existsSync();
// }

class _GuardHasPackageArg extends Guard {
  @override
  String get message {
    return 'Please provide a package name';
  }

  @override
  bool condition(ArgResults argResults) => argResults.rest.isNotEmpty;
}
