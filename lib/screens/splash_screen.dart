import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          children: [
            Spacer(),
            CupertinoActivityIndicator(
              radius: 12,
            ),
            SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }
}
