import 'package:flutter/material.dart';
import '../constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    FocusScope.of(context).unfocus();
    return Scaffold(
      backgroundColor: kDarkColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: getAppLogo(mediaSize),
            ),
            Center(
              child: getCustomButton(mediaSize, () {Navigator.pushNamed(context, 'login screen');}, 'Login'),
            ),
            Center(
              child: getSoftwareHouseLogo(mediaSize),
            ),
          ],
        ),
      ),
    );
  }
}
