// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:mdownloader/backend/dart_app_data/src/locator.dart';
import 'package:mdownloader/backend/filesystem/get_versions.dart';
import 'package:mdownloader/backend/filesystem/handle_download.dart';
import 'package:mdownloader/backend/filesystem/handle_nonempty_mods.dart';
import 'package:mdownloader/backend/filesystem/is_minecraft_installed.dart';
import 'package:mdownloader/constants/consts.dart';
import 'package:mdownloader/ui/filesystem/file_card.dart';
import 'package:flutter_animated_splash/flutter_animated_splash.dart';

import 'ui/appBar/app_bar.dart';
import 'ui/colors/convert_to_materialcolor.dart';

import 'backend/connectivity/check_if_online.dart';

import 'package:window_size/window_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<FileCard> files = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<Color> colors = [
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

  MAIN_COLOR = colors.elementAt(Random().nextInt(colors.length));

  SERVER_ONLINE = await checkIfServerOnline();
  LOCAL_VERSION = await getLocalVersion();
  CLOUD_VERSION = await getCloudVersion();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  MINECRAFT_LOCATION = prefs.getString("mcLocation") == null
      ? Locator.getPlatformSpecificCachePath() +
          "$PLATFORM_SEPERATOR.minecraft${PLATFORM_SEPERATOR}mods"
      : prefs.getString("mcLocation")!;
  MINECRAFT_INSTALLED = await isMinecraftInstalled(Directory(MINECRAFT_LOCATION));
  
  if (MINECRAFT_INSTALLED) {
    Directory dir = Directory(MINECRAFT_LOCATION);
    List<FileSystemEntity> contents = await dir.list().toList();
    files = FileCardContent("", MAIN_COLOR).fromFileList(contents, MAIN_COLOR);
  } else {
    files.add(FileCard(
      name:
          "Non-existant directory...\nIs Minecraft installed at the given location?",
      color: MAIN_COLOR,
      icon: const Icon(Icons.error_outline_rounded),
      width: 335,
      height: 75,
    ));
  }
  setWindowTitle('');
  setWindowMinSize(const Size(850, 700));
  setWindowMaxSize(const Size(850, 700));

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MDownloader',
      theme: ThemeData(
        primarySwatch: convertToMaterialColor(MAIN_COLOR),
      ),
      home: AnimatedSpash(
        child: const Image(image: AssetImage("lib/assets/logo.png"), filterQuality: FilterQuality.medium, isAntiAlias: true, width: 200, height: 200,),
        navigator: const HomePage(),
        durationInSeconds: 4,
        curve: Curves.decelerate,
        type: Transition.fade,
        backgroundColor: MAIN_COLOR,
      ),
    );
  }
}

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _updateModpack() async {
    if (!MINECRAFT_INSTALLED) return;
    if (LOCAL_VERSION == CLOUD_VERSION) {
      bool reinstalled = await deleteThenReinstall(CLOUD_VERSION);
      dev.log("Reinstall status: ${reinstalled.toString()}");
    } else {
      bool seperated = await separateNonrelevantFilesIntoDir();
      dev.log("Seperation status: ${seperated.toString()}");
      bool downloaded = await downloadAll();
      dev.log("Download status: ${downloaded.toString()}");
    }
    LOCAL_VERSION = await getLocalVersion();
    setState(() {
      dev.log("Reloading state");
    });
  }
  
  @override
  void setState(VoidCallback fn) async {
    MINECRAFT_INSTALLED = await isMinecraftInstalled(Directory(MINECRAFT_LOCATION));
    setState(() {
    });
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(height: 150),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(children: [
              Positioned(
                child: Text(
                  MINECRAFT_INSTALLED ? "Mods folder content" : "",
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500),
                ),
                bottom: 10,
                left: 115,
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 40, left: 45, right: 85),
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.5,
                                color: MINECRAFT_INSTALLED
                                    ? Colors.grey[350]!
                                    : Colors.transparent),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            //color: MINECRAFT_INSTALLED ? Colors.grey[200] : Colors.transparent),
                          ),
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
                          ))))
            ]),
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
                                    MaterialStateProperty.all(MAIN_COLOR)),
                          )
                        ],
                      ),
                    ))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateModpack,
        tooltip: MINECRAFT_INSTALLED
            ? LOCAL_VERSION == CLOUD_VERSION
                ? 'Re-download'
                : LOCAL_VERSION == 'none'
                    ? 'Download'
                    : 'Update'
            : "Not available",
        child: Icon(MINECRAFT_INSTALLED
            ? LOCAL_VERSION == CLOUD_VERSION
                ? Icons.download_done_rounded
                : LOCAL_VERSION == 'none'
                    ? Icons.download_rounded
                    : Icons.update
            : Icons.not_interested_rounded),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        enableFeedback: MINECRAFT_INSTALLED ? true : false,
        backgroundColor: MINECRAFT_INSTALLED ? MAIN_COLOR : Colors.grey[400],
      ),
    );
  }
}
