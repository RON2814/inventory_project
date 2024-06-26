import 'package:again_inventory_project/database/product.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final Function(int) onDashboardClick;

  const Dashboard({super.key, required this.onDashboardClick});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final Product product = Product();
  Map<String, dynamic> fetchTotal = {};
  int? totalProd;

  void _onDashboardPressed(int index) {
    setState(() {
      widget.onDashboardClick(index);
    });
  }

  void _totalProduct() async {
    try {
      fetchTotal = await product.fetchTotalProduct();
      setState(() {
        totalProd = fetchTotal["total_product"];
      });
    } catch (e) {
      throw Exception('Error fetching total product data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _totalProduct();
  }

  static Color colorWhite = Colors.white;

  static const padding = EdgeInsets.symmetric(horizontal: 15, vertical: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: dashboardMenu("TOTAL PRODUCT",
                      'lib/asset/images/product.png', totalProd, 1),
                ),
                Expanded(
                  child: dashboardMenu(
                      "OUT OF STOCK", 'lib/asset/images/outstock.png', 0, 1),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: dashboardMenu(
                      "LOW STOCK", 'lib/asset/images/lowstock.png', 2, 1),
                ),
                Expanded(
                  child: dashboardMenu("TOTAL EXPENSES",
                      'lib/asset/images/expenses.png', 945, 0),
                ),
              ],
            ),
            Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: ElevatedButton(
                    onPressed: () {
                      _onDashboardPressed(4);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: const Color(0xff23224C),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add, color: Colors.white),
                        Text(
                          "Add Products",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: colorWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Recent Products',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _onDashboardPressed(1);
                      },
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                FutureBuilder<List<dynamic>>(
                    future: product.fetchRecentProduct(),
                    builder: (context, snapshot) {
                      try {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No recent products found'));
                        } else {
                          return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length > 4
                                  ? 4
                                  : snapshot.data!.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (context, index) {
                                final product = snapshot.data![index];
                                return listViewRecent(
                                    product['product_name'],
                                    product['quantity'],
                                    product['product_price']);
                              });
                        }
                      } catch (e) {
                        return Center(child: Text('Error: $e'));
                      }
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardMenu(
      String text, String imagePath, int? totalProd, int index) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffB73030),
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          onTap: () {
            _onDashboardPressed(index);
          },
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Image.asset(
                        imagePath,
                        width: 58,
                        height: 58,
                      ),
                      if (totalProd == null)
                        const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                      else
                        Text(
                          "$totalProd",
                          style: TextStyle(
                            color: Colors.red.shade100,
                            fontSize: 30,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listViewRecent(String productName, int stock, int price) {
    return SizedBox(
      height: 60,
      child: ListTile(
          // leading: Image.asset(
          //   products[index].imagePath,
          //   height: 50,
          //   width: 50,
          // ),
          leading: Transform.translate(
            offset: const Offset(-10, 0),
            child: const Icon(
              Icons.conveyor_belt,
              size: 50,
            ),
          ),
          title: Transform.translate(
            offset: const Offset(-10, 0),
            child: Text(
              productName,
              style: const TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          subtitle: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                '$stock in stock',
                style: const TextStyle(
                  fontFamily: "Inter",
                ),
              )),
          trailing: Text('₱$price',
              style: const TextStyle(
                  fontFamily: "Inter",
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16))),
    );
  }
}
