import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:again_inventory_project/database/product.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final Product product = Product();
  int limit = 10;
  int page = 1;
  bool hasMore = true;
  List<dynamic> historyLogs = [];
  final ScrollController _scrollController = ScrollController();

  Future<void> fetchHistory(int page) async {
    try {
      final newHistory = await product.fetchHistory(limit, page);
      setState(() {
        historyLogs.addAll(newHistory);
        if (newHistory.length < limit) {
          hasMore = false;
        }
      });
    } catch (e) {
      throw Exception('Error fetching history: $e');
    }
  }

  void refreshHistory() {
    setState(() {
      hasMore = true;
      historyLogs.clear();
      page = 1;
      fetchHistory(page);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchHistory(page);
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
              _scrollController.offset &&
          hasMore) {
        setState(() {
          page++;
          fetchHistory(page);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sort historyLogs by date in descending order
    historyLogs.sort((a, b) {
      DateTime aDate =
          DateTime.tryParse(a['updated_at'] ?? '') ?? DateTime(2024);
      DateTime bDate =
          DateTime.tryParse(b['updated_at'] ?? '') ?? DateTime(2024);
      return bDate.compareTo(aDate);
    });

    Map<String, List<Map<String, dynamic>>> groupedHistoryLogs = {};
    for (var item in historyLogs) {
      String date = item['updated_at'] ?? "2024-01-01";
      String monthYear = DateFormat.yMMMM().format(DateTime.parse(date));
      if (!groupedHistoryLogs.containsKey(monthYear)) {
        groupedHistoryLogs[monthYear] = [];
      }
      groupedHistoryLogs[monthYear]!.add(item);
    }

    List<String> sortedKeys = groupedHistoryLogs.keys.toList()
      ..sort((a, b) =>
          DateFormat.yMMMM().parse(b).compareTo(DateFormat.yMMMM().parse(a)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          TextButton(
              onPressed: refreshHistory,
              child: const Row(
                children: [Icon(Icons.refresh, size: 30), Text("Refresh")],
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: RefreshIndicator(
          onRefresh: () async => refreshHistory(),
          child: ListView(
            controller: _scrollController,
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
                    children: groupedHistoryLogs[monthYear]!.map((item) {
                      bool isAdded = item['is_added'] ?? false;
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 9),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color(0xFF3E0505), width: 2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 12,
                            height: double.infinity,
                            color: isAdded ? Colors.green : Colors.red,
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['product_name'] ?? 'Unknown',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                        fontSize: 17)),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'ID: ',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.5),
                                      ),
                                      TextSpan(
                                        text: item['id']?.toString() ?? 'N/A',
                                        style: const TextStyle(
                                            fontFamily: 'Inter', fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                    DateFormat.yMMMd().format(DateTime.tryParse(
                                            item['updated_at'] ?? '') ??
                                        DateTime(2024)),
                                    style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.5)),
                              ],
                            ),
                          ),
                          trailing: Text(item['qty']?.toString() ?? '0',
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
