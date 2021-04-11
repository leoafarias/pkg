/// Exception for internal pkg Errors
class PkgInternalError implements Exception {
  /// Message of erro
  final String message;

  /// Constructor
  const PkgInternalError([this.message = '']);

  @override
  String toString() => 'Internal Error: $message';
}

/// Exception for internal pkg usage
class PkgUsageException implements Exception {
  /// Message of the exception
  final String message;

  /// Constructor of usage exception
  const PkgUsageException([this.message = '']);

  @override
  String toString() => 'Usage Exception: $message';
}
