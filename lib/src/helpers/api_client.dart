import 'dart:io';

import 'package:pub_api_client/pub_api_client.dart';

import '../constants.dart';

final _env = Platform.environment;

Credentials? get _pubCredentials {
  // Get credentials from Env var if it exists
  if (_env['PUB_CREDENTIALS'] != null) {
    return Credentials.fromJson(_env['PUB_CREDENTIALS'] as String);
  }

  // If not try to get from credentials file
  if (!credentialsFile.existsSync()) {
    return null;
  }
  final json = credentialsFile.readAsStringSync();
  return Credentials.fromJson(json);
}

/// Pub client
// Null will use clients default
final pubClient = PubClient(
  pubUrl: _env['PUB_HOSTED_URL'],
  credentials: _pubCredentials,
);
