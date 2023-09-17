import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/data/model/forcast.dart';
import 'package:weatherapp/data/model/weather.dart';
import 'package:weatherapp/logic/cubits/weather_cubits/weather_state.dart';
import 'package:weatherapp/repository/weatherForecastRepository.dart';
import 'package:weatherapp/repository/weatherCoordRepository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';

Connectivity connectivity = Connectivity();
StreamSubscription? connectivitySubscription;

class weatherCubit extends Cubit<weatherState> {
  weatherCubit() : super(weatherLoadingState()) {
    fetchWeather();
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        emit(internetGained());
      } else {
        emit(internetLost());
      }
    });
    @override
    Future<void> close() {
      connectivitySubscription?.cancel();
      return super.close();
    }
  }
  weatherForecastRepository forecast = weatherForecastRepository();
  weatherCoordRepository weather = weatherCoordRepository();
  void fetchWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      weatherForecastModel forecastData = await forecast.getForecast(
          position.latitude.toString(), position.longitude.toString());
      weatherModel weatherData = await weather.getWeatherInfo(
          position.latitude.toString(), position.longitude.toString());
      emit(weatherLoadedState(forecastData, weatherData));
    } on DioException catch (ex) {
      emit(weatherErrorState(ex.type.toString()));
    }
  }
}
