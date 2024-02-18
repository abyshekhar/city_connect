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
    // String beforeTimeString = "";
    String afterTimeString = " ";
    String displayText =
        routes.firstWhere((element) => element.id == id).displayText;
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
    String first = DateFormat('hh:mm a').format(dateTimeList.first);
    String last = DateFormat('hh:mm a').format(dateTimeList.last);
    // Find the index of the target time in the sorted list
    int index = dateTimeList.indexWhere((time) => time.isAfter(targetDateTime));

    if (index != -1) {
      // Retrieve the time just before and after the target time
      // DateTime beforeTime = dateTimeList[index - 1];
      DateTime afterTime = dateTimeList[index];

      // Format the times back to hh:mm format
      // beforeTimeString = DateFormat.jm().format(beforeTime);
      afterTimeString = DateFormat.jm().format(afterTime);
    } else {
      afterTimeString = "$first(Morning)";
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Schedule'),
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(displayText,
                style: const TextStyle(
                  color: Color.fromARGB(255, 2, 95, 23),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                )),
          ),
          const Clock(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("First Bus : ",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  )),
              Text(first,
                  style: const TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Last Bus : ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    )),
                Text(last,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Next Bus : ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    )),
                Text(afterTimeString,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ))
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 200, // Set the desired width
              height: 200, // Set the desired height
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  horizontalMargin: 10,
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Complete\nSchedule',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    ...timeList
                        .map(
                          (e) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(
                                  DateFormat.jm()
                                      .format(parseTime(e))
                                      .toString(),
                                  style: const TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: Colors.green,
                                      fontSize: 20))),
                            ],
                          ),
                        )
                        .toList()
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
