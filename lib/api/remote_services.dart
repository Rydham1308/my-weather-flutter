import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rxdart/rxdart.dart';
import 'model_class.dart';

class RemoteServices {
  static const String key = 'f2a1a29cb719f92f4d7859ba26b1d1fb';
  static const String uri = 'https://api.openweathermap.org/data/2.5/weather';
  static BehaviorSubject<ApiHelper> apiHelperStream = BehaviorSubject<ApiHelper>();

  static BehaviorSubject<bool> apiHelperBoolStream = BehaviorSubject<bool>();

  static Future<void> getWeather(String? cityName) async {
    RemoteServices.apiHelperBoolStream.add(true);
    try {
      List<Location> locations = await locationFromAddress(cityName ?? 'Ahmedabad');

      final dio = Dio();
      final response = await dio.get(uri, queryParameters: {
        'lat': locations[0].latitude,
        'lon': locations[0].longitude,
        'units': 'metric',
        'appid': key,
      });
      if (kDebugMode) {
        print(response.requestOptions.uri);
      }
      if (response.statusCode == 200) {
        //#region --weatherMain
        final resultWeatherMain = response.data;
        if (resultWeatherMain != null) {
          final weatherMainData = WeatherMainModel.fromJson(resultWeatherMain);
          final resultWeather = (resultWeatherMain['weather'] is List)
              ? (resultWeatherMain?['weather'] ?? []) as List<dynamic>
              : null;
          final weatherData = resultWeather?.map((e) => WeatherModel.fromJson(e)).toList();
          RemoteServices.apiHelperBoolStream.add(false);
          RemoteServices.apiHelperStream.add(ApiHelper(
              status: ApiStatus.isLoaded,
              weatherMainResult: weatherMainData,
              weatherModel: weatherData));
        } else {
          RemoteServices.apiHelperStream.add(ApiHelper(status: ApiStatus.isLoaded));
        }
        //endregion
      } else {
        RemoteServices.apiHelperStream.add(ApiHelper(status: ApiStatus.isError));
        throw Exception('Failed to load album');
      }
    } on SocketException catch (e) {
      RemoteServices.apiHelperStream.add(ApiHelper(status: ApiStatus.networkError));
      throw Exception('network error : $e');
    }
  }
}
