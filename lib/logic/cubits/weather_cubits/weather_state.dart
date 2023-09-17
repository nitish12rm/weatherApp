import 'package:weatherapp/data/model/forcast.dart';
import 'package:weatherapp/data/model/weather.dart';

abstract class weatherState {}

class internetGained extends weatherState {}

class internetLost extends weatherState {}

class weatherLoadingState extends weatherState {}

class weatherLoadedState extends weatherState {
  final weatherForecastModel forcastmodel;
  final weatherModel weatherData;
  weatherLoadedState(this.forcastmodel, this.weatherData);
}

class weatherSearchLoadedState extends weatherState {
  final weatherForecastModel forcastmodel;
  final weatherModel weatherData;
  weatherSearchLoadedState(this.forcastmodel, this.weatherData);
}

class weatherErrorState extends weatherState {
  final String error;
  weatherErrorState(this.error);
}
