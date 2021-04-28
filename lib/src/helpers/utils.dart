import 'dart:io';

import 'package:path/path.dart';

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
