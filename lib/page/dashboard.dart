import 'package:flutter/material.dart';
import 'package:again_inventory_project/widget/dashboardmenu.dart'; // Assuming dashboardmenu.dart is in the correct location

class Dashboard extends StatefulWidget {
  final Function(int) onAddProductClick;

  const Dashboard({Key? key, required this.onAddProductClick}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  void _onAddProductPressed(int index) {
    setState(() {
      widget.onAddProductClick(index);
    });
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
                  child: DashboardMenu(
                    text: "TOTAL PRODUCT",
                    imagePath: 'lib/asset/images/product.png',
                  ),
                ),
                Expanded(
                  child: DashboardMenu(
                    text: "OUT OF STOCK",
                    imagePath: 'lib/asset/images/outstock.png',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DashboardMenu(
                    text: "LOW STOCK",
                    imagePath: 'lib/asset/images/lowstock.png',
                  ),
                ),
                Expanded(
                  child: DashboardMenu(
                    text: "TOTAL EXPENSES",
                    imagePath: 'lib/asset/images/expenses.png',
                  ),
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
                      _onAddProductPressed(4);
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
                      padding: EdgeInsets.only(left: 10),
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
                      onPressed: () {},
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
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return listViewRecent("Dummy", 25, 254); // Adjust parameters as needed
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget listViewRecent(String productName, int stock, int price) {
    return SizedBox(
      height: 60,
      child: ListTile(
        leading: Transform.translate(
          offset: const Offset(-10, 0),
          child: const Icon(
            Icons.check_box_outline_blank_outlined,
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
              fontSize: 20,
            ),
          ),
        ),
        subtitle: Transform.translate(
          offset: const Offset(-10, 0),
          child: Text(
            '$stock in stock',
            style: const TextStyle(
              fontFamily: "Inter",
            ),
          ),
        ),
        trailing: Text(
          '₱$price',
          style: const TextStyle(
            fontFamily: "Inter",
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}