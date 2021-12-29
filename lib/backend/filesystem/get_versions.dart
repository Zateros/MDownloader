// ignore_for_file: implementation_imports, import_of_legacy_library_into_null_safe, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:mdownloader/constants/consts.dart';

import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> getLocalVersion() async {
  if (!await File(MINECRAFT_LOCATION + VERSION_FILE).exists()) {
    if (Directory(MINECRAFT_LOCATION).existsSync()) {
      await File(MINECRAFT_LOCATION + VERSION_FILE).create();
    } else {
      return "MC not installed";
    }
    return "none";
  } else {
    File mpack = File(MINECRAFT_LOCATION + VERSION_FILE);
    if (await mpack.readAsString() == "") return "none";
    var content = jsonDecode(await mpack.readAsString());
    return content['version'];
  }
}

Future<String> getCloudVersion() async {
  var response = await http.get(Uri.parse("$API_URL/version/latest"),
      headers: {"x-access-token": API_KEY});
  return response.body;
}
