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
import 'package:mdownloader/ui/colors/gradient_button.dart';
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
  List<List<Color>> colors = [
    [Colors.red[200]!, Colors.red, Colors.red[900]!],
    [Colors.blue[200]!, Colors.blue, Colors.blue[900]!],
    [Colors.green[200]!, Colors.green, Colors.green[900]!],
    [Colors.yellow[200]!, Colors.yellow, Colors.yellow[900]!],
    [Colors.teal[200]!, Colors.teal, Colors.teal[900]!],
    [Colors.purple[200]!, Colors.purple, Colors.purple[900]!],
    [Colors.pink[200]!, Colors.pink, Colors.pink[900]!],
    [Colors.orange[200]!, Colors.orange, Colors.orange[900]!],
    [Colors.lime[200]!, Colors.lime, Colors.lime[900]!],
    [Colors.cyan[200]!, Colors.cyan, Colors.cyan[900]!],
    [Colors.lightGreen[200]!, Colors.lightGreen, Colors.lightGreen[900]!],
    [Colors.lightBlue[200]!, Colors.lightBlue, Colors.lightBlue[900]!],
    [Colors.amber[200]!, Colors.amber, Colors.amber[900]!],
    [Colors.brown[200]!, Colors.brown, Colors.brown[900]!],
    [Colors.deepOrange[200]!, Colors.deepOrange, Colors.deepOrange[900]!],
    [Colors.indigo[200]!, Colors.indigo, Colors.indigo[900]!],
    [Colors.deepPurple[200]!, Colors.deepPurple, Colors.deepPurple[900]!]
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
  MINECRAFT_INSTALLED =
      await isMinecraftInstalled(Directory(MINECRAFT_LOCATION));

  if (MINECRAFT_INSTALLED) {
    Directory dir = Directory(MINECRAFT_LOCATION);
    List<FileSystemEntity> contents = await dir.list().toList();
    files = FileCardContent("", MAIN_COLOR.elementAt(1))
        .fromFileList(contents, MAIN_COLOR.elementAt(1));
  } else {
    files.add(FileCard(
      name:
          "Non-existant directory...\nIs Minecraft installed at the given location?",
      color: MAIN_COLOR.elementAt(1),
      icon: const Icon(Icons.error_outline_rounded),
      width: 335,
      height: 75,
    ));
  }
  setWindowTitle("");
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
        primarySwatch: convertToMaterialColor(MAIN_COLOR.elementAt(1)),
      ),
      home: AnimatedSpash(
        child: const Image(
          image: AssetImage("assets/logo.png"),
          filterQuality: FilterQuality.medium,
          isAntiAlias: true,
          width: 200,
          height: 200,
        ),
        navigator: const HomePage(),
        durationInSeconds: 4,
        curve: Curves.decelerate,
        type: Transition.fade,
        backgroundColor: MAIN_COLOR.elementAt(1),
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
    if (!MINECRAFT_INSTALLED || !SERVER_ONLINE) return;
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
  void setState(VoidCallback fn) async {
    MINECRAFT_INSTALLED =
        await isMinecraftInstalled(Directory(MINECRAFT_LOCATION));
    setState(() {});
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
              Padding(
                  padding:
                      const EdgeInsets.only(bottom: 40, left: 45, right: 85),
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
                      )))
            ]),
            Padding(
              padding: const EdgeInsets.only(),
              child: Column(
                children: [
                  GradientButton(
                      width: 150,
                      height: 50,
                      onPressed: () => dev.log("Pressed"),
                      colors: MAIN_COLOR,
                      child: const Text(
                        "asdasdad",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateModpack,
        tooltip: MINECRAFT_INSTALLED && SERVER_ONLINE
            ? LOCAL_VERSION == CLOUD_VERSION
                ? 'Re-download'
                : LOCAL_VERSION == 'none'
                    ? 'Download'
                    : 'Update'
            : "Not available",
        child: Container(
          width: 60,
          height: 60,
          child: Icon(MINECRAFT_INSTALLED && SERVER_ONLINE
              ? LOCAL_VERSION == CLOUD_VERSION
                  ? Icons.download_done_rounded
                  : LOCAL_VERSION == 'none'
                      ? Icons.download_rounded
                      : Icons.update
              : Icons.not_interested_rounded),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                  colors: MINECRAFT_INSTALLED && SERVER_ONLINE
                      ? MAIN_COLOR
                      : [Colors.grey, Colors.grey[600]!, Colors.grey[850]!])),
        ),
        enableFeedback: MINECRAFT_INSTALLED || SERVER_ONLINE,
      ),
    );
  }
}
