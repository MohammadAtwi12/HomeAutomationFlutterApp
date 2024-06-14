import 'package:flicky/features/devices/devices.dart';
import 'package:flicky/features/lighting/lighting.dart';
import 'package:flicky/features/security/security.dart';
import 'package:flicky/features/temperature/temperature.dart';
import 'package:flicky/helpers/utils.dart';
import 'package:flicky/styles/colors.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {

  static const String route = '/home';
  const HomePage({super.key});
  

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        backgroundColor:const Color.fromARGB(255,242,245,236),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: HomeAutomationColors.lightScaffoldBackground,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 35),
                    child: Icon(
                      FlickyIcons.flickylight,
                      size: 60.0,
                      color: HomeAutomationColors.lightPrimary,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Icon(
                    FlickyIcons.flicky,
                    color: HomeAutomationColors.lightPrimary,
                    size: 50,
                  )
                ],
              ),
            ),
            // Customized menu buttons
            _buildCustomMenuButton(Icons.home, 'Home', 0),
            const SizedBox(height: 16.0),
            _buildCustomMenuButton(Icons.settings, 'Settings', 1),
            const SizedBox(height: 16.0),
            _buildCustomMenuButton(Icons.info, 'Info', 2),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar with menu button and logo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: HomeAutomationColors.lightPrimary,
                    size: 45.0,
                  ),
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 50.0),
                  child: Row(
                    children: [
                      Icon(
                        FlickyIcons.flickylight,
                        size: 45.0,
                        color: HomeAutomationColors.lightPrimary,
                      ),
                      SizedBox(width: 8.0),
                      Icon(
                        FlickyIcons.flicky,
                        color: HomeAutomationColors.lightPrimary,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Hi Alex text
            /*const Center(
              child: Text(
                'Welcome Mohammad',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: HomeAutomationColors.lightPrimary),
              ),
            ),*/
            const SizedBox(height: 16.0),
            // Buttons section
            Expanded(
              child: Column(
                children: [
                  _buildExpandedButton(FlickyIcons.lamp, FlickyIcons.light1,
                      'Lighting', 0, context),
                  const SizedBox(height: 16.0),
                  _buildExpandedButton(Icons.device_thermostat, FlickyIcons.fan,
                      'Temperature', 1, context),
                  const SizedBox(height: 16.0),
                  _buildExpandedButton(
                      Icons.tv, FlickyIcons.ac, 'Devices', 2, context),
                  const SizedBox(height: 16.0),
                  _buildExpandedButton(
                      Icons.camera, Icons.security, 'Security', 3, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedButton(IconData icon1, IconData icon2, String text,
      int index, BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            iconColor: HomeAutomationColors.lightPrimary,
          ),
          onPressed: () {
            // Navigate to the corresponding page
            switch (index) {
              case 0:
                GoRouter.of(Utils.mainNav.currentContext!).go(LightingPage.route);
                break;
              case 1:
                GoRouter.of(Utils.mainNav.currentContext!).go(TemperaturePage.route);
                break;
              case 2:
                GoRouter.of(Utils.mainNav.currentContext!).go(DevicesPage.route);
                break;
              case 3:
                GoRouter.of(Utils.mainNav.currentContext!).go(SecurityPage.route);
                break;
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: index.isOdd
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(icon1, size: 35.0),
                    ),
                    Icon(icon2, size: 35.0),
                  ],
                ),
              ),
              Align(
                alignment:
                    index.isOdd ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    text,
                    style: const TextStyle(
                        fontSize: 25.0,
                        color: HomeAutomationColors.lightPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomMenuButton(IconData icon, String text , int index ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0), // Set vertical padding
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Icon(
            icon,
            color: HomeAutomationColors.lightPrimary,
            size: 50,
          ),
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 20.0,
            fontFamily: 'Product Sans Bold',
            fontWeight: FontWeight.bold,
            color: HomeAutomationColors.lightPrimary,
          ),
        ),
        onTap: () {
          switch (index) {
              case 0:
                GoRouter.of(Utils.mainNav.currentContext!).go(HomePage.route);
                break;
              case 1:
                GoRouter.of(Utils.mainNav.currentContext!).go(TemperaturePage.route);
                break;
              case 2:
                GoRouter.of(Utils.mainNav.currentContext!).go(DevicesPage.route);
                break;
            }
        },
      ),
    );
  }
}