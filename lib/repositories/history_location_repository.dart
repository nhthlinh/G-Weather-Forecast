import 'package:hive/hive.dart';
import 'package:g_feather_forecast/models/location_model.dart';

class HistoryLocationRepository {
  static const String _boxName = 'location_history';

  Future<void> init() async {
    await Hive.openBox<List>(_boxName); // Box chứa Map<String, List<LocationModel>>
  }

  Future<List<LocationModel>> getHistoryLocation() async {
    final box = Hive.box<List>(_boxName);
    final today = DateTime.now().toIso8601String().split("T").first;

    final List? storedList = box.get(today);
    if (storedList != null) {
      return storedList.cast<LocationModel>();
    }
    return [];
  }

  Future<void> saveHistoryLocation(LocationModel location) async {
    final box = Hive.box<List>(_boxName);
    final today = DateTime.now().toIso8601String().split("T").first;

    final existingList = box.get(today)?.cast<LocationModel>() ?? [];

    // Thêm location mới nếu chưa có
    final updatedList = [...existingList, location];
    await box.put(today, updatedList);
  }
}
