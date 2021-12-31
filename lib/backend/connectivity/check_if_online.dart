import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mdownloader/constants/consts.dart';

Future<bool> checkIfClientOnline() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  return connectivityResult != ConnectivityResult.none ? true : false;
}

Future<bool> checkIfServerOnline() async {
  try {
    var resp = await http.get(Uri.parse("$API_URL/status"), headers: {
      "x-access-token": API_KEY
    }).timeout(const Duration(milliseconds: 500));
    log("Server status: ${resp.body}");
    return resp.body == "online" ? true : false;
  } catch (e) {
    log("Error @ checking server's status: ${e.toString()}");
    return false;
  }
}
