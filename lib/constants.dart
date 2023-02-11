import 'package:flutter/material.dart';

const kDarkColor = Color.fromRGBO(84, 77, 129, 100);
const kLightColor = Color.fromRGBO(84, 77, 129, 1);
const kLighterColor = Color.fromRGBO(138, 147, 180, 100);

Widget getAppLogo(final mediaSize) {
  return Container(
    width: mediaSize.width * 0.45,
    height: mediaSize.height * 0.21,
    margin: const EdgeInsets.only(top: 50),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(100),
      ),
      border: Border.all(
        color: kDarkColor,
        width: 5.0,
      ),
    ),
    child: const IntrinsicHeight(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
        elevation: 20,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Image(
            image: AssetImage(
              'images/estate logo.png',
            ),
          ),
        ),
      ),
    ),
  );
}

Widget getSoftwareHouseLogo(final mediaSize) {
  return SizedBox(
    height: mediaSize.height * 0.04,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: mediaSize.width * 0.25,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            border: Border.all(
              color: Colors.white,
              width: 5.0,
            ),
          ),
          child: const IntrinsicHeight(
            child: Image(
              image: AssetImage(
                'images/futuresoft logo.png',
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget getCustomButton(final mediaSize, VoidCallback onPressed, String text) {
  return SizedBox(
    width: mediaSize.width * 0.95,
    height: mediaSize.height * 0.07,
    child: ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(10),
        backgroundColor: MaterialStateProperty.all(
          kLightColor,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
            side: const BorderSide(
              color: kLightColor,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
      ),
    ),
  );
}
