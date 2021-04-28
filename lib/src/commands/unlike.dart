import 'package:io/io.dart';

import '../helpers/api_client.dart';
import '../helpers/guards.dart';
import '../logger.dart';
import 'base.dart';

/// Like a pub.dev package
class UnlikeCommand extends BaseCommand {
  @override
  final name = 'unlike';

  @override
  final description = 'Unlike a pub.dev package';

  @override
  final String invocation = 'pkg unlike {package}';

  /// Constructor
  UnlikeCommand();

  @override
  final guards = [
    Guard.HasPackageArg,
  ];

  @override
  Future<int> runWithGuards() async {
    // Get package name
    final packageName = argResults!.rest.first;
    await pubClient.unlikePackage(packageName);

    logger.success('You unliked $packageName!');
    return ExitCode.success.code;
  }
}
