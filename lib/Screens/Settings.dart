import 'package:flutter/material.dart';
import '../constants.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, Map<String, bool>> leadsFilter;

  const SettingsScreen({Key? key, required this.leadsFilter}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, bool> visibilities = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kDarkColor,
        appBar: AppBar(
          title: const Text('Filter Settings'),
          backgroundColor: kDarkColor,
        ),
        body: ListView(
          children: getAllSettings(),
        ));
  }

  List<Widget> getAllSettings() {
    List<Widget> settings = List.empty(growable: true);
    widget.leadsFilter.forEach(
      (name, map) {
        if (visibilities[name] == null) {
          visibilities[name] = false;
        }
        settings.add(Column(
          children: [
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.only(
                    top: 5, bottom: 1, right: 10, left: 10),
                height: 50,
                decoration: BoxDecoration(
                  color: (visibilities[name] as bool
                      ? kLightColor
                      : kLighterColor),
                  borderRadius: BorderRadius.only(
                      topRight: const Radius.circular(18),
                      topLeft: const Radius.circular(18),
                      bottomLeft:
                          Radius.circular((visibilities[name]! ? 0 : 18)),
                      bottomRight:
                          Radius.circular((visibilities[name]! ? 0 : 18))),
                ),
                child: Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  visibilities[name] = !(visibilities[name] as bool);
                });
              },
            ),
            Visibility(
              visible: visibilities[name] as bool,
              child: IntrinsicHeight(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18)),
                    color: kLighterColor,
                  ),
                  child: Column(
                    children: getSetting(map),
                  ),
                ),
              ),
            ),
          ],
        ));
      },
    );
    settings.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kLightColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          onPressed: () {
            Navigator.pop(context, widget.leadsFilter);
          },
          child: const Text('Done'),
        ),
      ),
    ));
    return settings;
  }

  List<Widget> getSetting(Map<String, bool> values) {
    List<Widget> rows = List.empty(growable: true);
    values.forEach(
      (key, value) {
        rows.add(
          Row(
            children: [
              Checkbox(
                side: const BorderSide(color: Colors.white),
                value: value,
                onChanged: (value) {
                  setState(() {
                    values[key] = value!;
                  });
                },
              ),
              Text(
                key,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
    return rows;
  }
}
