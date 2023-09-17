import 'package:dio/dio.dart';
import 'package:weatherapp/data/model/forcast.dart';
import 'package:weatherapp/repository/api/api.dart';

class weatherForecastRepository {
  API api = API();
  // String lat = '28.7041';
  // String lon = '77.1025';
  Future<weatherForecastModel> getForecast(String lat, String lon) async {
    try {
      Response response = await api.sendRequest.get(
          "/3.0/onecall?lat=$lat&lon=$lon&appid=88155f8418daa04f95452bcecfe653b0&units=metric");
      var json = response.data;
      return weatherForecastModel.fromJson(json);
    } catch (e) {
      throw e;
    }
  }
}
