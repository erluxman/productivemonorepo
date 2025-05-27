import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/features/feed/models/feed_item.dart';

final feedProvider = FutureProvider<List<FeedItem>>((ref) async {
  // Load JSON file
  final String jsonString =
      await rootBundle.loadString('assets/data/feed_data.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);

  // Convert JSON to List<FeedItem>
  final List<dynamic> feedItemsJson = jsonData['feedItems'];
  return feedItemsJson.map((json) => FeedItem.fromJson(json)).toList();
});
