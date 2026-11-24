import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'simbrief_ofp.dart';

/// Fetches the latest OFP of a SimBrief user. Needs no API key, only the
/// username or the numeric pilot ID.
class SimbriefClient {
  SimbriefClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static Uri latestOfpUri(String user) {
    final u = user.trim();
    return Uri.https('www.simbrief.com', '/api/xml.fetcher.php', {
      // A pilot ID is all digits; usernames can't be.
      if (RegExp(r'^\d+$').hasMatch(u)) 'userid': u else 'username': u,
      'json': '1',
    });
  }

  /// Throws [SimbriefException] with SimBrief's message for unknown users,
  /// and [SimbriefOfflineException] when SimBrief can't be reached.
  Future<SimbriefOfp> latestOfp(String user) async {
    final http.Response response;
    try {
      response = await _client
          .get(latestOfpUri(user))
          .timeout(const Duration(seconds: 20));
    } on http.ClientException {
      throw const SimbriefOfflineException();
    } on TimeoutException {
      throw const SimbriefOfflineException();
    }
    if (response.statusCode >= 500) throw const SimbriefOfflineException();
    // SimBrief answers unknown users with 400 and a status message.
    return SimbriefOfp.parseResponse(utf8.decode(response.bodyBytes));
  }
}

class SimbriefOfflineException implements Exception {
  const SimbriefOfflineException();
}
