import 'package:city_connect/clock.dart';
import 'package:flutter/material.dart';
import 'package:city_connect/data/routes.dart';

class RouteSchedule extends StatelessWidget {
  RouteSchedule(this.id, {super.key});
  final int id;
  final timings = routes[0].timings;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Schedule'),
      ),
      body: Center(
        child: Column(
          
          children: [
          const Clock(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                horizontalMargin:10,
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
                  ...timings
                      .map(
                        (e) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(e)),
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
