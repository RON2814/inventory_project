import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final List<Map<String, String>> items = [
    {'date': '2024-01-24', 'name': 'Product A', 'id': '0963736112', 'quantity': '5', 'type': 'decrease'},
    {'date': '2024-05-24', 'name': 'Product B', 'id': '0963736113', 'quantity': '3', 'type': 'increase'},
    {'date': '2024-06-26', 'name': 'Product C', 'id': '0963736114', 'quantity': '2', 'type': 'increase'},
    {'date': '2023-12-20', 'name': 'Product D', 'id': '0963736115', 'quantity': '4', 'type': 'decrease'},
  ];

  @override
  Widget build(BuildContext context) {
    // Sort items by date in descending order
    items.sort((a, b) => DateTime.parse(b['date']!).compareTo(DateTime.parse(a['date']!)));

    Map<String, List<Map<String, String>>> groupedItems = {};
    for (var item in items) {
      String date = item['date']!;
      String monthYear = DateFormat.yMMMM().format(DateTime.parse(date));
      if (!groupedItems.containsKey(monthYear)) {
        groupedItems[monthYear] = [];
      }
      groupedItems[monthYear]!.add(item);
    }

    List<String> sortedKeys = groupedItems.keys.toList()
      ..sort((a, b) => DateFormat.yMMMM().parse(b).compareTo(DateFormat.yMMMM().parse(a)));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: sortedKeys.map((monthYear) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    monthYear,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Column(
                  children: groupedItems[monthYear]!.map((item) {
                    bool isIncrease = item['type'] == 'increase';
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 9),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFF3E0505), width: 2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 12,
                          height: double.infinity,
                          color: isIncrease ? Colors.green : Colors.red,
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 0.1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', fontSize: 17)),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'ID: ',
                                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13.5),
                                    ),
                                    TextSpan(
                                      text: item['id'],
                                      style: const TextStyle(fontFamily: 'Inter', fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Text(DateFormat.yMMMd().format(DateTime.parse(item['date']!)), style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 13.5)),
                            ],
                          ),
                        ),
                        trailing: Text(item['quantity']!, style: const TextStyle(fontSize: 22, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
