
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:my_weather_app/api/remote_services.dart';
import 'package:my_weather_app/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/sp_keys.dart';

class GetBottomSheet extends StatefulWidget {
  const GetBottomSheet({super.key});

  @override
  State<GetBottomSheet> createState() => _GetBottomSheetState();
}

class _GetBottomSheetState extends State<GetBottomSheet> {
  TextEditingController txtCity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 23, bottom: 15, top: 23),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Search city name",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.blue),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 23, left: 23, bottom: 20),
            child: TextFormField(
              controller: txtCity,
              cursorColor: Colors.blue,
              style: const TextStyle(color: Colors.blue),
              decoration: const InputDecoration(
                labelText: 'City',
                labelStyle: TextStyle(
                  color: Colors.blue,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 23, bottom: 15),
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () async {
                try{
                  List<Location> locations = await locationFromAddress(txtCity.text.trim());

                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.setString(SpKeys.cityKey, txtCity.text.trim());

                  RemoteServices.getWeather(locations);
                  Future.delayed(Duration.zero).then((value) => Navigator.pop(context));
                }catch(e){
                  Future.delayed(Duration.zero).then((value) => Navigator.pop(context));

                  Future.delayed(Duration.zero).then(
                        (value) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text(
                          'Enter valid city-name',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                        ),
                        duration: Duration(milliseconds: 1500),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                backgroundColor: MyColors.mainLightAppColor2,
                elevation: 0,
                shape: const StadiumBorder(),
                minimumSize: const Size(150, 40),
              ),
              child: const Text(
                "Search",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
