import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/logic/cubits/weather_cubits/weather_cubit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/presentation/screens/homepage.dart';
import 'package:flutter/services.dart';

Position? position;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  LocationPermission permission = await Geolocator.requestPermission();
  position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => weatherCubit(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: homePage(pos: position),
      ),
    );
  }
}
