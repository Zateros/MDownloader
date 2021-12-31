import 'dart:convert';

import 'package:mdownloader/backend/connectivity/download_file.dart';
import 'package:mdownloader/backend/filesystem/get_versions.dart';
import 'package:mdownloader/constants/consts.dart';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

Future<bool> deleteThenReinstall(String version) async {
  log(version);
  var response = await http.get(Uri.parse("$API_URL/content/$version"),
      headers: {"x-access-token": API_KEY});
  if (response.statusCode != HttpStatus.ok) return false;
  Directory dir = Directory(MINECRAFT_LOCATION);
  List<FileSystemEntity> contents = await dir.list().toList();

  try {
    for (var element in contents) {
      if (basename(element.path) == ".local_version.mpack" ||
          basename(element.path) == "oldmods") continue;
      await element.delete();
    }
  } catch (e) {
    log(e.toString());
    return false;
  }

  var mods = jsonDecode(response.body.replaceAll("'", "\""));
  try {
    for (var element in mods) {
      await downloadFile(element, version, MINECRAFT_LOCATION);
    }
  } catch (e) {
    log(e.toString());
    return false;
  }
  return true;
}

Future<bool> downloadAll() async {
  var response = await http.get(Uri.parse("$API_URL/content/latest"),
      headers: {"x-access-token": API_KEY});
  if (response.statusCode != HttpStatus.ok) return false;
  var mods = jsonDecode(response.body.replaceAll("'", "\""));

  try {
    for (int i = 0; i < mods.length; i++) {
      await downloadFile(mods[i], await getCloudVersion(), MINECRAFT_LOCATION);
    }
  } catch (e) {
    log(e.toString());
    return false;
  }
  response = await http.get(Uri.parse("$API_URL/versionFile"),
      headers: {"x-access-token": API_KEY});
  if (response.statusCode != HttpStatus.ok) return false;
  await File(MINECRAFT_LOCATION + VERSION_FILE).writeAsString(response.body);
  return true;
}
