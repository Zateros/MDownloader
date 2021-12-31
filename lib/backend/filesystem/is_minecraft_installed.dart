import 'dart:io';

Future<bool> isMinecraftInstalled(Directory location) async {
  if(await location.exists()) {
    return true;
  }else {
    return false;
  }
}