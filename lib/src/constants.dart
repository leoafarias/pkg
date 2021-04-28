import 'dart:io';

import 'package:path/path.dart';

/// Pubspec file name
const _pubspecName = 'pubspec.yaml';

/// Pubspec lock file name
const _pubspecLockName = 'pubspec.lock';

/// Pubspec.yaml file
File pubpsecFile = File(join(Directory.current.path, _pubspecName));

/// Pubspec.lock file
File pubpsecLockFile = File(join(Directory.current.path, _pubspecLockName));

/// Temp diectory for safe operations
final pkgTempDir = Directory(join(Directory.systemTemp.path, '.pkgTmp'));

/// Temp Pubspec.yaml file
File tempPubpsecFile = File(join(pkgTempDir.path, _pubspecName));

/// Temp Pubspec.lock file
File tempPubpsecLockFile = File(join(pkgTempDir.path, _pubspecLockName));

/// Depedency type keys within pubspec
class DependencyTypeKey {
  DependencyTypeKey._();

  /// Regular dependency
  static const String dependency = 'dependencies';

  /// Dev dependency
  static const String devDependency = 'dev_dependencies';

  /// Dependency override
  static const String dependencyOverride = 'dependency_overrides';

  /// Not a depependency
  static const String notDependency = 'none';

  /// Returns all dep type keys
  static const List<String> all = [
    dependency,
    devDependency,
    notDependency,
    dependency,
  ];
}
