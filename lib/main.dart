import 'package:flashchat/Screens/LeadsFilter.dart';
import 'package:flashchat/Screens/Welcome.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/Screens/Login.dart';
import 'package:flashchat/Screens/Communications.dart';
import 'package:flashchat/Screens/Buttons.dart';
import 'package:flashchat/Screens/Settings.dart';
import 'package:flashchat/Screens/Leads.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('ur', ''),
      ],
      debugShowCheckedModeBanner: false,
      initialRoute: 'welcome screen',
      routes: {
        'welcome screen': (context) => const WelcomeScreen(),
        'login screen': (context) => const LoginScreen(),
        'buttoned screen': (context) => ButtonScreen(
              tokenId: ExtractArguments('buttoned screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments(),
            ),
        'communication screen': (context) => CommunicationScreen(
              leadId: ExtractArguments('communication screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments()['Lead Id'],
              tokenId: ExtractArguments('communication screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments()['Token Id'],
              leadName: ExtractArguments('communication screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments()['Lead Name'],
              leadContact: ExtractArguments('communication screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments()['Lead Contact'],
              leadProject: ExtractArguments('communication screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments()['Lead Project'],
            ),
        'settings screen': (context) => SettingsScreen(
              leadsFilter: ExtractArguments('settings screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments(),
            ),
        'leads screen': (context) => LeadsScreen(
              screenData: ExtractArguments('leads screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments()['Screen Data'],
              leadsName: ExtractArguments('leads screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments()['Screen Name'],
              tokenId: ExtractArguments('leads screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments()['Token Id'],
            ),
        'leads filter screen': (context) => LeadsFilterScreen(
              dataFilter: ExtractArguments('leads filter screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments(),
            ),
      },
    );
  }
}

class ExtractArguments {
  final String screenName;
  final Object? arguments;

  ExtractArguments(this.screenName, this.arguments);

  dynamic getArguments() {
    switch (screenName) {
      case 'buttoned screen':
        return arguments;
      case 'settings screen':
        return arguments as Map<String, Map<String, bool>>;
      case 'leads screen':
        return arguments as Map<String, Object>;
      case 'leads filter screen':
        return arguments as Map<String, String>;
      case 'communication screen':
        return arguments as Map<String, String>;
    }
  }
}
