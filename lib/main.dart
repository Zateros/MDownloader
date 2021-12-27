// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:mdownloader/backend/dart_app_data/src/locator.dart';
import 'package:mdownloader/backend/filesystem/get_versions.dart';
import 'package:mdownloader/backend/filesystem/handle_download.dart';
import 'package:mdownloader/backend/filesystem/handle_nonempty_mods.dart';
import 'package:mdownloader/constants/consts.dart';
import 'package:mdownloader/ui/filesystem/file_card.dart';

import 'ui/appBar/app_bar.dart';
import 'ui/colors/convert_to_materialcolor.dart';

import 'backend/connectivity/check_if_online.dart';

import 'package:window_size/window_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<FileCard> files = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.teal,
    Colors.purple,
    Colors.pink,
    Colors.orange,
    Colors.lime,
    Colors.grey,
    Colors.cyan,
    Colors.lightGreen,
    Colors.lightBlue,
    Colors.amber,
    Colors.brown,
    Colors.deepOrange,
    Colors.indigo,
    Colors.deepPurple
  ];

  Color randomColor = colors.elementAt(Random().nextInt(colors.length));

  bool isClientOnline = await checkIfClientOnline();
  bool isServerOnline = await checkIfServerOnline();
  String localVersion = await getLocalVersion();
  String cloudVersion = await getCloudVersion();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  MINECRAFT_LOCATION = prefs.getString("mcLocation") == null
      ? Locator.getPlatformSpecificCachePath() +
          "$PLATFORM_SEPERATOR.minecraft${PLATFORM_SEPERATOR}mods"
      : prefs.getString("mcLocation")!;

  Directory dir = Directory(MINECRAFT_LOCATION);
  List<FileSystemEntity> contents = await dir.list().toList();
  files = FileCardContent("", randomColor).fromFileList(contents, randomColor);

  setWindowTitle('');
  setWindowMinSize(const Size(850, 700));
  setWindowMaxSize(Size.infinite);

  runApp(MainApp(
      mainColor: randomColor,
      isClientOnline: isClientOnline,
      isServerOnline: isServerOnline,
      localVersion: localVersion,
      cloudVersion: cloudVersion));
}

class MainApp extends StatelessWidget {
  final Color mainColor;
  final bool isClientOnline;
  final bool isServerOnline;
  final String localVersion;
  final String cloudVersion;

  const MainApp(
      {Key? key,
      required this.mainColor,
      required this.isClientOnline,
      required this.isServerOnline,
      required this.localVersion,
      required this.cloudVersion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MDown5loader',
      theme: ThemeData(
        primarySwatch: convertToMaterialColor(mainColor),
      ),
      home: HomePage(
        color: mainColor,
        isClientOnline: isClientOnline,
        isServerOnline: isServerOnline,
        localVersion: localVersion,
        cloudVersion: cloudVersion,
      ),
    );
  }
}

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  final Color color;
  final bool isClientOnline;
  final bool isServerOnline;
  late String? localVersion;
  late String? cloudVersion;

  HomePage(
      {Key? key,
      required this.color,
      required this.isClientOnline,
      required this.isServerOnline,
      this.localVersion,
      this.cloudVersion})
      : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _updateModpack() async {
    if (widget.localVersion == widget.cloudVersion) {
      bool reinstalled = await deleteThenReinstall(widget.cloudVersion!);
      dev.log("Reinstall status: ${reinstalled.toString()}");
    } else {
      bool seperated = await separateNonrelevantFilesIntoDir();
      dev.log("Seperation status: ${seperated.toString()}");
      bool downloaded = await downloadAll();
      dev.log("Download status: ${downloaded.toString()}");
    }
    widget.localVersion = await getLocalVersion();
    setState(() {
      dev.log("Reloading state");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        height: 150,
        color: widget.color,
        isOnline: widget.isClientOnline,
        isServerOnline: widget.isServerOnline,
        localVersion: widget.localVersion!,
        cloudVersion: widget.cloudVersion!,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 30, left: 45, right: 85),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.5, color: Colors.grey[350]!),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey[200]),
                        child: LimitedBox(
                          maxHeight: 200.0,
                          child: SingleChildScrollView(
                              child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.start,
                            direction: Axis.vertical,
                            spacing: 10,
                            children: files,
                          )),
                        )))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: LimitedBox(
                      maxHeight: 200.0,
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "asdasdad",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(widget.color)),
                          )
                        ],
                      ),
                    ))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateModpack,
        tooltip: widget.localVersion == widget.cloudVersion
            ? 'Re-download'
            : widget.localVersion == 'none'
                ? 'Download'
                : 'Update',
        child: Icon(widget.localVersion == widget.cloudVersion
            ? Icons.download_done_rounded
            : widget.localVersion == 'none'
                ? Icons.download_rounded
                : Icons.update),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
