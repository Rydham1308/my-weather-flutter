
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_weather_app/api/remote_services.dart';
import 'package:my_weather_app/model/card_model.dart';
import 'package:my_weather_app/screens/home_screen/bottomsheet.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard(
      {super.key, required this.model, required this.refreshCallBack, required this.controller});

  final CardModel model;
  final VoidCallback refreshCallBack;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //#region -- Header
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 17, right: 10),
                    child: Icon(
                      Icons.location_on_outlined,
                      size: 24,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0.0, 3.0),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "${model.cityName}",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(-2.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: refreshCallBack,
                child: StreamBuilder<bool>(
                  stream: RemoteServices.apiHelperBoolStream,
                  builder: (context, snapshot) => (snapshot.data ?? false)
                      ? RotationTransition(
                          turns: controller,
                          child: Transform.scale(
                            scaleX: -1,
                            // transform: Matrix4.rotationY(math.pi),
                            child: const Icon(
                              Icons.sync,
                              size: 24,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                  offset: Offset(0.0, 3.0),
                                )
                              ],
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.sync,
                          size: 24,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(0.0, 3.0),
                            )
                          ],
                        ),
                ),
              ),
            ],
          ),
          //endregion

          //#region -- Image
          Padding(
            padding: const EdgeInsets.all(40),
            child: LayoutBuilder(
              builder: (context, constraints) {
                var hour = DateTime.now().hour;
                if (model.description == 'Clouds') {
                  if (hour < 17) {
                    return Image.asset(
                      'assets/images/weather_icons/cloudy-day.png',
                      scale: 3,
                    );
                  } else {
                    return Image.asset(
                      'assets/images/weather_icons/cloudy-night.png',
                      scale: 3,
                    );
                  }
                } else if (model.description == 'Thunderstorm') {
                  return Image.asset(
                    'assets/images/weather_icons/thunder.png',
                    scale: 3,
                  );
                } else if (model.description == 'Drizzle') {
                  return Image.asset(
                    'assets/images/weather_icons/drizzle.png',
                    scale: 3,
                  );
                } else if (model.description == 'Rain') {
                  return Image.asset(
                    'assets/images/weather_icons/rain.png',
                    scale: 3,
                  );
                } else if (model.description == 'Clear') {
                  if (hour < 17) {
                    return Image.asset(
                      'assets/images/weather_icons/sun.png',
                      scale: 3,
                    );
                  } else {
                    return Image.asset(
                      'assets/images/weather_icons/night.png',
                      scale: 3,
                    );
                  }
                } else if (model.description == 'Snow') {
                  return Image.asset(
                    'assets/images/weather_icons/snowflake.png',
                    scale: 3,
                  );
                } else if (model.description == 'Tornado') {
                  return Image.asset(
                    'assets/images/weather_icons/tornado.png',
                    scale: 3,
                  );
                } else if (model.description == 'Dust') {
                  return Image.asset(
                    'assets/images/weather_icons/wind.png',
                    scale: 3,
                  );
                } else {
                  return Image.asset(
                    'assets/images/weather_icons/weather.png',
                    scale: 3,
                  );
                }
              },
            ),
          ),
          //endregion

          //#region -- card
          SizedBox(
            width: MediaQuery.of(context).size.height * 0.8,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                  color: Colors.white60,
                  width: 1.0,
                ),
              ),
              elevation: 0,
              color: Colors.white24,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Today, ${model.time}", //$formattedTime
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(-2.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${model.temp}\u00B0',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            blurRadius: 50,
                            offset: Offset(-4.0, 8.0),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "${model.description}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          shadows: [
                            Shadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(-2.0, 3.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SvgPicture.asset(
                            //   'assets/images/windy.svg',
                            //   height: 24,
                            // ),
                            Icon(
                              CupertinoIcons.wind,
                              size: 24,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                  offset: Offset(-2.0, 3.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Icon(
                              CupertinoIcons.drop,
                              size: 24,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                  offset: Offset(-2.0, 3.0),
                                ),
                              ],
                            ),
                            // SvgPicture.asset(
                            //   'assets/images/hum.svg',
                            //   height: 24,
                            // ),
                          ],
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wind',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                shadows: [
                                  Shadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(-2.0, 3.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Hum',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(-2.0, 3.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '|',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                shadows: [
                                  Shadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(-2.0, 3.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              '|',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(-2.0, 3.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${model.wind} km/h',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(-2.0, 3.0),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '${model.hum} %',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(-2.0, 3.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          //endregion

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
  }
}
