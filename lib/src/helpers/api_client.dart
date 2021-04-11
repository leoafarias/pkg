import 'dart:io';

import 'package:pub_api_client/pub_api_client.dart';

final _env = Platform.environment;

/// Pub client
// Null will use clients default
final pubClient = PubClient(pubUrl: _env['PUB_HOSTED_URL'] ?? null);
