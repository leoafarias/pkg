import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:io/io.dart';

import '../lib/src/../../src/logger.dart';
import '../src/commands/add.dart';
import '../src/exceptions.dart';
import 'commands/remove.dart';
import 'commands/view.dart';
import 'version.dart';

/// Command Runner for pkg
class PkgCommandRunner extends CommandRunner<int> {
  /// Constructor
  PkgCommandRunner()
      : super('pkg', 'Easily manage your pub package dependencies') {
    argParser
      ..addFlag(
        'verbose',
        help: 'Print verbose output.',
        negatable: false,
        callback: (verbose) {
          if (verbose) {
            logger.logger = Logger.verbose();
          }
        },
      )
      ..addFlag(
        'version',
        help: 'current version',
        negatable: false,
      );
    addCommand(AddCommand());
    addCommand(RemoveCommand());
    addCommand(ViewCommand());
  }

  @override
  Future<int> run(Iterable<String> args) async {
    final _argResults = parse(args);
    try {
      final exitCode = await runCommand(_argResults) ?? ExitCode.success.code;

      //TODO: check for update Check if its running the latest version of pkg

      return exitCode;
    } on PkgUsageException catch (e) {
      logger.warn(e.message);

      return ExitCode.usage.code;
    } on PkgInternalError catch (e, stackTrace) {
      logger.stderr(e.message);
      logger.trace('$stackTrace');

      return ExitCode.usage.code;
    } on UsageException catch (e) {
      logger.warn(e.message);
      logger.stdout(usage);

      return ExitCode.usage.code;
    }
  }

  @override
  Future<int> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults['version'] == true) {
      logger.stdout(packageVersion);
      return ExitCode.success.code;
    }

    return super.runCommand(topLevelResults);
  }
}
