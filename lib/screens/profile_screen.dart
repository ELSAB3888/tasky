import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/core/theme/theme_controller.dart';
import 'package:todo/screens/user_details_screen.dart' show UserDetailsScreen;
import 'package:todo/screens/welcome_screen.dart';
import '../core/services/preferences_manager.dart';
import '../core/widgets/custom_svg_picture.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username;
  late String motivationQuote;
  String? userImagePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loedData();
  }

  void _loedData() async {
    setState(() {
      username = PreferencesManager().getString('username') ?? 'Guest';
      motivationQuote =
          PreferencesManager().getString('motivation_quote') ??
          'One task at a time. One step closer.';
      userImagePath = PreferencesManager().getString('user_Image');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'My Profile',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundImage: userImagePath == null
                                ? AssetImage('images/i7.jpeg')
                                : FileImage(File(userImagePath!)),
                            radius: 60,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                          ),
                          GestureDetector(
                            onTap: () async {
                              showImageSourceDialog(context, (XFile file) {
                                _saveImage(file);
                                setState(() {
                                  userImagePath = file.path;
                                });
                              });
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                              ),
                              child: Icon(Icons.camera_alt_outlined, size: 26),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        username,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(height: 4),
                      Text(
                        motivationQuote,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Profile Info',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                SizedBox(height: 8),
                ListTile(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext Context) {
                          return UserDetailsScreen(
                            userName: username,
                            motivationQuote: motivationQuote,
                          );
                        },
                      ),
                    );
                    if (result != null && result) {
                      setState(() {
                        _loedData();
                      });
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: CustomSvgPicture(path: 'images/User Details.svg'),
                  title: Text("User Details"),
                  trailing: CustomSvgPicture(path: 'images/shm.svg'),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CustomSvgPicture(path: 'images/Dark Mode.svg'),
                  title: Text("Dark Mode"),
                  trailing: ValueListenableBuilder(
                    valueListenable: ThemeController.themeNotifier,
                    builder: (BuildContext context, value, Widget? child) {
                      return Switch(
                        value: value == ThemeMode.dark,
                        onChanged: (bool value) async {
                          ThemeController.toggleTheme();
                        },
                      );
                    },
                  ),
                ),
                Divider(),
                ListTile(
                  onTap: () async {
                    PreferencesManager().remove('username');
                    PreferencesManager().remove('motivation_quote');
                    PreferencesManager().remove("tasks");
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return WelcomeScreen();
                        },
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: CustomSvgPicture(path: 'images/Log Out.svg'),
                  title: Text("Log Out"),
                  trailing: CustomSvgPicture(path: 'images/shm.svg'),
                ),
              ],
            ),
          );
  }

  void _saveImage(XFile file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newFile = await File(file.path).copy('${appDir.path}/${file.name}');
    PreferencesManager().setString('user_Image', newFile.path);
  }

  // void _showButtonSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return ConstrainedBox(
  //         constraints: BoxConstraints(
  //           maxHeight: MediaQuery.of(context).size.height * 0.9,
  //           minHeight: MediaQuery.of(context).size.height * 0.1,
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: ListView.builder(
  //             itemCount: 8,
  //             shrinkWrap: true,
  //             itemBuilder: (BuildContext context, int index) {
  //               return Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: 50,
  //                   color: Colors.green,
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

void showImageSourceDialog(BuildContext context, Function(XFile) selectedFile) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(
          "Choose Image Source",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(context);
              XFile? image = await ImagePicker().pickImage(
                source: ImageSource.camera,
              );
              if (image != null) {
                selectedFile(image);
              }
            },
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 8),
                Text("Camera"),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(context);
              XFile? image = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                selectedFile(image);
              }
            },
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.photo_library),
                SizedBox(width: 8),
                Text("Gallery"),
              ],
            ),
          ),
        ],
      );
    },
  );
}
