import 'dart:async';

import 'package:again_inventory_project/database/product.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int, bool) onAddProductClick;
  final Function(int, String) onEditProductClick;

  const ProductsPage({
    super.key,
    required this.onAddProductClick,
    required this.onEditProductClick,
    required this.scrollController,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final Product product = Product();
  List<dynamic> products = [];

  final TextEditingController _searchQuery = TextEditingController();

  bool hasMore = true;
  int page = 1;
  int limit = 10;
  // late Future<List<dynamic>> productsFuture;

  bool isSelected = false;
  Timer? _debounce;

  bool toRefreshProduct = false;

  // sort button
  String selectedSort = "All";

  void _onSortPressed(String sortOption) {
    setState(() {
      selectedSort = sortOption;
      // Add your sorting logic here if needed
    });
  }

  void onSortPressed() {
    setState(() {
      isSelected = true;
    });
  }

  void _onAddProductPressed(int index, bool plsWork) {
    setState(() {
      widget.onAddProductClick(index, plsWork);
      if (plsWork) {
        refreshProducts();
        toRefreshProduct = false;
      }
    });
  }

  void _onEditProductPressed(int index, String prodId) {
    setState(() {
      widget.onEditProductClick(index, prodId);
      FocusScope.of(context).unfocus();
      refreshProducts();
    });
  }

  void refreshProducts() {
    setState(() {
      hasMore = true;
      products.clear();
      page = 1;
      fetchProducts(page);
      _searchQuery.text = "";
    });
  }

  void searchProduct() {
    setState(() {
      products.clear();
      page = 1;
      fetchSearchResult(_searchQuery.text, page);
      if (products.length < limit * page) {
        hasMore = false;
      } else {
        hasMore = true;
      }
    });
  }

  Future<void> fetchSearchResult(String searchQuery, int page) async {
    try {
      final newProducts =
          await product.fetchSearchResult(searchQuery, limit, page);
      setState(() {
        products.addAll(newProducts);
        if (products.length < limit * page) {
          hasMore = false;
        }
      });
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> fetchProducts(int page) async {
    try {
      final newProducts = await product.fetchProduct(limit, page);
      setState(() {
        products.addAll(newProducts);
        if (products.length < limit * page) {
          hasMore = false;
        }
      });
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        searchProduct();
      } else {
        refreshProducts();
      }
    });
  }

  // Future<List<dynamic>> fetchProducts() async {
  //   return await product.fetchProduct();
  // }

  // Future refreshProducts() async {
  //   setState(() {
  //     productsFuture = fetchProducts();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    fetchProducts(page);
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.maxScrollExtent ==
          widget.scrollController.offset) {
        setState(() {
          page++;
          if (_searchQuery.text.isEmpty) {
            fetchProducts(page);
          } else {
            fetchSearchResult(_searchQuery.text, page);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.scrollController.dispose();
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 15);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
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
                      _onAddProductPressed(4, false);
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
                child: RefreshIndicator(
              onRefresh: () async => refreshProducts(),
              child: ListView.builder(
                controller: widget.scrollController,
                itemCount: products.length + 1,
                itemBuilder: (context, index) {
                  if (index < products.length) {
                    final product = products[index];
                    return _productListTile(
                      product['product_name'],
                      product['_id'],
                      product['product_price'],
                      product['quantity'],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: hasMore
                            ? const CircularProgressIndicator()
                            : const Text("No more data to load."),
                      ),
                    );
                  }
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _sortButtons(String name) {
    bool isSelected = selectedSort == name;
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ElevatedButton(
        onPressed: () => _onSortPressed(name),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFB73030) : Colors.white,
          foregroundColor: isSelected ? Colors.white : const Color(0xFFB73030),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          minimumSize: const Size(80, 35),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Color(0xFFB73030))),
        ),
        child: Text(name,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
      ),
    );
  }

  Widget _searchBarMain() {
    return SizedBox(
      height: 60,
      child: TextField(
        controller: _searchQuery,
        onSubmitted: (String value) {
          FocusScope.of(context).unfocus();
          _onSearchChanged(value);
        },
        onChanged: _onSearchChanged,
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
          suffixIcon: _searchQuery.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchQuery.clear();
                    setState(() {
                      FocusScope.of(context).unfocus();
                      _searchQuery.text = "";
                    });
                    refreshProducts(); // Optional: Refresh products if needed
                  },
                )
              : const Icon(
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
          color: const Color.fromARGB(255, 180, 44, 44),
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
        ),
        child: InkWell(
          onTap: () => _onEditProductPressed(5, id),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(productName,
                          style: const TextStyle(
                              fontFamily: "Inter",
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
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
                        style: TextStyle(
                            fontFamily: "Inter",
                            color: white,
                            fontWeight: FontWeight.w300)),
                    Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        children: [
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(Icons.remove),
                          //   style: IconButton.styleFrom(
                          //     padding: const EdgeInsets.all(0),
                          //     minimumSize: const Size(5, 5),
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(5)),
                          //   ),
                          // ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "$stock",
                              style: const TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(Icons.add),
                          //   style: IconButton.styleFrom(
                          //     padding: const EdgeInsets.all(0),
                          //     minimumSize: const Size(5, 5),
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(5)),
                          //   ),
                          // ),
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
