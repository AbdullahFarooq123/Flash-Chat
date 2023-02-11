
import 'dart:convert';

import 'package:flashchat/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';



// {leadCommunicationID: 1, leadID: 37, lead: null, communicationTypeID: 1, communicationType: {communicationTypeID: 1, description: Phone}, description: he is will call us back. , at: 2021-05-05T13:21:40, followUpOn: 2021-05-05T00:00:00, statusID: 3, teamID: 0, status: {statusID: 3, description: Visit Request}, by: null, inventoryID: 4, inventory: null}

class CommunicationScreen extends StatefulWidget {
  final String tokenId;
  final String leadId;
  final String leadName;
  final String leadContact;
  final String leadProject;
  const CommunicationScreen({Key? key, required this.leadId, required this.tokenId, required this.leadName, required this.leadContact, required this.leadProject}) : super(key: key);

  @override
  _CommunicationScreenState createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  bool loading = true;
  List<dynamic> data = [];

  void getData() async{
    Response communicationResponse = await get(
      Uri.parse('http://fcrm.ddns.net:5567/api/v1/reports/Leadcommunications?Lid=${widget.leadId}'),
      headers: {
        'authorization': 'Bearer ${widget.tokenId}',
      },
    );
    data = jsonDecode(communicationResponse.body)['data'];
    setState((){
      loading = false;
    });
  }
  @override
  initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        backgroundColor: kDarkColor,
        appBar: AppBar(
          title: const Text('Communications'),
          backgroundColor: kDarkColor,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    LeadsBubble(leadId: widget.leadId, leadName: widget.leadName, leadContact: widget.leadContact, leadProject: widget.leadProject, tokenId: widget.tokenId)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeadsBubble extends StatelessWidget {
  final String leadId;
  final String leadName;
  final String leadContact;
  final String leadProject;
  final String tokenId;

  const LeadsBubble({
    Key? key,
    required this.leadId,
    required this.leadName,
    required this.leadContact,
    required this.leadProject,
    required this.tokenId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = kLighterColor;
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 3, color: statusColor),
      ),
      child: TextButton(
        onPressed: (){},
        child: IntrinsicHeight(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1))),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 12),
                      decoration: const BoxDecoration(
                        color: kDarkColor,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Text(
                        leadId,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        leadName,
                        style:
                        const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 5, left: 10, top: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 12),
                      decoration: const BoxDecoration(
                        color: kDarkColor,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Text(
                        'Contact : $leadContact',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.only(bottom: 5, left: 10),
              //   child: Row(
              //     children: [
              //       Container(
              //         padding: const EdgeInsets.symmetric(
              //           vertical: 5,
              //           horizontal: 12,
              //         ),
              //         decoration: const BoxDecoration(
              //           color: kDarkColor,
              //           borderRadius: BorderRadius.all(Radius.circular(100)),
              //         ),
              //         child: Text(
              //           'Product : $leadProduct',
              //           style: const TextStyle(color: Colors.white),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                padding: const EdgeInsets.only(bottom: 5, left: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 12,
                      ),
                      decoration: const BoxDecoration(
                        color: kDarkColor,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Text(
                        'Project : $leadProject',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.0, color: Colors.black38),
                    ),
                  ),
                  child: const TextField(
                    decoration:
                    InputDecoration(border: InputBorder.none, hintText: 'Notes'),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: (){}, child: const Text('Submit'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



class MessageBubble extends StatelessWidget {
  final String date;
  final String status;

  const MessageBubble({Key? key, required this.date, required this.status}):super(key: key);

  Widget getCircularContainer(Widget value, Color color) {
    return Expanded(
      child: Container(
          margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 1, color: color),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: value,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = status.contains('Visited')
        ? Colors.blue
        : const Color.fromRGBO(253, 196, 63, 100);
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 3, color: statusColor),
      ),
      child: IntrinsicHeight(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getCircularContainer(
                  Text(date, style: const TextStyle(color: Colors.white)),
                  Colors.deepPurple,
                ),
                getCircularContainer(
                  const Text('Phone', style: TextStyle(color: Colors.white)),
                  Colors.blue,
                ),
                getCircularContainer(
                  Text(status, style: const TextStyle(color: Colors.white)),
                  statusColor,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getCircularContainer(
                  const Text("FollowUp On", style: TextStyle(color: Colors.white)),
                  Colors.deepPurple,
                ),
                getCircularContainer(
                  const Text('Sat, 09 Apr 22', style: TextStyle(color: Colors.black)),
                  Colors.transparent,
                ),
                getCircularContainer(
                  const Icon(
                    CupertinoIcons.pen,
                    color: Colors.black,
                  ),
                  const Color.fromRGBO(253, 196, 63, 100),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.black38),
                  ),
                ),
                child: const TextField(
                  decoration:
                      InputDecoration(border: InputBorder.none, hintText: 'Notes'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
