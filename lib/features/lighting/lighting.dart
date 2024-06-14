import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flicky/helpers/utils.dart';
import 'package:flicky/styles/colors.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';
import 'package:flicky/features/landing/home.page.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:go_router/go_router.dart';

class LightingPage extends StatelessWidget {
  static const String route = '/light';
  const LightingPage({super.key});

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
            const SizedBox(
              height: 50.0,
            ),

            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FlickyIcons.light2,
                    size: 100,
                    color: HomeAutomationColors.lightPrimary,
                  ),
                  SizedBox(
                      height:
                          10), // Adding some space between the icon and text
                  Text(
                    "Lights",
                    style: TextStyle(
                      fontSize: 50,
                      color: HomeAutomationColors.lightPrimary,
                      fontFamily: 'Product Sans',
                    ),
                    textAlign:
                        TextAlign.center, // Align text center within the Column
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      CustomSwitchWidget(index: 1, icon: FlickyIcons.light3, name: "Living Room"),
                      CustomSwitchWidget(index: 2, icon: FlickyIcons.light3, name: "Kitchen"),
                      CustomSwitchWidget(index: 3, icon: FlickyIcons.light3, name: "Bedroom"),
                      CustomSwitchWidget(index: 4, icon: FlickyIcons.light3, name: "Balcony"),
                      RotaryColorPicker(),
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


class CustomSwitchWidget extends StatefulWidget {
  final int index;
  final IconData icon;
  final String name;

  const CustomSwitchWidget({
    super.key,
    required this.index,
    required this.icon,
    required this.name,
  });

  @override
  _CustomSwitchWidgetState createState() => _CustomSwitchWidgetState();
}

class _CustomSwitchWidgetState extends State<CustomSwitchWidget> {
  bool _switchValue = false;
  bool _isLoading = true; // Added loading state
  final dbR = FirebaseDatabase.instance.ref();
  late DatabaseReference _switchRef;

  @override
  void initState() {
    super.initState();
    _switchRef = dbR.child("${widget.name}${widget.index}").child("Switch");
    _fetchInitialSwitchValue();
    _listenToSwitchChanges();
  }

  Future<void> _fetchInitialSwitchValue() async {
    try {
      DataSnapshot snapshot = await _switchRef.get();
      if (snapshot.exists) {
        setState(() {
          _switchValue = snapshot.value as bool;
          _isLoading = false; // Set loading to false after fetching
        });
      } else {
        setState(() {
          _isLoading = false; // Set loading to false if no data
        });
      }
    } catch (e) {
      print("Error fetching initial switch value: $e");
      setState(() {
        _isLoading = false; // Set loading to false in case of error
      });
    }
  }

  void _listenToSwitchChanges() {
    _switchRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          _switchValue = event.snapshot.value as bool;
        });
      }
    });
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
          ? Center(child: CircularProgressIndicator())
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(widget.icon, color: HomeAutomationColors.lightPrimary),
                    SizedBox(width: 8.0),
                    Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Product Sans'),
                    ),
                  ],
                ),
                Switch(
                  activeTrackColor: HomeAutomationColors.lightPrimary,
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: HomeAutomationColors.lightPrimary,
                  value: _switchValue,
                  onChanged: (bool newValue) {
                    _switchRef.set(newValue);
                    setState(() {
                      _switchValue = newValue;
                    });
                  },
                ),
              ],
            ),
    );
  }
}

/*
class CustomSwitchWidget extends StatefulWidget {
  final int index;

  CustomSwitchWidget({Key? key, required this.index}) : super(key: key);

  @override
  _CustomSwitchWidgetState createState() => _CustomSwitchWidgetState();
}

class _CustomSwitchWidgetState extends State<CustomSwitchWidget> {
  bool _switchValue = false;
  bool _isLoading = true; // Added loading state
  final dbR = FirebaseDatabase.instance.ref();
  late DatabaseReference _switchRef;

  @override
  void initState() {
    super.initState();
    _switchRef = dbR.child("Light${widget.index}").child("Switch");
    _fetchInitialSwitchValue();
    _listenToSwitchChanges();
  }

  Future<void> _fetchInitialSwitchValue() async {
    try {
      DataSnapshot snapshot = await _switchRef.get();
      if (snapshot.exists) {
        setState(() {
          _switchValue = snapshot.value as bool;
          _isLoading = false; // Set loading to false after fetching
        });
      } else {
        setState(() {
          _isLoading = false; // Set loading to false if no data
        });
      }
    } catch (e) {
      print("Error fetching initial switch value: $e");
      setState(() {
        _isLoading = false; // Set loading to false in case of error
      });
    }
  }

  void _listenToSwitchChanges() {
    _switchRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          _switchValue = event.snapshot.value as bool;
        });
      }
    });
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
          ? Center(child: CircularProgressIndicator())
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(FlickyIcons.light3, color: HomeAutomationColors.lightPrimary),
                    SizedBox(width: 8.0),
                    Text(
                      'Lamp Switch',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Product Sans'),
                    ),
                  ],
                ),
                Switch(
                  activeTrackColor: HomeAutomationColors.lightPrimary,
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: HomeAutomationColors.lightPrimary,
                  value: _switchValue,
                  onChanged: (bool newValue) {
                    _switchRef.set(newValue);
                    setState(() {
                      _switchValue = newValue;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
*/

class RotaryColorPicker extends StatefulWidget {
  @override
  _RotaryColorPickerState createState() => _RotaryColorPickerState();
}

class _RotaryColorPickerState extends State<RotaryColorPicker> {
  Color _currentColor = Colors.blue;
  final CircleColorPickerController _controller = CircleColorPickerController(
    initialColor: Colors.blue,
  );
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialColor();
  }

  Future<void> _fetchInitialColor() async {
    try {
      DataSnapshot snapshot = await dbRef.child("color").get();
      if (snapshot.exists) {
        String colorHex = snapshot.value as String;
        setState(() {
          _currentColor = _hexToColor(colorHex);
          _controller.color = _currentColor;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching initial color: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateColorInDb(Color color) {
    String colorHex = _colorToHex(color);
    dbRef.child("color").set(colorHex);
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    int value = int.parse(hex, radix: 16);
    return Color(0xFF000000 | value);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 242, 245, 236),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: CircleColorPicker(
                    strokeWidth: 4.0,
                    controller: _controller,
                    onChanged: (color) {
                      setState(() {
                        _currentColor = color;
                      });
                      _updateColorInDb(color);
                    },
                    size: const Size(250, 250),
                  ),
                ),
              ),
            ],
          );
  }
}
