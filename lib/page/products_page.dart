import 'package:again_inventory_project/database/product.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  final Function(int) onAddProductClick;
  const ProductsPage({super.key, required this.onAddProductClick});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  void _onAddProductPressed(int index) {
    setState(() {
      widget.onAddProductClick(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Product product = Product();

    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 15);

    return Padding(
      padding: padding,
      child: Column(
        children: [
          // Search Bar -- HERE
          _searchBarMain(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Icon(Icons.sort)),
                _sortButtons("ALL"),
                _sortButtons("Low Stock"),
                _sortButtons("Out of Stock"),
              ],
            ),
          ),
          Row(
            children: [
              const Text("All products",
                  style: TextStyle(fontFamily: "Inter", fontSize: 18)),
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
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        "Add Products",
                        style:
                            TextStyle(fontFamily: "Inter", color: Colors.white),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),

          Expanded(
              child: FutureBuilder<List<dynamic>>(
                  future: product.fetchProduct(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No recent products found'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final product = snapshot.data![index];
                          return _productListTile(
                            product['product_name'],
                            product['_id'],
                            product['product_price'],
                            product['quantity'],
                          );
                        },
                      );
                    }
                  }))
        ],
      ),
    );
  }

  Widget _sortButtons(String name) {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(name));
  }

  Widget _searchBarMain() {
    return SizedBox(
      height: 60,
      child: TextField(
        style: const TextStyle(
          fontFamily: "Inter",
          color: Color(0xff020202),
          fontSize: 20,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xfff1f1f1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xffB73030),
              width: 2.0,
            ),
          ),
          hintText: "Search",
          hintStyle: const TextStyle(
            fontFamily: "Inter",
            color: Color(0xffb2b2b2),
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
            decorationThickness: 6,
          ),
          suffixIcon: const Icon(
            Icons.search,
            size: 35,
          ),
          prefixIconColor: Colors.black,
        ),
      ),
    );
  }

  Widget _productListTile(String productName, String id, int price, int stock) {
    const Color white = Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 180, 44, 44),
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
        ),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName,
                        style: const TextStyle(
                            fontFamily: "Inter",
                            color: white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18)),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      const Text("ID:",
                          style: TextStyle(
                              fontFamily: "Inter",
                              color: white,
                              fontWeight: FontWeight.w500)),
                      Text(" $id",
                          style: const TextStyle(
                              fontFamily: "Inter", color: white))
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      const Text("Price:",
                          style: TextStyle(
                              fontFamily: "Inter",
                              color: white,
                              fontWeight: FontWeight.w500)),
                      Text(" ₱$price",
                          style: const TextStyle(
                              fontFamily: "Inter",
                              color: white,
                              fontStyle: FontStyle.italic))
                    ]),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Stock:",
                        style: TextStyle(fontFamily: "Inter", color: white)),
                    Container(
                      decoration: const BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.remove),
                          Text("$stock"),
                          const Icon(Icons.add)
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
