import 'dart:convert';

import 'package:flashchat/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ButtonScreen extends StatefulWidget {
  final tokenId;

  const ButtonScreen({Key? key, this.tokenId}) : super(key: key);

  @override
  ButtonScreenState createState() => ButtonScreenState();
}

class ButtonScreenState extends State<ButtonScreen> {
  List<dynamic> totalLeads = List.empty();
  List<dynamic> newLeads = List.empty();
  List<dynamic> unAttendedLeads = List.empty();
  List<dynamic> visitRequests = List.empty();
  List<dynamic> pendingLeads = List.empty();
  List<dynamic> sales = List.empty();
  List<dynamic> data = List.empty();
  bool loadingData = true;
  Map<String, Map<String, bool>> settings = Map.identity();
  Map<String, int?> statuses = Map.identity();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        title: const Text('Welcome'),
        actions: [
          TextButton(
            onPressed: retrieveSettingsData,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: kDarkColor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: loadingData, //loadingData,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: [
                  CustomButton(
                    name: 'Total Leads',
                    value: "(${totalLeads.length})",
                    onTap: () {
                      Navigator.pushNamed(context, 'leads screen', arguments: {
                        'Screen Name': 'Total Leads',
                        'Screen Data': totalLeads,
                        'Token Id' : widget.tokenId,
                      });
                    },
                  ),
                  CustomButton(
                    name: 'New Leads',
                    value: "(${newLeads.length})",
                    onTap: () {
                      Navigator.pushNamed(context, 'leads screen', arguments: {
                        'Screen Name': 'New Leads',
                        'Screen Data': newLeads,
                        'Token Id' : widget.tokenId,
                      });
                    },
                  ),
                  CustomButton(
                    name: 'Un-Attended Leads',
                    value: "(${unAttendedLeads.length})",
                    onTap: () {
                      Navigator.pushNamed(context, 'leads screen', arguments: {
                        'Screen Name': 'Un-Attended Leads',
                        'Screen Data': unAttendedLeads,
                        'Token Id' : widget.tokenId,
                      });
                    },
                  ),
                  CustomButton(
                    name: 'Visit Requests',
                    value: "(${visitRequests.length})",
                    onTap: () {
                      Navigator.pushNamed(context, 'leads screen', arguments: {
                        'Screen Name': 'Visit Requests',
                        'Screen Data': visitRequests,
                        'Token Id' : widget.tokenId,
                      });
                    },
                  ),
                  CustomButton(
                    name: 'Pending Leads',
                    value: "(${pendingLeads.length})",
                    onTap: () {
                      Navigator.pushNamed(context, 'leads screen', arguments: {
                        'Screen Name': 'Pending Leads',
                        'Screen Data': pendingLeads,
                        'Token Id' : widget.tokenId,
                      });
                    },
                  ),
                  CustomButton(
                    name: 'Sales',
                    value: "(${sales.length})",
                    onTap: () {
                      Navigator.pushNamed(context, 'leads screen', arguments: {
                        'Screen Name': 'Sales',
                        'Screen Data': sales,
                        'Token Id' : widget.tokenId,
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getData() async {
    final tokenId = widget.tokenId;
    Response response = await post(
      Uri.parse('http://fcrm.ddns.net:5567/api/v1/reports/myleads'),
      headers: {
        "authorization": "Bearer $tokenId",
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: json.encode({
        "from": "2022-06-01T00:00:00",
        "till":
            DateTime.now().toString().replaceRange(10, 11, 'T').split('.')[0],
        "nonTransfered": false,
        "assigned": false,
        "filterType": 1,
        "dateFilterTypeID": 1,
        "userID": null,
        "statusIDs": [],
        "sourceIDs": [],
        "staffIDs": [],
        "projectIDs": [],
        "teamIDs": [],
        "useStatusIDs": false,
        "useSourceIDs": false,
        "useStaffIDs": false,
        "useProjectIDs": false,
        "useTeamIDs": false,
        "leadID": 0
      }),
    );

    Response statusResponse = await get(
      Uri.parse('http://fcrm.ddns.net:5567/api/v1/status'),
      headers: {
        'authorization': 'Bearer ${widget.tokenId}',
      },
    );
    List<dynamic> status = json.decode(statusResponse.body)['data'];
    data = json.decode(response.body)['data'];
    setState(() {
      for (var element in status) {
        statuses[element['description'] ?? 'No Communication'] =
            element['description'] == null ? null : element['statusID'];
      }
      settings = {
        'Total Leads': (() {
          Map<String, bool> tempStatus = Map.identity();
          statuses.forEach((key, value) {
            tempStatus[key] = true;
          });
          return tempStatus;
        })(),
        'Un-Attended Leads': (() {
          Map<String, bool> tempStatus = Map.identity();
          statuses.forEach((key, value) {
            if (value == null) {
              tempStatus[key] = true;
              return;
            }
          });
          return tempStatus;
        })(),
        'Visit Requests': (() {
          Map<String, bool> tempStatus = Map.identity();
          statuses.forEach((key, value) {
            if (value == 3) {
              tempStatus[key] = true;
              return;
            }
          });
          return tempStatus;
        })(),
        'Pending Leads': (() {
          Map<String, bool> tempStatus = Map.identity();
          statuses.forEach((key, value) {
            tempStatus[key] = ((value == 4 || value == null) ? true : false);
          });
          return tempStatus;
        })(),
        'Sold': (() {
          Map<String, bool> tempStatus = Map.identity();
          statuses.forEach((key, value) {
            if (value == 4) {
              tempStatus[key] = true;
              return;
            }
          });
          return tempStatus;
        })(),
      };
      setFilteredData();
    });
  }

  void setFilteredData(){
    Map<String, List<int?>> arraySettings = Map.identity();
    settings.forEach((name, map) {
      arraySettings[name] = List.empty(growable: true);
      map.forEach((key, value) {
        if (value == true) {
          arraySettings[name]?.add(statuses[key]);
        }
      });
    });
    loadingData = false;
    totalLeads = data
        .where((element) =>
    (arraySettings['Total Leads']!.contains(element['statusID'])))
        .toList();
    newLeads = data
        .where((element) => (element['leadDate']
        .contains(DateTime.now().toString().split(' ')[0])))
        .toList();
    unAttendedLeads = data
        .where((element) => (arraySettings['Un-Attended Leads']!
        .contains(element['statusID'])) && element['statusID'] == null)
        .toList();
    visitRequests = data
        .where((element) =>
    (arraySettings['Visit Requests']!.contains(element['statusID']))&& element['statusID'] == 3)
        .toList();
    pendingLeads = data
        .where((element) =>
    (arraySettings['Pending Leads']!.contains(element['statusID'])))
        .toList();
    sales = data
        .where((element) =>
    (arraySettings['Sold']!.contains(element['statusID']))&& element['statusID'] == 4)
        .toList();
  }

  void retrieveSettingsData() async {
    Map<String, Map<String, bool>> tempSettings = await Navigator.pushNamed(
            context, 'settings screen', arguments: settings)
        as Map<String, Map<String, bool>>;
    if (tempSettings != null) {
      settings = tempSettings;
      setState(() {
        setFilteredData();
      });
    }
  }
}

class CustomButton extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final String value;

  const CustomButton(
      {Key? key, required this.name, required this.value, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Container(
            width: size.width,
            height: size.height * 0.12,
            margin: const EdgeInsets.all(10),
            child: Material(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              elevation: 10,
              color: kLighterColor,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "$name\n$value",
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
