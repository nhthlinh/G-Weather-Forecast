import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:g_feather_forecast/models/location_model.dart';
import 'package:universal_html/html.dart' as html;

abstract class HistoryLocationRepository {
  Future<List<LocationModel>> getHistoryLocation();
  Future<void> saveHistoryLocation(LocationModel location);
}

class WebHistoryLocationRepository extends HistoryLocationRepository {
  static const String _prefix = 'location_history_';

  @override
  Future<List<LocationModel>> getHistoryLocation() async {
    final today = DateTime.now().toIso8601String().split("T").first;
    final jsonString = html.window.localStorage['$_prefix$today'];

    if (jsonString != null) {
      final decoded = json.decode(jsonString) as List;
      return decoded.map((e) => LocationModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<void> saveHistoryLocation(LocationModel location) async {
    final today = DateTime.now().toIso8601String().split("T").first;
    final existing = await getHistoryLocation();

    final alreadyExists = existing.any((loc) => loc == location);
    if (!alreadyExists) {
      existing.add(location);
      final encoded = json.encode(existing.map((e) => e.toJson()).toList());
      html.window.localStorage['$_prefix$today'] = encoded;
    }
  }
}

class MobileHistoryLocationRepository extends HistoryLocationRepository {
  static const String _prefix = 'location_history_';

  @override
  Future<List<LocationModel>> getHistoryLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split("T").first;

    final jsonString = prefs.getString('$_prefix$today');
    if (jsonString != null) {
      final decoded = json.decode(jsonString) as List;
      return decoded.map((e) => LocationModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<void> saveHistoryLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split("T").first;

    final existing = await getHistoryLocation();

    // Check duplicate
    final alreadyExists = existing.any((loc) => loc == location);
    if (!alreadyExists) {
      existing.add(location);
      final encoded = json.encode(existing.map((e) => e.toJson()).toList());
      await prefs.setString('$_prefix$today', encoded);
    }
  }
}
