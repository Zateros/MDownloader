// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mdownloader/constants/consts.dart';

class SettingsAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final double height;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  SettingsAppBarWidget({Key? key, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SizedBox(
        height: 160.0,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 75.0,
              child: Center(
                child: Text(
                  "MDownloader",
                  style: TextStyle(
                      color: MAIN_COLOR == Colors.yellow || MAIN_COLOR == Colors.amber
                        ? Colors.black
                        : Colors.white,
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                  color: MAIN_COLOR,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(59),
                        offset: Offset(6.0, 7.0),
                        blurRadius: 10,
                        spreadRadius: 6,
                        blurStyle: BlurStyle.normal)
                  ]),
            ),
            Positioned(
              top: 65.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 55.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(49),
                            offset: Offset(6.0, 16.0),
                            blurRadius: 10,
                            spreadRadius: 6,
                            blurStyle: BlurStyle.normal)
                      ]),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Material(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(0),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    radius: 25,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    splashColor: Colors.grey[100],
                                    highlightColor: Colors.grey[100],
                                    child: SizedBox(
                                      width: 34,
                                      height: 34,
                                      child: Icon(
                                        Icons.arrow_back_rounded,
                                        color: MAIN_COLOR,
                                        size: 24,
                                      ),
                                    ),
                                  ))
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
