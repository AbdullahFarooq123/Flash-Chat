import 'dart:developer';

import 'package:flashchat/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LeadsScreen extends StatefulWidget {
  final List<dynamic> screenData;
  final String leadsName;
  final String tokenId;

  const LeadsScreen({
    Key? key,
    required this.screenData,
    required this.leadsName,
    required this.tokenId,
  }) : super(key: key);

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  String search = '';
  FocusNode searchFocusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  Map<String, String> dataFilter = {
    'Date Type': '',
    'From': '',
    'To': '',
  };
  bool loading = false;
  int leadsLength = 0;

  @override
  initState() {
    super.initState();
    // filteredData = widget.screenData;
    leadsLength = widget.screenData.length;
    log(widget.tokenId);
  }

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: loading,
      progressIndicator: FadingText(
        'Loading...',
        style: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
            fontSize: mediaSize.width * 0.05),
      ),
      opacity: 1,
      color: kDarkColor,
      child: Scaffold(
        backgroundColor: kDarkColor,
        appBar: AppBar(
          title: Text(widget.leadsName),
          backgroundColor: kDarkColor,
          actions: [
            IntrinsicWidth(
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: kLighterColor,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: kLighterColor)),
                    child: Text('$leadsLength Leads'),
                  )
                ],
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: mediaSize.height * 0.060,
                      height: mediaSize.height * 0.060,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 5),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: kLighterColor,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.filter_alt_sharp,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (searchFocusNode.hasFocus) {
                            setState(() {
                              searchFocusNode.unfocus();
                            });
                          }
                          Map<String, String> data = await Navigator.pushNamed(
                              context, 'leads filter screen',
                              arguments: dataFilter) as Map<String, String>;
                          if (data != null) {
                            setState(() {
                              dataFilter = data;
                              getChildren();
                            });
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          color: kLighterColor,
                          border: Border.all(color: kLighterColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                        ),
                        child: TextField(
                          focusNode: searchFocusNode,
                          controller: searchController,
                          cursorColor: kLighterColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: const TextStyle(color: kLighterColor),
                            border: InputBorder.none,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  searchController.clear();
                                  search = '';
                                  getChildren();
                                });
                              },
                            ),
                            // suffixIconConstraints: BoxConstraints(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              search = value.toUpperCase();
                            });
                            print(leadsLength);
                          },
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(searchFocusNode);
                          },
                          onSubmitted: (value) {
                            if (search.isEmpty) {
                              setState(() {
                                searchFocusNode.unfocus();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Listener(
                  onPointerHover: (event) {
                    if (searchFocusNode.hasFocus) {
                      setState(() {
                        searchFocusNode.unfocus();
                        if (search.isEmpty) {}
                      });
                    }
                  },
                  child: Scrollbar(
                    // thickness: mediaSize.width*0.02,
                    child: ListView(
                      children: getChildren(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getChildren(){
    List<Widget> children = [];
    leadsLength = 0;
    // filteredData.clear();
    for (var element in widget.screenData) {
      if (search.isEmpty || isSearchPresent(element)) {
        if (isDateFilter(element)) {
          children.add(LeadsBubble(
            leadId: element['leadID'].toString(),
            leadName: element['client'].toString(),
            leadContact: element['contact'].toString(),
            leadProject: element['project'].toString(),
            leadProduct: element['product'].toString(),
            tokenId: widget.tokenId,
          ));
          leadsLength+=1;
        }
      }
    }
    return children;
  }

  bool isSearchPresent(var element) {
    if (element['leadID'].toString().toUpperCase().contains(search)) {
      return true;
    } else if (element['client'].toString().toUpperCase().contains(search)) {
      return true;
    } else if (element['contact'].toString().toUpperCase().contains(search)) {
      return true;
    } else if (element['project'].toString().toUpperCase().contains(search)) {
      return true;
    } else if (element['product'].toString().toUpperCase().contains(search)) {
      return true;
    } else {
      return false;
    }
  }

  bool isDateFilter(var element) {
    String? dateType = dataFilter['Date Type'];
    if (dateType != null && dateType.isNotEmpty) {
      DateTime from = DateTime.parse(dataFilter['From']!);
      DateTime to = DateTime.parse(dataFilter['To']!);
      String elementDateTime = element[dateType];
      if (elementDateTime != null) {
        DateTime elementDate = DateTime.parse(elementDateTime.split('T')[0]);
        if (elementDate.isBefore(from) || elementDate.isAfter(to)) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    }
    return true;
  }
}

class LeadsBubble extends StatelessWidget {
  final String leadId;
  final String leadName;
  final String leadContact;
  final String leadProject;
  final String leadProduct;
  final String tokenId;

  const LeadsBubble({
    Key? key,
    required this.leadId,
    required this.leadName,
    required this.leadContact,
    required this.leadProject,
    required this.leadProduct,
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
        onPressed: () {
          Navigator.pushNamed(context, 'communication screen', arguments: {
            'Token Id': tokenId,
            'Lead Id': leadId,
            'Lead Name': leadName,
            'Lead Contact': leadContact,
            'Lead Project': leadProject
          });
        },
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
                        'Product : $leadProduct',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
