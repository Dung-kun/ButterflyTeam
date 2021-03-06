import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/AuthenticController.dart';
import 'package:flutter_application_1/controllers/MainController.dart';
import 'package:flutter_application_1/controllers/SettingController.dart';
import 'package:flutter_application_1/views/StockChart/chartBuilder.dart';
import 'package:flutter_application_1/views/favorite/fav_link.dart';
import 'package:flutter_application_1/views/home/home_link.dart';
import 'package:flutter_application_1/views/main/loading_screen.dart';
import 'package:flutter_application_1/views/person/person_link.dart';
import 'package:flutter_application_1/views/weather/weather_view.dart';
import 'package:get/get.dart';

final _settingController = Get.find<SettingController>();

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

// ignore: must_be_immutable
class _MainScreenState extends State<MainScreen> {
  var _authenticController = Get.find<AuthenticController>();
  final _mainController = Get.find<MainController>();

  @override
  void initState() {
    _mainController.firestoreConnect = _authenticController.initilizeFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return  FutureBuilder(
      future: _mainController.firestoreConnect,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Error!")));
        }

        // Once complete, show your application
        else if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: true,
            body: SafeArea(
              child: Obx(() => (_mainController.currentIndex.value == 0)
                  ? HomeLink()
                  : (_mainController.currentIndex.value == 1)
                      ? FavoriteLink()
                      : (_mainController.currentIndex.value == 2)
                          ? WeatherView()
                          : (_mainController.currentIndex.value == 3)
                              ? Chart()
                              : (_mainController.currentIndex.value == 4)
                                  ? PersonLink()
                                  : Container(
                                      color: _settingController
                                          .kPrimaryColor.value
                                          .withOpacity(.1),
                                      child: Center(
                                        child: Text("Underdevelopment"),
                                      ),
                                    )),
            ),
            bottomNavigationBar:
                Obx(() => myBar(_mainController.currentIndex.value)),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }

  CustomNavigationBar myBar(int i) {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: _settingController.kPrimaryColor.value,
      strokeColor: _settingController.kPrimaryColor.value,
      unSelectedColor: Color(0xffacacac),
      backgroundColor: Colors.white,
      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.home),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.favorite),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.cloud),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.account_circle),
        ),
      ],
      currentIndex: i,
      onTap: (index) {
        _mainController.currentIndex.value = index;
      },
    );
  }
}
