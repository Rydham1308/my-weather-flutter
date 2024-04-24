import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_weather_app/constants/colors.dart';
import 'package:my_weather_app/screens/home_screen/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Weather',
      theme: ThemeData(
        fontFamily: 'Overpass',
        colorScheme: ColorScheme.fromSeed(
            seedColor: MyColors.mainLightAppColor1),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
