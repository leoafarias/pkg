import 'package:meta/meta.dart';
import 'package:yaml_edit/yaml_edit.dart';

import '../constants.dart';

/// Current dependency snapshot
class DependencyRef {
  /// Constructor
  DependencyRef._({
    @required this.packageName,
    @required this.pubspec,
    @required this.exists,
    @required this.type,
    @required this.flutter,
    this.runSafe = false,
  });

  /// Runs all operations in "safe" mode
  final bool runSafe;

  /// Name of the package
  final String packageName;

  /// Mutable pubspec yaml
  final YamlEditor pubspec;

  /// Dependency type
  final DependencyType type;

  /// Dependency exists in pubspec
  final bool exists;

  /// Is it a Flutter dependency
  final bool flutter;

  /// Loads a dependency ref [packageName] in the [pubspec]
  factory DependencyRef.load(String packageName) {
    // Load yaml
    final contents = pubpsecFile.readAsStringSync();
    final pubspec = YamlEditor(contents);

    // Find dependency type
    final type = findDependencyType(packageName, pubspec);
    final isFlutter = checkFlutterDependency(pubspec);

    // Return ref
    return DependencyRef._(
      exists: type != DependencyType.notDependency,
      packageName: packageName,
      pubspec: pubspec,
      type: type,
      flutter: isFlutter,
    );
  }

  /// Saves pubspec
  void save() {
    pubpsecFile.writeAsStringSync(
      pubspec.toString(),
    );
  }

  /// Saves temp pubspec
  void saveTemp() {
    tempPubpsecFile.writeAsStringSync(
      pubspec.toString(),
    );
  }

  /// Does package exist in pubspec
  bool get _exists {
    return type != DependencyType.notDependency;
  }

  /// Add as "any" version
  void addAnyVersion({
    DependencyType where = DependencyType.dependency,
  }) {
    addOrUpdate('any', where: where);
  }

  /// Updates dependency ref with [version]
  void addOrUpdate(
    String version, {
    DependencyType where = DependencyType.dependency,
    bool pin = false,
  }) {
    // If it exists and the save location is different
    // than where is currently saved remove it first
    if (_exists && where != type) {
      remove();
    }

    final versionConstraints =
        (pin || version == 'any') ? version : '^$version';
    pubspec.update([where.key, packageName], versionConstraints);
  }

  /// Removes dependency ref from pubspec
  void remove() {
    // Only run if its not currently a dependency
    if (_exists) {
      pubspec.remove([type.key, packageName]);
    }
  }
}

/// Types of dependencies
enum DependencyType {
  /// Regular dependency
  dependency,

  /// Dev dependency
  devDependency,

  /// Override dependency
  dependencyOverride,

  ///
  notDependency
}

/// Extension to make it easy to return dependency type key
extension DependencyTypeExtension on DependencyType {
  /// Name of the channel
  String get key {
    switch (this) {
      case DependencyType.dependency:
        return DependencyTypeKey.dependency;
      case DependencyType.devDependency:
        return DependencyTypeKey.devDependency;
      case DependencyType.dependencyOverride:
        return DependencyTypeKey.dependencyOverride;
      default:
        return DependencyTypeKey.notDependency;
    }
  }
}

/// Get type from key
DependencyType _getDependencyTypeFromKey(String key) {
  switch (key) {
    case DependencyTypeKey.dependency:
      return DependencyType.dependency;
    case DependencyTypeKey.devDependency:
      return DependencyType.devDependency;
    case DependencyTypeKey.dependencyOverride:
      return DependencyType.dependencyOverride;
    default:
      return DependencyType.notDependency;
  }
}

/// Check if is a Flutter dependency in [pubspec]
bool checkFlutterDependency(YamlEditor pubspec) {
  /// Get dep from pubspec
  final flutter = pubspec.parseAt(
    [DependencyType.dependency.key, 'flutter'],
    orElse: () => null,
  );

  /// Does it exist
  return flutter != null;
}

/// Gets dependency type
DependencyType findDependencyType(
  String packageName,
  YamlEditor pubspec, {
  List<String> types,
}) {
  // First one set keys for recursive
  types ??= [...DependencyTypeKey.all];

  // Return if ran through all deps
  if (types.isEmpty) {
    return DependencyType.notDependency;
  }

// Current dep key
  final depKey = types[0];

  /// Get dep from pubspec
  final type = pubspec.parseAt(
    [depKey, packageName],
    orElse: () => null,
  );

  if (type != null) {
    return _getDependencyTypeFromKey(depKey);
  } else {
    /// Removes for recurive call
    types.remove(depKey);
    return findDependencyType(packageName, pubspec, types: types);
  }
}
