// ignore_for_file: prefer_const_constructors

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mdownloader/constants/consts.dart';
import 'package:mdownloader/ui/appBar/app_bar_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final Color color;
  const SettingsPage({Key? key, required this.color}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: SettingsAppBarWidget(height: 150, color: widget.color),
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
                                controller: TextEditingController(
                                    text: MINECRAFT_LOCATION),
                                decoration: InputDecoration(
                                    icon: Icon(Icons.folder_rounded),
                                    helperText: "Minecraft location",
                                    helperStyle: TextStyle(fontSize: 15)),
                              ))),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(right: 155),
                              child: Container(
                                  height: 45,
                                  margin: EdgeInsets.only(left: 95, right: 95),
                                  child: Material(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        radius: 20,
                                        onTap: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          String? result = await FilePicker
                                              .platform
                                              .getDirectoryPath();

                                          if (result != null) {
                                            MINECRAFT_LOCATION = result;
                                            await prefs.setString(
                                                "mcLocation", result);
                                          }
                                          setState(() {});
                                        },
                                        splashColor: Colors.grey[100],
                                        highlightColor: Colors.grey[100],
                                        child: SizedBox(
                                          width: 34,
                                          height: 34,
                                          child: Icon(
                                            Icons.table_rows,
                                            color: widget.color,
                                            size: 24,
                                          ),
                                        ),
                                      ))))),
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