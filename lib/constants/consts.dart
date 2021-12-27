// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:mdownloader/backend/dart_app_data/src/locator.dart';

String PLATFORM_SEPERATOR = Platform.isWindows ? "\\" : "/";

String MINECRAFT_LOCATION = Locator.getPlatformSpecificCachePath() +
    "$PLATFORM_SEPERATOR.minecraft${PLATFORM_SEPERATOR}mods";

String VERSION_FILE = "$PLATFORM_SEPERATOR.${"local_version"
  ..toLowerCase()
  ..replaceAll(" ", "_")}.mpack";

String API_URL = "http://34.159.77.254:25566";

String API_KEY = "qzuxmrLGwDs3KPKX5V5KyA==";
