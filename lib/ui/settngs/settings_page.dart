// ignore_for_file: prefer_const_constructors

import 'dart:ui' as UI;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mdownloader/constants/consts.dart';
import 'package:mdownloader/ui/appBar/app_bar_settings.dart';
import 'package:mdownloader/ui/colors/gradient_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _controller =
      TextEditingController(text: MINECRAFT_LOCATION);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: SettingsAppBarWidget(height: 150),
            body: Column(
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: TextField(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                onSubmitted: (value) async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString("mcLocation", value);
                                  MINECRAFT_LOCATION = value;
                                  setState(() {
                                    _controller.text = value;
                                  });
                                },
                                controller: _controller,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.folder_rounded),
                                    helperText: "Minecraft location",
                                    helperStyle: TextStyle(fontSize: 15)),
                              ))),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 115, right: 250),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String? result = await FilePicker.platform
                                    .getDirectoryPath();

                                if (result != null) {
                                  MINECRAFT_LOCATION = result;
                                  await prefs.setString("mcLocation", result);
                                }
                                setState(() {});
                              },
                              child: Ink(
                                width: 500,
                                height: 55,
                                decoration: BoxDecoration(
                                    gradient:
                                        LinearGradient(colors: MAIN_COLOR),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(18))),
                                child: Icon(
                                  Icons.table_rows,
                                  size: 27,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                      ),
                    ])
              ],
            )));
  }
}

// Expanded(
//     child: Padding(
//         padding: EdgeInsets.only(right: 16, left: 0),
//         child: Container(
//             height: 45,
//             margin: EdgeInsets.all(10),
//             child: TextButton(
//               onPressed: () {},
//               child: const Text(
//                 "Save",
//                 style: TextStyle(color: Colors.black),
//               ),
//               style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all(
//                           widget.color)),
//             ))))