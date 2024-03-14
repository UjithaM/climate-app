import 'package:flutter/material.dart';

import '../utilities/constants.dart';
import 'package:clime/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {

  final localWether;

  const LocationScreen({super.key, this.localWether});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  WeatherModel weatherModel = WeatherModel();

  late int temperature;
  late String weatherIcon;
  late String cityName;
  late String massage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUi(widget.localWether);
  }

  void updateUi(dynamic weatherData){
    setState(() {
      if (weatherData == null){
        temperature = 0;
        weatherIcon = 'Error';
        massage = 'Unable to get weather data';
        cityName = '';
        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      cityName = weatherData['name'];

      weatherIcon =  weatherModel.getWeatherIcon(condition);
      massage = weatherModel.getMessage(temperature);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherDate = await   weatherModel.getWeather();
                      updateUi(weatherDate);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                     var typeName = await Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CityScreen();
                      },),);
                     if (typeName != null){
                        var weatherData = await weatherModel.getCityWeather(typeName);
                        updateUi(weatherData);
                     }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                     Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  "$massage in $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
