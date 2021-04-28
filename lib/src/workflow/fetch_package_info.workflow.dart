import 'package:pub_api_client/pub_api_client.dart';

import '../helpers/api_client.dart';
import '../helpers/dependency_ref.dart';

/// Fetches package information
Future<PubPackage> fetchPackageInfoWorkflow(DependencyRef ref) async {
  // Get package info
  final packageInfo = await pubClient.packageInfo(ref.packageName);

  return packageInfo;
}
