import 'package:g_feather_forecast/configs/config.dart';
import 'package:g_feather_forecast/models/location_model.dart';

class LocationRepository {
  Future<List<LocationModel>> fetchLocation(String query) async {
    final response = await DioConfig.dio.get("/search.json?q=$query");
    if (response.statusCode == 200) {
      return response.data
          .map<LocationModel>((json) => LocationModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load location");
    }
  }
}
