import 'package:again_inventory_project/page/account/edit_profile.dart';
import 'package:again_inventory_project/page/history.dart';
import 'package:again_inventory_project/page/products/add_product.dart';
import 'package:again_inventory_project/page/dashboard.dart';
import 'package:again_inventory_project/page/products/update_product.dart';
import 'package:again_inventory_project/page/products/products_page.dart';
import 'package:again_inventory_project/page/account/account.dart';
import 'package:again_inventory_project/widget/bottom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int _currentPage = 0;

  String _productId = "";

  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;
  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isScrollingDown) {
          setState(() {
            _isScrollingDown = true;
            _isVisible = false;
          });
        }
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isScrollingDown) {
          setState(() {
            _isScrollingDown = false;
            _isVisible = true;
          });
        }
      }
    });
  }

  void _onItemPressed(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 4) {
        _currentPage = 1;
      } else if (_selectedIndex == 6) {
        _currentPage = 3;
      } else {
        _currentPage = index;
      }
      FocusScope.of(context).unfocus();
    });
  }

  void _onEditPressed(int index, String prodId) {
    setState(() {
      _selectedIndex = index;
      _currentPage = 1;
      _productId = prodId;
    });
  }

  void _refreshSelectedPage() {
    setState(() {});
  }

  static Color appbarColor = const Color.fromARGB(255, 188, 62, 62);
  static Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                        decoration: BoxDecoration(
                          color: appbarColor,
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(18)),
                        ),
                        child: IndexedStack(
                          index: _selectedIndex,
                          children: [
                            appbarHome(),
                            appbarOther(1),
                            appbarOther(2),
                            appbarOther(3),
                            appbarOther(4),
                            appbarOther(5),
                            appbarOther(6),
                          ],
                        )),
                  ),
                  Expanded(
                    flex: 14,
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: [
                        Dashboard(onDashboardClick: _onItemPressed),
                        ProductsPage(
                          onAddProductClick: _onItemPressed,
                          onEditProductClick: _onEditPressed,
                          scrollController: _scrollController,
                        ),
                        const History(),
                        AccountPage(onAccountClick: _onItemPressed),
                        AddProduct(onAddedClick: _onItemPressed),
                        UpdateProduct(productId: _productId),
                        const EditProfile()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            _selectedIndex < 4
                ? AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    left: 20,
                    right: 20,
                    bottom: _isVisible ? 20 : -kBottomNavigationBarHeight - 20,
                    child: BottomAppbar(
                      onItemClicked: _onItemPressed,
                      currentIndex: _currentPage,
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget appbarOther(int index) {
    String selectedTitle = "";
    switch (index) {
      case 1:
        selectedTitle = "Products";
        break;
      case 2:
        selectedTitle = "History";
        break;
      case 3:
        selectedTitle = "Account";
        break;
      case 4:
        selectedTitle = "Add Product";
        break;
      case 5:
        selectedTitle = "Update Product";
        break;
      case 6:
        selectedTitle = "Edit Profile";
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              if (_selectedIndex == 4 || _selectedIndex == 5) {
                _onItemPressed(1);
              } else if (_selectedIndex == 6) {
                _onItemPressed(3);
              } else {
                _onItemPressed(0);
              }
            });
          },
          child: Icon(
            Icons.arrow_back,
            size: 40,
            color: white,
          ),
        ),
        const Spacer(),
        Center(
          child: Text(
            selectedTitle,
            style: TextStyle(
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: white,
            ),
          ),
        ),
        const Spacer(),
        const SizedBox(width: 60)
      ],
    );
  }

  Widget appbarHome() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome, <user>!",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: white),
              ),
              const Text(
                "Dashboard",
                style: TextStyle(
                  color: Colors.white54,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              )
            ],
          ),
          const Spacer(),
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue,
            child: ClipOval(
              child: Image.asset(
                'lib/asset/images/image.png',
                width: 50,
                height: 50,
              ),
            ),
          )
        ],
      ),
    );
  }
}
