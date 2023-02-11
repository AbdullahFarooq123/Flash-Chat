import 'package:flashchat/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class LeadsFilterScreen extends StatefulWidget {
  final Map<String, String> dataFilter;

  const LeadsFilterScreen({Key? key, required this.dataFilter})
      : super(key: key);

  @override
  State<LeadsFilterScreen> createState() => _LeadsFilterScreenState();
}

class _LeadsFilterScreenState extends State<LeadsFilterScreen> {
  String dateType = 'Lead Date';
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  Map<String, String> data = {
    'Lead Date': 'leadDate',
    'Assign Date': 'assignedAT',
    'Follow-up Date': 'followUpOn',
    'Communication': 'communicationAT'
  };

  @override
  initState() {
    super.initState();
    String? dateType = widget.dataFilter['Date Type'];
    if (dateType!.isNotEmpty) {
      data.forEach((key, value) {
        if (value == dateType) {
          this.dateType = key;
          return;
        }
      });
      fromController.text = getDate(DateTime.parse(widget.dataFilter['From']!));
      toController.text = getDate(DateTime.parse(widget.dataFilter['To']!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkColor,
      appBar: AppBar(
        title: const Text('Filter'),
        backgroundColor: kDarkColor,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: kLightColor,
                        //background color of dropdown button
                        border: Border.all(color: kLightColor, width: 3),
                        //border of dropdown button
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            iconEnabledColor: Colors.white,
                            dropdownColor: kLightColor,
                            style: const TextStyle(color: Colors.white),
                            // borderRadius: BorderRadius.all(Radius.circular(100)),
                            items: <String>[
                              'Lead Date',
                              'Assign Date',
                              'Follow-up Date',
                              'Communication'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (data) {
                              setState(() {
                                dateType = data!;
                              });
                            },
                            value: dateType,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: 'From',
                    controller: fromController,
                    onPressed: () async {
                      String value =
                          await PopupCalendar(dialogCalendarPickerValue: [
                        (fromController.text.isNotEmpty
                            ? DateTime.parse(
                                getFormattedDate(fromController.text))
                            : DateTime.parse(getFormattedDate(getDate(DateTime.now())))),
                      ], context: context)
                              .getDates();
                      List<String> dates = value.split('  to ');
                      if (dates.length == 2) {
                        String from = getDate(DateTime.parse(dates[0]));
                        String to = dates[1].contains('null')
                            ? ''
                            : getDate(
                                DateTime.parse(dates[1].replaceAll(" ", '')));
                        fromController.text = from;
                        toController.text =
                            to.isNotEmpty ? to : toController.text;
                      }
                    },
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    hintText: 'To',
                    controller: toController,
                    onPressed: () async {
                      String value =
                          await PopupCalendar(dialogCalendarPickerValue: [
                        (toController.text.isNotEmpty
                            ? DateTime.parse(
                                getFormattedDate(toController.text))
                            : DateTime.parse(getFormattedDate(getDate(DateTime.now())))),
                      ], context: context)
                              .getDates();
                      List<String> dates = value.split('  to ');
                      if (dates.length == 2) {
                        String from = getDate(DateTime.parse(dates[0]));
                        String to = dates[1].contains('null')
                            ? ''
                            : getDate(
                                DateTime.parse(dates[1].replaceAll(" ", '')));
                        fromController.text =
                            to.isNotEmpty ? from : fromController.text;
                        toController.text = to.isEmpty ? from : to;
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                GetButton(
                  onPressed: () {
                    setState(() {
                      fromController.text = getDate(DateTime.now());
                      toController.text = getDate(DateTime.now());
                    });
                  },
                  buttonText: 'Today',
                ),
              ],
            ),
            Row(
              children: [
                GetButton(
                    onPressed: () {
                      setState(() {
                        fromController.text = getDate(
                            DateTime.now().subtract(const Duration(days: 1)));
                        toController.text = getDate(
                            DateTime.now().subtract(const Duration(days: 1)));
                      });
                    },
                    buttonText: 'Yesterday'),
                GetButton(
                    onPressed: () {
                      setState(() {
                        fromController.text = getDate(
                            DateTime.now().subtract(const Duration(days: -1)));
                        toController.text = getDate(
                            DateTime.now().subtract(const Duration(days: -1)));
                      });
                    },
                    buttonText: 'Tomorrow'),
              ],
            ),
            Row(
              children: [
                GetButton(
                    onPressed: () {
                      setState(() {
                        DateTime thisWeekStart = DateTime.now().subtract(
                            Duration(days: DateTime.now().weekday - 1));
                        fromController.text = getDate(thisWeekStart);
                        toController.text =
                            getDate(thisWeekStart.add(const Duration(days: 6)));
                      });
                    },
                    buttonText: 'This Week'),
                GetButton(
                    onPressed: () {
                      setState(() {
                        DateTime lastWeekStart = DateTime.now().subtract(
                            Duration(days: DateTime.now().weekday + 6));
                        fromController.text = getDate(lastWeekStart);
                        toController.text =
                            getDate(lastWeekStart.add(const Duration(days: 6)));
                      });
                    },
                    buttonText: 'Last Week'),
              ],
            ),
            Row(
              children: [
                GetButton(
                    onPressed: () {
                      setState(() {
                        DateTime today = DateTime.now();
                        fromController.text =
                            getDate(DateTime(today.year, today.month, 1));
                        toController.text =
                            getDate(DateTime(today.year, today.month + 1, 0));
                      });
                    },
                    buttonText: 'This Month'),
                GetButton(
                    onPressed: () {
                      setState(() {
                        DateTime today = DateTime.now();
                        fromController.text =
                            getDate(DateTime(today.year, today.month - 1, 1));
                        toController.text =
                            getDate(DateTime(today.year, today.month, 0));
                      });
                    },
                    buttonText: 'Last Month'),
              ],
            ),
            Row(
              children: [
                GetButton(
                    onPressed: () {
                      setState(() {
                        DateTime today = DateTime.now();
                        fromController.text =
                            getDate(DateTime(today.year, DateTime.january, 1));
                        toController.text = getDate(
                            DateTime(today.year + 1, DateTime.january, 0));
                      });
                    },
                    buttonText: 'This Year'),
                GetButton(
                    onPressed: () {
                      setState(() {
                        DateTime today = DateTime.now();
                        fromController.text = getDate(
                            DateTime(today.year - 1, DateTime.january, 1));
                        toController.text =
                            getDate(DateTime(today.year, DateTime.january, 0));
                      });
                    },
                    buttonText: 'Last Year'),
              ],
            ),
            Row(
              children: [
                GetButton(
                    onPressed: () {
                      setState(() {
                        dateType = 'Lead Date';
                        fromController.text = '';
                        toController.text = '';
                      });
                    },
                    buttonText: 'Clear'),
                GetButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'Date Type': fromController.text.isNotEmpty &&
                                toController.text.isNotEmpty
                            ? data[dateType]
                            : '',
                        'From': fromController.text.isNotEmpty
                            ? getFormattedDate(fromController.text)
                            : '',
                        'To': toController.text.isNotEmpty
                            ? getFormattedDate(toController.text)
                            : '',
                      });
                    },
                    buttonText: 'Done'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getDate(DateTime today) {
    return DateFormat('dd-MM-yyyy').format(today);
  }

  String getFormattedDate(String date) {
    String day = date.split('-')[0];
    String month = date.split('-')[1];
    String year = date.split('-')[2];
    return '$year-$month-$day';
  }
}

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onPressed;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
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
        textAlign: TextAlign.center,
        readOnly: true,
        controller: widget.controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: widget.hintText,
          labelStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w800),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.calendar_month,
              color: kDarkColor,
            ),
            onPressed: widget.onPressed,
          ),
          hintStyle: const TextStyle(
            color: Colors.transparent,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            borderSide: BorderSide(color: kDarkColor, width: 5.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            borderSide: BorderSide(color: kDarkColor, width: 5.0),
          ),
        ),
      ),
    );
  }
}

class GetButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const GetButton({Key? key, required this.onPressed, required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kLightColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          child: Text(buttonText),
        ),
      ),
    );
  }
}

class PopupCalendar {
  final config = CalendarDatePicker2WithActionButtonsConfig(
    firstDate: DateTime(2000,1,1),
    lastDate: DateTime(2050,12,31),
    calendarType: CalendarDatePicker2Type.range,
    selectedDayHighlightColor: kLighterColor,
    shouldCloseDialogAfterCancelTapped: true,
    weekdayLabelTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    controlsTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    dayTextStyle: const TextStyle(color: Colors.white),
    selectedDayTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    disabledDayTextStyle: const TextStyle(color: kLighterColor),
    okButtonTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    cancelButtonTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    lastMonthIcon: const Icon(Icons.navigate_before, color: Colors.white),
    nextMonthIcon: const Icon(Icons.navigate_next, color: Colors.white),

  );
  List<DateTime?> dialogCalendarPickerValue;
  final BuildContext context;

  PopupCalendar({
    required this.dialogCalendarPickerValue,
    required this.context,
  });

  Future<String> getDates() async {
    var values = await showCalendarDatePicker2Dialog(
      context: context,
      config: config,
      dialogSize: const Size(325, 400),
      borderRadius: 15,
      initialValue: dialogCalendarPickerValue,
      dialogBackgroundColor: kLightColor,
    );
    if (values != null) {
      dialogCalendarPickerValue = values;
      return _getValueText(
        config.calendarType,
        values,
      );
    } else {
      return DateTime.now().toString();
    }
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');
    if (values.isNotEmpty) {
      var startDate = values[0].toString().replaceAll('00:00:00.000', '');
      var endDate = values.length > 1
          ? values[1].toString().replaceAll('00:00:00.000', '')
          : 'null';
      valueText = '$startDate to $endDate';
    } else {
      return 'null';
    }

    return valueText;
  }
}
