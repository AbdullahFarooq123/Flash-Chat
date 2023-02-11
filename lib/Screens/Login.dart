import 'dart:convert';

import 'package:flashchat/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_indicators/progress_indicators.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;

  void processLogin(Response response) {
    setState((){
      loading = false;
    });
    if (response.statusCode == 200) {
      Navigator.pushNamed(
        context,
        'buttoned screen',
        arguments: json.decode(response.body)['token'],
      );
      showDialogueBox('Login Success', DialogType.SUCCES);
      FocusScope.of(context).requestFocus(FocusNode());
    } else if (jsonDecode(response.body)['title']
        .toString()
        .contains('Unauthorized')) {
      showDialogueBox('User not found', DialogType.ERROR);
    } else if (jsonDecode(response.body)['title']
        .toString()
        .contains('One or more validation errors occurred.')) {
      showDialogueBox('Incorrect Username or password', DialogType.ERROR);
    }
  }

  void showDialogueBox(
      String title, DialogType dialogType) {
    AwesomeDialog(
      body: SizedBox(
        height: 100,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 15),
          ),
        ),
      ),
      dialogBackgroundColor: const Color.fromRGBO(84, 77, 129, 1),
      context: context,
      dialogType: dialogType,
      animType: AnimType.BOTTOMSLIDE,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
      btnOkColor: kLighterColor,
      btnCancelColor: kLighterColor,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(84, 77, 129, 100),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        progressIndicator: FadingText(
          'Authenticating....',
          style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: mediaSize.width * 0.05,
            fontWeight: FontWeight.bold
          ),
        ),
        opacity: 1,
        color: kLighterColor,
        child: SafeArea(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getAppLogo(mediaSize),
                  SizedBox(height: mediaSize.height*0.12),
                  Column(
                    children: [
                      CustomTextField(
                        icon: Icons.email,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        autoFocus: true,
                        controller: userName,
                        autofillHints: const [AutofillHints.email],
                      ),
                      CustomTextField(
                        icon: Icons.key,
                        hintText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        autoFocus: false,
                        controller: password,
                        autofillHints: const [AutofillHints.password],
                      ),
                      SizedBox(
                        height: mediaSize.height * 0.06,
                      ),
                      getCustomButton(mediaSize, () async {
                        setState((){
                          loading = true;
                        });
                        try {
                          final response = await post(
                              Uri.parse(
                                  'http://fcrm.ddns.net:5567/api/auth/login'),
                              body: json.encode({
                                "UserName": userName.text,
                                "Password": password.text
                              }),
                              headers: {
                                "Accept": "application/json",
                                "content-type": "application/json"
                              });
                          processLogin(response);
                        } catch (socketException) {
                          setState((){
                            loading = false;
                          });
                          showDialogueBox(
                              'Server Connection Failed!',
                              DialogType.ERROR);
                        }
                      }, 'Login'),
                    ],
                  ),
                  SizedBox(height: mediaSize.height*0.20),
                  getSoftwareHouseLogo(mediaSize),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool autoFocus;
  final TextEditingController controller;
  final Iterable<String> autofillHints;

  const CustomTextField({
    Key? key,
    required this.icon,
    required this.hintText,
    required this.keyboardType,
    required this.obscureText,
    required this.autoFocus,
    required this.controller,
    required this.autofillHints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kLighterColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        border: Border.all(
          color: kLighterColor,
          width: 0.0,
        ),
      ),
      child: TextField(
        cursorColor: kDarkColor,
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: controller,
        autofillHints: autofillHints,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: hintText,
          hintText: hintText,
          labelStyle: const TextStyle(
              color: kLighterColor,
              fontWeight: FontWeight.w800),
          prefixIcon: Icon(
            icon,
            color: kDarkColor,
          ),
          hintStyle: const TextStyle(
            color: Colors.transparent,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            borderSide:
                BorderSide(color: kDarkColor, width: 5.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            borderSide:
                BorderSide(color: kDarkColor, width: 5.0),
          ),
        ),
      ),
    );
  }
}
