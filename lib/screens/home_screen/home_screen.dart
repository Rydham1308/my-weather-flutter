import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/api/remote_services.dart';
import 'package:my_weather_app/constants/sp_keys.dart';
import 'package:my_weather_app/screens/background.dart';
import 'package:my_weather_app/model/card_model.dart';
import 'package:my_weather_app/screens/home_screen/weather_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/model_class.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: false);
  late final Animation<double> animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  String? cityName;

  @override
  void initState() {
    super.initState();
    getCity();
    RemoteServices.apiHelperStream.add(ApiHelper(status: ApiStatus.isLoading));

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const BackGroundScreen(),
          StreamBuilder(
            stream: RemoteServices.apiHelperStream,
            builder: (context, snapshot) {
              if (snapshot.data?.status == ApiStatus.isLoading) {
                return Center(
                    child: Image.asset(
                  'assets/images/wired-outline-1-cloud.gif',
                  scale: 4,
                ));
              } else if (snapshot.data?.status == ApiStatus.isError) {
                return const Center(child: Text('No Data'));
              } else if (snapshot.data?.status == ApiStatus.networkError) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_tethering_error_rounded_rounded,
                      size: 40,
                    ),
                    Text(
                      'Network Error',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ],
                );
              } else if (snapshot.data?.status == ApiStatus.isLoaded) {
                //#region -- Data Shorting
                final dateTime = DateTime.fromMillisecondsSinceEpoch(
                    (snapshot.data?.weatherMainResult?.dt ?? 0) * 1000);
                final dateFormatter = DateFormat('dd MMMM');
                final formattedDate = dateFormatter.format(dateTime);
                var cityName = snapshot.data?.weatherMainResult?.name;
                var temp = (snapshot.data?.weatherMainResult?.mainModel.temp)?.round();
                var description = snapshot.data?.weatherModel?[0].main;
                var wind = ((snapshot.data?.weatherMainResult?.windModel.speed ?? 0) * 3.6).round();
                var hum = snapshot.data?.weatherMainResult?.mainModel.humidity;

                // final timeFormatter = DateFormat('h : mm');
                // final formattedTime = timeFormatter.format(dateTime);

                //endregion

                return (snapshot.data) != null
                    ? WeatherCard(
                        controller: _controller,
                        model: CardModel(
                          cityName: cityName,
                          time: formattedDate,
                          temp: temp,
                          description: description,
                          wind: wind,
                          hum: hum,
                        ),
                        refreshCallBack: () {
                          RemoteServices.getWeather(cityName);
                        },
                      )

                    //#region -- Error Msg from api
                    : const Center(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.not_interested_rounded,
                            size: 40,
                          ),
                          Text(
                            'No Data Found',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                        ],
                      ));
                //endregion
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Future<void> getCity() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    cityName = sp.getString(SpKeys.cityKey);
    RemoteServices.getWeather(cityName);
    // return cityName ?? '';
  }
}