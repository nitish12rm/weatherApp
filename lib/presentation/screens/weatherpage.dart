import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/data/model/forcast.dart';
import 'package:weatherapp/data/model/weather.dart';
import 'package:weatherapp/repository/weatherCoordRepository.dart';
import 'package:weatherapp/repository/weatherForecastRepository.dart';
import 'package:weatherapp/repository/weatherRepository.dart';

class weatherPage extends StatefulWidget {
  Position? pos;

  weatherPage({super.key, required this.pos});

  @override
  State<weatherPage> createState() => _weatherPageState();
}

class _weatherPageState extends State<weatherPage> {
  weatherCoordRepository weatherCoord = weatherCoordRepository();
  weatherRepository weather = weatherRepository();
  weatherModel weatherData = weatherModel();
  weatherForecastRepository forecast = weatherForecastRepository();

  // weatherForecastModel forecastData = weatherForecastModel();

  TextEditingController city = TextEditingController();

  Future<dynamic> data() {
    return weatherCoord.getWeatherInfo(
        widget.pos!.latitude.toString(), widget.pos!.longitude.toString());
  }

  Future<dynamic> Fielddata(String city) {
    return weather.getWeatherInfo(city.toString());
  }

  Future<dynamic> forecastData1() {
    return forecast.getForecast(
        widget.pos!.latitude.toString(), widget.pos!.longitude.toString());
  }

  Future<dynamic> forecastData2() {
    return forecast.getForecast(
        weatherData.coord!.lat.toString(), weatherData.coord!.lon.toString());
  }

  @override
  Widget build(BuildContext context) {
    var screen_width = MediaQuery.sizeOf(context).width;
    return Center(
      child: Container(
        child: Column(
          children: [
            Container(
              width: screen_width * .9,
              child: TextField(
                onSubmitted: (city) async {
                  weatherData =
                      await weather.getWeatherInfo(city.trim().toString());

                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'city...',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 5,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 5,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                controller: city,
              ),
            ),
            FutureBuilder(
              future: Future.wait([
                city.text == ''
                    ? data()
                    : Fielddata(city.text.trim().toString()),
                city.text == '' ? forecastData1() : forecastData2()
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 30),
                        child: Container(
                          width: 330,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshot.data![0]!.name.toString(),
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data![0].main!.temp!.toInt().toString()}°',
                                    style: TextStyle(fontSize: 80),
                                  ),
                                  Container(
                                    height: 70,
                                    width: 70,
                                    child: Image.network(
                                        'https://openweathermap.org/img/wn/${snapshot.data![0].weather[0].icon}@2x.png'),
                                  ),
                                  Text(snapshot.data![0].weather![0].main
                                      .toString()),
                                  Text(
                                      "H:${snapshot.data![0].main!.tempMax!.toInt().toString()}°  L:${snapshot.data![0]!.main!.tempMin!.toInt().toString()}°"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Today',
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        width: screen_width * .9,
                        height: 150,
                        child: Card(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data![1].hourly!.length > 12
                                ? 12
                                : snapshot.data![1].hourly!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat('jm').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                (snapshot
                                                            .data![1]
                                                            .hourly![index]
                                                            .dt ??
                                                        0) *
                                                    1000)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 50,
                                        width: 50,
                                        child: Image.network(
                                            'https://openweathermap.org/img/wn/${snapshot.data![1].hourly[index].weather[0].icon}@2x.png'),
                                      ),
                                      Text(
                                          '${snapshot.data![1].hourly![index].temp.toString()}°'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Next day',
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        width: screen_width * .9,
                        child: Card(
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data![1].daily!.length > 7
                                ? 7
                                : snapshot.data![1].daily!.length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 1,
                                      ),
                                      Text(
                                        DateFormat('EEE').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              (snapshot.data![1].daily![index]
                                                          .dt ??
                                                      0) *
                                                  1000),
                                        ),
                                      ),
                                      Text(
                                          '${snapshot.data![1].daily![index].temp!.max.toString()}°'),
                                      Text(
                                          '${snapshot.data![1].daily![index].temp!.min.toString()}°'),
                                      SizedBox(
                                        width: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
