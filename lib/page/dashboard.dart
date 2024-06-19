import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final Function(int) onAddProductClick;
  const Dashboard({super.key, required this.onAddProductClick});

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
                  child: dashboardMenu(
                      text: "TOTAL PRODUCT", icon: Icons.inventory_2_outlined),
                ),
                Expanded(
                  child: dashboardMenu(
                      text: "OUT OF STOCK",
                      icon: Icons.production_quantity_limits_outlined),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: dashboardMenu(
                      text: "LOW STOCK",
                      icon: Icons.production_quantity_limits),
                ),
                Expanded(
                  child: dashboardMenu(
                      text: "TOTAL EXPENSES",
                      icon: Icons.attach_money_outlined),
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
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor: const Color(0xff23224C)),
                    child: Row(
                      children: [
                        const Icon(Icons.add, color: Colors.white),
                        Text(
                          "Add Products",
                          style: TextStyle(
                              fontFamily: "Poppins", color: colorWhite),
                        )
                      ],
                    ),
                  ),
                )
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
                      return listViewRecent("Dummy", 25, 254);
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget dashboardMenu({required String text, required IconData icon}) {
    const padding = EdgeInsets.symmetric(horizontal: 5);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xffB73030),
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: InkWell(
          onTap: () {},
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: padding,
                        child: Icon(
                          icon,
                          color: colorWhite,
                          size: 40,
                        ),
                      ),
                      Padding(
                        padding: padding,
                        child: Text(
                          "₱<INT>",
                          style: TextStyle(
                              color: Colors.red.shade100,
                              fontFamily: "Roboto",
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    text,
                    style: TextStyle(color: colorWhite, fontFamily: "Roboto"),
                  )
                ],
              ),
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
