import 'package:dio/dio.dart';
import 'package:weatherapp/data/model/weather.dart';
import 'package:weatherapp/repository/api/api.dart';

class weatherCoordRepository {
  // String city = 'sasaram';
  API api = API();
  Future<weatherModel> getWeatherInfo(String lat, String lon) async {
    try {
      Response response = await api.sendRequest.get(
          "/2.5/weather?lat=$lat&lon=$lon&appid=88155f8418daa04f95452bcecfe653b0&units=metric");
      var json = response.data;
      return weatherModel.fromJson(json);
    } catch (e) {
      throw e;
    }
  }
}
