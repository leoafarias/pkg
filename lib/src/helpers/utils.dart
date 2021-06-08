import 'dart:io';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

import '../constants.dart';
import 'dependency_ref.dart';

/// Recursive look up to find nested project directory
/// Can start at a specific [directory] if provided
Future<File?> findAncestor({Directory? directory}) async {
  // Get directory, defined root or current
  directory ??= Directory.current;

  // Checks if the directory is root
  final isRootDir = rootPrefix(directory.path) == directory.path;

  // Gets pubspec from directory
  final pubspecFile = File(join(directory.path, 'pubspec.yaml'));

  // If project has a config return it
  if (await pubspecFile.exists()) {
    return pubspecFile;
  }

  // Return working directory if has reached root
  if (isRootDir) {
    return null;
  }

  return await findAncestor(directory: directory.parent);
}

/// Creates a clean version to the changelog
String pubDevChangelogUrl(String url, String version) {
  final cleanVersion = version.replaceAll('.', '').replaceAll('+', '');
  return '$url#$cleanVersion';
}

/// Load PubSpec
YamlEditor loadPubspecSync() {
  // Load yaml
  final contents = pubpsecFile.readAsStringSync();
  return YamlEditor(contents);
}

/// Map of dependencies
typedef DependenciesMap = Map<DependencyType, List<String>>;

/// Get all dependencies
DependenciesMap getAllDependencies(
  YamlEditor pubspec, {
  DependenciesMap? deps,
  List<String>? types,
}) {
  deps ??= {};
  // Assign type so it can be modified
  // Needs t be a modifiable list
  types ??= [
    DependencyTypeKey.dependency,
    DependencyTypeKey.devDependency,
    DependencyTypeKey.dependencyOverride,
  ];
  // Return if ran through all deps
  if (types.isEmpty) {
    return deps;
  }

// Current dep key
  final depKey = types[0];

  /// Get deps from dep type
  final depsInType = pubspec.parseAt(
    [depKey],
    orElse: () => wrapAsYamlNode({}),
  );
  final foundMap = depsInType.value as YamlMap;
  // Cast list as string
  final foundPkgs = foundMap.keys.toList().cast<String>().toList();
  final depType = getDependencyTypeFromKey(depKey);

  deps[depType] = foundPkgs;

  // Remove current type in loop
  types.remove(depType.key);

  // Run recursively
  return getAllDependencies(
    pubspec,
    deps: deps,
    types: types,
  );
}
