import 'package:firebase_database/firebase_database.dart';
import 'package:flicky/features/landing/home.page.dart';
import 'package:flicky/helpers/utils.dart';
import 'package:flicky/styles/colors.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DevicesPage extends StatelessWidget {
  static const String route = '/device';
  const DevicesPage({super.key});

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
              padding: EdgeInsets.only(top: 40.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FlickyIcons.ac,
                      size: 100,
                      color: HomeAutomationColors.lightPrimary,
                    ),
                    SizedBox(
                        height:
                            10), // Adding some space between the icon and text
                    Text(
                      "Devices",
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

            const Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      DeviceController(
                          index: 1,
                          icon: Icons.tv,
                          name: "TV"),
                      DeviceController(
                          index: 2,
                          icon: FlickyIcons.ac,
                          name: "AC"),
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

class DeviceController extends StatefulWidget {
  final int index;
  final IconData icon;
  final String name;

  const DeviceController({
    super.key,
    required this.index,
    required this.icon,
    required this.name,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DeviceControllerState createState() => _DeviceControllerState();
}

class _DeviceControllerState extends State<DeviceController> {
  final bool _isLoading = false;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  _toggle(key) async {
    // Update 'switch' key in the database
    final deviceRef = _database.child(widget.name);
    final switchRef = deviceRef.child('$key');
    switchRef.set(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 242, 245, 236),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: _isLoading // Show loading indicator while fetching data
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icon, // Use widget.icon here
                        size: 50,
                        color: HomeAutomationColors.lightPrimary,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: HomeAutomationColors.lightPrimary,
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.power_settings_new),
                  iconSize: 80.0,
                  color: HomeAutomationColors.lightPrimary,
                  onPressed: () => _toggle('state'),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _toggle('Down'),
                      color: HomeAutomationColors.lightPrimary,
                      iconSize: 70,
                    ),
                    const SizedBox(width: 18.0),
                    const SizedBox(width: 18.0),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _toggle('Up'),
                      color: HomeAutomationColors.lightPrimary,
                      iconSize: 70,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

