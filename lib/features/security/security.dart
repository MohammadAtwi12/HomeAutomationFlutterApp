import 'package:firebase_database/firebase_database.dart';
import 'package:flicky/features/lighting/lighting.dart';
import 'package:flutter/material.dart';
import 'package:flicky/helpers/utils.dart';
import 'package:flicky/styles/colors.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';
import 'package:flicky/features/landing/home.page.dart';
import 'package:image/image.dart' as img;
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SecurityPage extends StatefulWidget {
  static const String route = '/sec';
  const SecurityPage({super.key});

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();

  void _showAddFaceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Face'),
              content: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Enter name for the photo',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      if (_image != null)
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HomeAutomationColors.lightPrimary,
                              minimumSize: Size(110, 50),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              textStyle: TextStyle(fontSize: 16),
                            ),
                            onPressed: () => _pickImage(ImageSource.gallery, setState),
                            icon: Icon(Icons.photo_library, size: 20),
                            label: Text('Upload'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HomeAutomationColors.lightPrimary,
                              minimumSize: Size(110, 50),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              textStyle: TextStyle(fontSize: 16),
                            ),
                            onPressed: () => _pickImage(ImageSource.camera, setState),
                            icon: Icon(Icons.camera_alt, size: 20),
                            label: Text('Take'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: _saveImage,
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source, StateSetter setState) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final resizedImage = await _resizeImage(File(pickedFile.path));
      setState(() {
        _image = resizedImage;
      });
    } else {
      print('No image selected.');
    }
  }

  Future<File> _resizeImage(File imageFile) async {
  final imageBytes = await imageFile.readAsBytes();
  img.Image? originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) {
    throw Exception('Could not decode image.');
  }

  // Reduce the dimensions of the image
  img.Image resizedImage = img.copyResize(originalImage, width: 400); // Adjust width as needed
  // You can also adjust height if needed: img.copyResize(originalImage, width: 400, height: 300);

  // Encode the resized image to bytes with lower quality (e.g., quality level 50)
  final resizedImageBytes = img.encodeJpg(resizedImage, quality: 40); // Adjust quality level as needed

  // Save the resized image to a temporary file
  final tempDir = await getTemporaryDirectory();
  final resizedImageFile = File('${tempDir.path}/${imageFile.uri.pathSegments.last}');
  await resizedImageFile.writeAsBytes(resizedImageBytes);

  return resizedImageFile;
}

  Future<void> _saveImage() async {
    final fileName = '${_nameController.text.trim()}.jpeg';
    if (fileName.isEmpty) {
      print('Name is required.');
      return;
    }
    if (_image == null) {
      print('Image is required.');
      return;
    }

    // Upload image to Firebase Storage
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('KnownFaces/$fileName');
    await ref.putFile(_image!);

    // Update reload key in Firebase Realtime Database
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('reload');
    await databaseRef.set(true);

    // Reset the state
    setState(() {
      _image = null;
      _nameController.clear();
    });

    // Close the dialog
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,  // Prevents overflow issue
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
            const SizedBox(height: 30.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: const SizedBox(
                  height: 250,  // Decreased the height of the WebView box
                  child: CameraView(),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HomeAutomationColors.lightPrimary,
                  minimumSize: Size(200, 50), // Increased width of the Add Face button
                ),
                onPressed: _showAddFaceDialog,
                child: Text('Add Face'),
              ),
            ),
            const SizedBox(height: 30.0),
            CustomSwitchWidget(
              index: 1, icon: FlickyIcons.room, name: "Door"),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomMenuButton(IconData icon, String text, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
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
              // Handle navigation to Settings
              break;
            case 2:
              // Handle navigation to Info
              break;
          }
        },
      ),
    );
  }
}

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebView(
      //initialUrl: 'http://192.168.1.108:5000/video_feed',
      initialUrl: 'http://192.168.1.108:5000/video_feed',
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}