import 'package:pub_api_client/pub_api_client.dart';

import '../exceptions.dart';
import '../helpers/api_client.dart';
import '../helpers/dependency_ref.dart';

/// Fetches package information
Future<PubPackage> fetchPackageInfoWorkflow(DependencyRef ref) async {
  // Get package info
  final packageInfo = await pubClient.packageInfo(ref.packageName);

  /// If package does not exist log error
  if (packageInfo.name == null) {
    throw PkgUsageException('Could not find package: ${ref.packageName}');
  }

  return packageInfo;
}
