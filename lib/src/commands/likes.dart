import 'package:io/io.dart';

import '../helpers/api_client.dart';
import '../logger.dart';
import 'base.dart';

/// View packages you have liked on pub.dev
class ListLikesCommand extends BaseCommand {
  @override
  final name = 'likes';

  @override
  final description = 'View liked packages on pubdev';

  @override
  final String invocation = 'pkg likes';

  /// Constructor
  ListLikesCommand();

  @override
  Future<int> runWithGuards() async {
    final likes = await pubClient.listPackageLikes();
    for (final like in likes) {
      logger.stdout(like.package);
    }
    return ExitCode.success.code;
  }
}
