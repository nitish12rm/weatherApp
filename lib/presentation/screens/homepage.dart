import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/logic/cubits/weather_cubits/weather_cubit.dart';
import 'package:weatherapp/logic/cubits/weather_cubits/weather_state.dart';
import 'package:weatherapp/presentation/screens/weatherpage.dart';

class homePage extends StatelessWidget {
  Position? pos;
  homePage({super.key, required this.pos});

  @override
  Widget build(BuildContext context) {
    var screen_width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Weather App"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              BlocConsumer<weatherCubit, weatherState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is weatherErrorState) {
                    SnackBar snackBar = SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                builder: (context, state) {
                  if (state is weatherLoadingState) {
                    return CircularProgressIndicator();
                  }
                  if (state is weatherLoadedState) {
                    return weatherPage(pos: pos);
                  }
                  if (state is internetGained) {
                    return weatherPage(pos: pos);
                  }
                  if (state is internetLost) {
                    return Text('Check your internet');
                  } else
                    return Center(
                      child: Text('error'),
                    );
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
