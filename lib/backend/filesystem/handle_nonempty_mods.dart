import 'dart:io';
import 'package:mdownloader/constants/consts.dart';
import 'package:path/path.dart';
import 'dart:developer';

Future<bool> checkIfModsNonempty() async {
  Directory dir = Directory(MINECRAFT_LOCATION);
  List<FileSystemEntity> contents = await dir.list().toList();
  if (contents.isEmpty) {
    return false;
  } else {
    return true;
  }
}

Future<bool> separateNonrelevantFilesIntoDir() async {
  if (!await checkIfModsNonempty()) return false;
  try {
    Directory dir = Directory(MINECRAFT_LOCATION);
    Directory(MINECRAFT_LOCATION + "${PLATFORM_SEPERATOR}oldmods").create();
    List<FileSystemEntity> contents = await dir.list().toList();
    for (var element in contents) {
      if (basename(element.path) == '.local_version.mpack' ||
          basename(element.path) == 'oldmods') continue;
      await element.rename(MINECRAFT_LOCATION +
          "${PLATFORM_SEPERATOR}oldmods$PLATFORM_SEPERATOR${basename(element.path)}");
    }
    return true;
  } catch (e) {
    log(e.toString());
    return false;
  }
}
