import 'package:dio/dio.dart';
import 'package:weatherapp/data/model/weather.dart';
import 'package:weatherapp/repository/api/api.dart';

class weatherRepository {
  // String city = 'sasaram';
  API api = API();
  Future<weatherModel> getWeatherInfo(String city) async {
    try {
      Response response = await api.sendRequest.get(
          "/2.5/weather?q=$city&appid=88155f8418daa04f95452bcecfe653b0&units=metric");
      var json = response.data;
      return weatherModel.fromJson(json);
    } catch (e) {
      throw e;
    }
  }
}
