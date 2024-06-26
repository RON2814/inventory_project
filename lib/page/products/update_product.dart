import 'package:again_inventory_project/database/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateProduct extends StatefulWidget {
  final String productId;
  const UpdateProduct({
    super.key,
    required this.productId,
  });

  @override
  State<UpdateProduct> createState() => UpdateProductState();
}

class UpdateProductState extends State<UpdateProduct> {
  final Product product = Product();
  Map<String, dynamic> productMap = {};

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _dateAdded;
  final DateFormat _dateFormat = DateFormat.yMMMMd();
  String? _formattedDate;

  bool isUpdating = false;

  @override
  void didUpdateWidget(covariant UpdateProduct oldWidget) {
    if (widget.productId != oldWidget.productId) {
      setState(() {
        isUpdating = true;
      });
      _getProductData();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _getProductData() async {
    try {
      productMap = await product.fetchOneProduct(widget.productId);

      _nameController.text = productMap["product_name"] ?? "";
      _priceController.text = productMap["product_price"].toString();
      _quantityController.text = productMap["quantity"].toString();
      _categoryController.text = productMap["category"] ?? "";
      _descriptionController.text = productMap["description"] ?? "";
      _dateAdded = DateTime.parse(
          productMap["date_added"] ?? "2024-01-01 12:00:00.000Z");

      _formattedDate = _dateFormat.format(_dateAdded!);

      setState(() {
        isUpdating = false;
      });
    } catch (e) {
      throw Exception('Error fetching product data: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: isUpdating
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text(
                      'Product added: $_formattedDate',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      enabled: false,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Your Product Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Your Product Price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the product price';
                        } else if (int.parse(value) < 0) {
                          return "$value must be greater than 1.";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the quantity';
                        } else if (int.parse(value) < 0) {
                          return "$value must be greater than 0.";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _categoryController,
                      decoration: InputDecoration(
                        labelText: 'Product Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the product category';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Product Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the product description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFB73030),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Color(0xFFB73030))),
                      ),
                      child: const Text('Update Product',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB73030),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Delete Product',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
