import 'package:firebase_database/firebase_database.dart';
import 'package:flicky/features/lighting/lighting.dart';
import 'package:flicky/styles/temphumstyle.dart';
import 'package:flutter/material.dart';
import 'package:flicky/helpers/utils.dart';
import 'package:flicky/styles/colors.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';
import 'package:flicky/features/landing/home.page.dart';
import 'package:go_router/go_router.dart';

class TemperaturePage extends StatefulWidget {
  static const String route = '/temp';
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> tempAnimation;
  late Animation<double> humidityAnimation;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    tempAnimation = Tween<double>(begin: 0, end: 32).animate(_controller);
    humidityAnimation = Tween<double>(begin: 0, end: 69).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.forward();

    _dbRef.child('Temp').onValue.listen((event) {
      final int newTemp = (event.snapshot.value as int?) ?? 0;
      _updateTemperature(newTemp.toDouble());
    });

    _dbRef.child('Hum').onValue.listen((event) {
      final int newHum = (event.snapshot.value as int?) ?? 0;
      _updateHumidity(newHum.toDouble());
    });
  }

  void _updateTemperature(double newTemp) {
    setState(() {
      tempAnimation = Tween<double>(begin: tempAnimation.value, end: newTemp)
          .animate(_controller);
      _controller.reset();
      _controller.forward();
    });
  }

  void _updateHumidity(double newHum) {
    setState(() {
      humidityAnimation =
          Tween<double>(begin: humidityAnimation.value, end: newHum)
              .animate(_controller);
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 242, 245, 236),
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
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.thermostat,
                      size: 100,
                      color: HomeAutomationColors.lightPrimary,
                    ),
                    SizedBox(
                        height:
                            10), // Adding some space between the icon and text
                    Text(
                      "Temperature",
                      style: TextStyle(
                        fontSize: 50,
                        color: HomeAutomationColors.lightPrimary,
                        fontFamily: 'Product Sans',
                      ),
                      textAlign: TextAlign
                          .center, // Align text center within the Column
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 45.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate size based on screen width
                    double boxSize =
                        constraints.maxWidth * 0.45; // 40% of screen width
                    double fontSize = boxSize *
                        0.25; // Adjust this multiplier to fit your design
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CustomPaint(
                          foregroundPainter:
                              CircleProgress(tempAnimation.value, true),
                          child: Container(
                            width: boxSize,
                            height: boxSize,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 242, 245, 236),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FittedBox(
                                    child: Text(
                                      'Temperature',
                                      style: TextStyle(
                                          fontSize: fontSize *
                                              0.25), // Adjust this multiplier to fit your design
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      '${tempAnimation.value.toInt()}',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      '°C',
                                      style: TextStyle(
                                        fontSize: fontSize * 0.3,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        CustomPaint(
                          foregroundPainter:
                              CircleProgress(humidityAnimation.value, false),
                          child: Container(
                            width: boxSize,
                            height: boxSize,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 242, 245, 236),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FittedBox(
                                    child: Text(
                                      'Humidity',
                                      style: TextStyle(
                                          fontSize: fontSize *
                                              0.25), // Adjust this multiplier to fit your design
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      '${humidityAnimation.value.toInt()}',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      '%',
                                      style: TextStyle(
                                        fontSize: fontSize * 0.3,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      CustomSwitchWidget(
                          index: 1, icon: FlickyIcons.fan, name: "Living Room Fan"),
                      CustomSwitchWidget(
                          index: 2, icon: FlickyIcons.fan, name: "Bedroom Fan"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomMenuButton(IconData icon, String text, int index) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 20.0), // Set vertical padding
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
              //GoRouter.of(Utils.mainNav.currentContext!).go(TemperaturePage.route);
              break;
            case 2:
              //GoRouter.of(Utils.mainNav.currentContext!).go(DevicesPage.route);
              break;
          }
        },
      ),
    );
  }
}
