import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mdownloader/constants/consts.dart';

Future<bool> checkIfClientOnline() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  return connectivityResult != ConnectivityResult.none ? true : false;
}

Future<bool> checkIfServerOnline() async {
  var resp = await http
      .get(Uri.parse("$API_URL/status"), headers: {"x-access-token": API_KEY});
  log("Server status: ${resp.body}");
  return resp.body == "online" ? true : false;
}
