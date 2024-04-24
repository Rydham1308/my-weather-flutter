

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/api/remote_services.dart';
import 'package:my_weather_app/constants/sp_keys.dart';
import 'package:my_weather_app/screens/background.dart';
import 'package:my_weather_app/model/card_model.dart';
import 'package:my_weather_app/screens/home_screen/weather_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/model_class.dart';
import 'bottomsheet.dart';

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
              } else if (snapshot.data?.status == ApiStatus.cityNotAvailable) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                            ),
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: const GetBottomSheet(),
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.white38,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        minimumSize: const Size(250, 50),
                      ),
                      child: const Text(
                        'Search City',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Color(0xFF444E72),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.data?.status == ApiStatus.networkError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_tethering_error_rounded_rounded,
                      size: 69,color: Colors.white,
                    ),
                    const Text(
                      'Network Error',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30,color: Colors.white),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 23, bottom: 15),
                      // alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () async {
                          getCity();
                        },
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: const StadiumBorder(),
                          minimumSize: const Size(150, 40),
                        ),
                        child: const Text(
                          "Retry",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                      ),
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

                return (snapshot.data/*?.weatherMainResult?.name*/) != null
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
                        refreshCallBack: () async {
                          try{
                            List<Location> locations = await locationFromAddress(cityName ?? 'Ahmedabad');
                            RemoteServices.getWeather(locations);
                          }catch(_){
                            RemoteServices.apiHelperStream.add(ApiHelper(status: ApiStatus.networkError));
                          }

                        },
                      )

                    //#region -- Error Msg from api
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.not_interested_rounded,
                              size: 40,
                            ),
                            const Text(
                              'Enter Valid City Name!!',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                            //#region -- Button
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            topLeft: Radius.circular(30)),
                                      ),
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding: MediaQuery.of(context).viewInsets,
                                          child: const GetBottomSheet(),
                                        );
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.white38,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  minimumSize: const Size(250, 50),
                                ),
                                child: const Text(
                                  'Search City',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                    color: Color(0xFF444E72),
                                  ),
                                ),
                              ),
                            )
                            //endregion
                          ],
                        ),
                      );
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
    try{
      List<Location> locations = await locationFromAddress(cityName ?? 'Ahmedabad');
      RemoteServices.getWeather(locations);
    }catch(_){
      RemoteServices.apiHelperStream.add(ApiHelper(status: ApiStatus.networkError));
    }
    // return cityName ?? '';
  }
}
