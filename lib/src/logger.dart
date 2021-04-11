import 'package:cli_util/cli_logging.dart';
import 'package:io/ansi.dart';

/// Standard logger
PrettyLogger logger = PrettyLogger();

/// Logger namespace
class PrettyLogger {
  /// Standard logger
  Logger logger = Logger.standard();

  /// Constructor
  PrettyLogger();

  /// Prints a standard status message
  void stdout(String message) => logger.stdout(message);

  /// Prints an error message
  void stderr(String message) => logger.stderr(red.wrap(message));

  /// Prints a warning message
  void warn(String message) => logger.stdout(yellow.wrap(message));

  /// Prints a success message
  void success(String message) => logger.stdout(green.wrap(message));

  /// Prints trace output
  void trace(String message) => logger.trace(message);

  /// Starts an indeterminate process display
  Progress progress(String message) => logger.progress(message);

  /// Starts print a divider on console
  void divider() => logger.stdout(
        '___________________________________________________\n',
      );
}
