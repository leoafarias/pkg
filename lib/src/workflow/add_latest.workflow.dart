import 'package:pkg/src/logger.dart';

import '../helpers/api_client.dart';
import '../helpers/dependency_ref.dart';

/// Adds the latatest version of a package
/// version of [ref] as a dependency [type]
Future<void> addLatestVersionWorkflow(
  DependencyRef ref,
  DependencyType where,
) async {
  // Get package info
  final packageInfo = await pubClient.packageInfo(ref.packageName);

  logger.stdout(packageInfo.version);
  // Add or update depependency
  ref.addOrUpdate(
    packageInfo.version,
    where: where,
  );

  // Save new pubspec
  ref.save();
}
