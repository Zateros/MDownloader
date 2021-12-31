import 'dart:io';
import 'package:mdownloader/constants/consts.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class FileCardContent {
  final String name;
  final Color color;

  FileCardContent(this.name, this.color);

  List<FileCard> fromFileList(List<FileSystemEntity> list, Color color) {
    List<FileCard> fileCards = [];
    List<String> names = [];
    for (var element in list) {
      if (basename(element.path) == "oldmods" ||
          basename(element.path) == ".local_version.mpack") continue;
      names.add(basename(element.path));
    }
    names.sort();
    for (var element in names) {
      fileCards.add(FileCard(name: element, color: color));
    }
    return fileCards;
  }
}

class FileCard extends StatelessWidget {
  final String name;
  final Color color;
  final Icon icon;
  final double width;
  final double height;

  const FileCard(
      {Key? key,
      required this.name,
      required this.color,
      this.icon = const Icon(Icons.file_copy_rounded),
      this.width = 275,
      this.height = 55})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            enableFeedback: MINECRAFT_INSTALLED ? true : false,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18))),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: MAIN_COLOR),
              borderRadius: const BorderRadius.all(Radius.circular(18))),
          child: Stack(
            children: [
              Positioned(
                child: Icon(
                  icon.icon,
                  color: Colors.black,
                ),
                left: 12,
                top: 16,
              ),
              Positioned(
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.black),
                  overflow: TextOverflow.fade,
                ),
                left: 40,
                top: 22,
              )
            ],
          ),
        ),
        onPressed: () {},
        // style: ButtonStyle(
        //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //       RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(18.0),
        //           side: BorderSide(color: color))),
        //   backgroundColor: MaterialStateProperty.all(color),
        //   enableFeedback: MINECRAFT_INSTALLED ? true : false,
        //   overlayColor: MaterialStateProperty.all(Colors.white.withAlpha(34)),
      ),
    );
  }
}
