enum ApiStatus { isLoaded, isLoading, isError, networkError, cityNotAvailable }

class ApiHelper {
  final ApiStatus status;
  WeatherMainModel? weatherMainResult;
  List<WeatherModel>? weatherModel;

  ApiHelper({
    required this.status,
    this.weatherMainResult,
    this.weatherModel,
  });
}

class WeatherMainModel {
  final String base;
  final num visibility;
  final num timezone;
  final String name;
  final int dt;
  final num id;
  final num cod;
  final MainModel mainModel;
  final WindModel windModel;
  final CoordModel coordModel;
  final CloudsModel cloudsModel;
  final SysModel sysModel;

  // final List<WeatherModel> weatherModel;

  WeatherMainModel({
    required this.name,
    required this.dt,
    required this.timezone,
    required this.base,
    required this.visibility,
    required this.id,
    required this.cod,
    required this.mainModel,
    required this.windModel,
    required this.coordModel,
    required this.cloudsModel,
    required this.sysModel,
    // required this.weatherModel,
  });

  WeatherMainModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        dt = json['dt'],
        timezone = json['timezone'],
        base = json['base'],
        cod = json['cod'],
        id = json['id'],
        visibility = json['visibility'],
        mainModel = MainModel.fromJson(json['main']),
        windModel = WindModel.fromJson(json['wind']),
        coordModel = CoordModel.fromJson(json['coord']),
        cloudsModel = CloudsModel.fromJson(json['clouds']),
        sysModel = SysModel.fromJson(json['sys']);
// weatherModel = List<WeatherModel>.from(json['weather'].map((x) => WeatherModel.fromJson(x)));
}

class MainModel {
  final num temp;
  final num feelsLike;
  final num tempMin;
  final num tempMax;
  final num pressure;
  final num humidity;

  MainModel({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  MainModel.fromJson(Map<String, dynamic> json)
      : temp = json['temp'],
        feelsLike = json['feels_like'],
        tempMax = json['temp_max'],
        tempMin = json['temp_min'],
        pressure = json['pressure'],
        humidity = json['humidity'];
}

class WindModel {
  final num speed;
  final num deg;

  WindModel({required this.speed, required this.deg});

  WindModel.fromJson(Map<String, dynamic> json)
      : speed = json['speed'],
        deg = json['deg'];
}

class CoordModel {
  final num lon;
  final num lat;

  CoordModel({
    required this.lon,
    required this.lat,
  });

  CoordModel.fromJson(Map<String, dynamic> json)
      : lat = json['lat'],
        lon = json['lon'];
}

class CloudsModel {
  final num all;

  CloudsModel({required this.all});

  CloudsModel.fromJson(Map<String, dynamic> json) : all = json['all'];
}

class SysModel {
  // final num type;
  // final num id;
  final num sunrise;
  final num sunset;

  // final String country;

  SysModel({
    // required this.type,
    // required this.id,
    required this.sunrise,
    required this.sunset,
    // required this.country,
  });

  SysModel.fromJson(Map<String, dynamic> json)
      : /*id = json['id'],
        country = json['country'],
        type = json['type'],*/
        sunrise = json['sunrise'],
        sunset = json['sunset'];
}

class WeatherModel {
  final String main;
  final String description;
  final String icon;
  final num id;

  WeatherModel({
    required this.main,
    required this.icon,
    required this.id,
    required this.description,
  });

  WeatherModel.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        id = json['id'],
        main = json['main'],
        icon = json['icon'];
}
