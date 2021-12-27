import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mdownloader/constants/consts.dart';

String platformSeperator = Platform.isWindows ? "\\" : "/";

Future<bool> downloadFile(String name, String version, String path) async {
  try {
    var response = await http.get(Uri.parse("$API_URL/packages/$version/$name"),
        headers: {"x-access-token": API_KEY});
    File(path + platformSeperator + name).writeAsBytes(response.bodyBytes);
    return true;
  } catch (e) {
    log(e.toString());
    return false;
  }
}
