import 'package:city_connect/clock.dart';
import 'package:flutter/material.dart';
import 'package:city_connect/data/routes.dart';
import 'package:intl/intl.dart';

bool isHoliday = false;

class RouteSchedule extends StatelessWidget {
 const RouteSchedule(this.id, {super.key});
  final int id;

  @override
  Widget build(BuildContext context) {
    String beforeTimeString = "";
    String afterTimeString = " ";
    // Get the current date
    DateTime now = DateTime.now();

    // Check if the current date is Sunday (weekday value of 7 in Dart)
    if (now.weekday == DateTime.sunday) {
      isHoliday = true;
    }
    final List<String> timeList = isHoliday &
            routes.firstWhere((element) => element.id == id).isHolidayApplicable
        ? routes.firstWhere((element) => element.id == id).holidayTimings
        : routes.firstWhere((element) => element.id == id).timings;
    // Function to parse time string to DateTime
    DateTime parseTime(String time) {
      List<String> parts = time.split(":");
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      return DateTime(2024, 1, 1, hour,
          minute); // Using a dummy date (2024-01-01) for comparison
    }

// Function to format DateTime to time string
    // String formatTime(DateTime time) {
    //   String hour = time.hour.toString().padLeft(2, '0');
    //   String minute = time.minute.toString().padLeft(2, '0');
    //   return "$hour:$minute";
    // }

    // Format the current time to hh:mm format
    String targetTime = DateFormat.Hm().format(now);

    // Parse target time to DateTime
    DateTime targetDateTime = parseTime(targetTime);

    // Convert all times in the list to DateTime objects
    List<DateTime> dateTimeList =
        timeList.map((time) => parseTime(time)).toList();

    // Sort the list of DateTime objects
    dateTimeList.sort((a, b) => a.compareTo(b));

    // Find the index of the target time in the sorted list
    int index = dateTimeList.indexWhere((time) => time.isAfter(targetDateTime));

    if (index != -1) {
      // Retrieve the time just before and after the target time
      DateTime beforeTime = dateTimeList[index - 1];
      DateTime afterTime = dateTimeList[index];

      // Format the times back to hh:mm format
      beforeTimeString = DateFormat.jm().format(beforeTime);
      afterTimeString = DateFormat.jm().format(afterTime);
    } else {}
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Schedule'),
      ),
      body: Center(
        child: Column(children: [
          const Clock(),
          Text("Last Bus was scheduled at $beforeTimeString"),
          Text("Next Bus is scheduled at $afterTimeString"),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                horizontalMargin: 10,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Time',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: <DataRow>[
                  ...routes
                      .firstWhere((element) => element.id == id)
                      .timings
                      .map(
                        (e) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(DateFormat.jm().format(parseTime(e)).toString())),
                          ],
                        ),
                      )
                      .toList()
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
