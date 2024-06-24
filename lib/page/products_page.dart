import 'package:again_inventory_project/database/product.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int) onAddProductClick;
  final Function(int, String) onEditProductClick;
  final Function refreshPage;
  const ProductsPage(
      {super.key,
      required this.onAddProductClick,
      required this.onEditProductClick,
      required this.scrollController,
      required this.refreshPage});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final Product product = Product();
  late Future<List<dynamic>> productsFuture;

  bool isSelected = false;

  void onSortPressed() {
    setState(() {
      isSelected = true;
    });
  }

  void _onAddProductPressed(int index) {
    setState(() {
      widget.onAddProductClick(index);
    });
  }

  void _onEditProductPressed(int index, String prodId) {
    setState(() {
      widget.onEditProductClick(index, prodId);
      FocusScope.of(context).unfocus();
    });
  }

  Future<List<dynamic>> fetchProducts() async {
    return await product.fetchProduct();
  }

  void refreshProducts() {
    setState(() {
      productsFuture = fetchProducts();
    });
  }

  @override
  void initState() {
    super.initState();
    productsFuture = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 15);

    return Scaffold(
      body: Padding(
        padding: padding,
        child: Column(
          children: [
            // Search Bar -- HERE
            _searchBarMain(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.sort),
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      _sortButtons("All"),
                      _sortButtons("Low Stock"),
                      _sortButtons("Out of Stock"),
                    ],
                  ),
                ),
              ],
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
                          style: TextStyle(
                              fontFamily: "Inter", color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),

            Expanded(
                child: FutureBuilder<List<dynamic>>(
                    future: productsFuture,
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
                          controller: widget.scrollController,
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
      ),
    );
  }

  Widget _sortButtons(String name, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFB73030) : Colors.white,
          foregroundColor: isSelected ? Colors.white : const Color(0xFFB73030),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          minimumSize: const Size(80, 35),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Color(0xFFB73030))),
        ),
        child: Text(name),
      ),
    );
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
          color: const Color(0xffA52A2A),
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
        ),
        child: InkWell(
          onTap: () => _onEditProductPressed(5, id),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(productName,
                          style: const TextStyle(
                              fontFamily: "Inter",
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                              fontSize: 20)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("ID:",
                                style: TextStyle(
                                    fontFamily: "Inter",
                                    color: white,
                                    fontWeight: FontWeight.w500)),
                            Flexible(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: " $id",
                                  style: const TextStyle(
                                      fontFamily: "Inter", color: white),
                                ),
                              ),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Stock:",
                        style: TextStyle(fontFamily: "Inter", color: white)),
                    Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.remove),
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              minimumSize: const Size(5, 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                          Row(
                            children: [
                              Text("$stock"),
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              minimumSize: const Size(5, 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
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
