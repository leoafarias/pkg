import '../helpers/dependency_ref.dart';
import '../helpers/pub_tools.dart';
import '../logger.dart';

/// Runs [pub get] command
Future<int> pubGetWorkflow(DependencyRef ref) async {
  final progress = logger.progress('Running pub get');
  int exitCode;
  if (ref.flutter) {
    exitCode = await PubTools.runFlutterGet();
  } else {
    exitCode = await PubTools.runGet();
  }

  progress.finish();
  return exitCode;
}
