import 'dart:io';
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
  const FileCard({Key? key, required this.name, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 275,
      height: 55,
      child: TextButton(
        child: Stack(
          children: [
            const Positioned(
              child: Icon(
                Icons.file_copy_rounded,
                color: Colors.black,
              ),
              left: 12,
              top: 12,
            ),
            Positioned(
              child: Text(
                name,
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.fade,
              ),
              left: 45,
              top: 15,
            )
          ],
        ),
        onPressed: () {},
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: color))),
          backgroundColor: MaterialStateProperty.all(color),
          enableFeedback: true,
          overlayColor: MaterialStateProperty.all(Colors.white.withAlpha(34)),
        ),
      ),
    );
  }
}
