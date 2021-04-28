import 'package:io/io.dart';

import '../helpers/api_client.dart';
import '../helpers/guards.dart';
import '../logger.dart';
import 'base.dart';

/// Like a pub.dev package
class LikeCommand extends BaseCommand {
  @override
  final name = 'like';

  @override
  final description = 'Like a pub.dev package';

  @override
  final String invocation = 'pkg like {package}';

  /// Constructor
  LikeCommand();

  @override
  final guards = [
    Guard.HasPackageArg,
  ];

  @override
  Future<int> runWithGuards() async {
    // Get package name
    final packageName = argResults!.rest.first;
    await pubClient.likePackage(packageName);

    logger.success('You liked $packageName!');
    return ExitCode.success.code;
  }
}
