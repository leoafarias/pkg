import '../helpers/dependency_ref.dart';
import '../helpers/pub_tools.dart';
import '../logger.dart';

/// Runs [pub get] command
Future<void> pubGetWorkflow(DependencyRef ref) async {
  final progress = logger.progress('Running pub get');

  if (ref.flutter) {
    await PubTools.runFlutterGet();
  } else {
    await PubTools.runGet();
  }

  progress.finish();
}
