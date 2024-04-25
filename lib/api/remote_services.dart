import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rxdart/rxdart.dart';
import 'model_class.dart';

class RemoteServices {
  static const String key = 'API_KEY';
  static const String uri = 'https://api.openweathermap.org/data/2.5/weather';
  static BehaviorSubject<ApiHelper> apiHelperStream = BehaviorSubject<ApiHelper>();

  static BehaviorSubject<bool> apiHelperBoolStream = BehaviorSubject<bool>();

  static Future<void> getWeather(List<Location>? locations) async {
    RemoteServices.apiHelperBoolStream.add(true);
    try {
      final dio = Dio();
      final response = await dio.get(uri, queryParameters: {
        'lat': locations?[0].latitude ?? 23.022,
        'lon': locations?[0].longitude ?? 72.54,
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
      } else {
        RemoteServices.apiHelperStream.add(ApiHelper(status: ApiStatus.isError));
      }

      //endregion
    } on SocketException catch (_) {
      RemoteServices.apiHelperStream.add(ApiHelper(status: ApiStatus.networkError));
    }
  }
}
