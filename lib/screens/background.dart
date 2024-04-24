import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/colors.dart';

class BackGroundScreen extends StatelessWidget {
  const BackGroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //#region -- BackGround
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  MyColors.mainLightAppColor1,
                  MyColors.mainLightAppColor2
                ]),
          ),
        ),
        Positioned(
          top: 0,
          right: -35,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.height * 0.4,
            child: SvgPicture.asset(
              'assets/images/Line1.svg',
            ),
          ),
        ),
        Positioned(
          top: 92,
          left: -20,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.4,
            child: SvgPicture.asset(
              'assets/images/Line2.svg',
            ),
          ),
        ),
        //endregion
      ],
    );
  }
}
