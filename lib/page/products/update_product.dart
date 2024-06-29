import 'package:again_inventory_project/database/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateProduct extends StatefulWidget {
  final String productId;
  final Function(int, bool) onUpdatedClick;
  const UpdateProduct({
    super.key,
    required this.productId,
    required this.onUpdatedClick,
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

  // old quantity
  int? oldQty, toUpdateQty;
  String? updatedAt;
  String? productName;
  bool? isAdded;

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
      _dateAdded = DateTime.parse(productMap["date_added"]);

      _formattedDate = _dateFormat.format(_dateAdded!);

      oldQty = productMap["quantity"];
      productName = productMap["product_name"];

      setState(() {
        isUpdating = false;
      });
    } catch (e) {
      throw Exception('Error fetching product data: $e');
    }
  }

  void _updateProduct() async {
    FocusScope.of(context).unfocus();
    try {
      if (_formKey.currentState!.validate()) {
        var result = await product.updateProduct(
          widget.productId,
          _nameController.text,
          int.parse(_priceController.text),
          int.parse(_quantityController.text),
          oldQty!,
          _categoryController.text,
          _descriptionController.text,
          isAdded ?? true,
          toUpdateQty ?? 0,
          updatedAt ?? "",
        );
        print(result);
        print(result['isUpdated'].runtimeType);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${result['request']}")));
        if (bool.parse(result['isUpdated'])) {
          setState(() {
            widget.onUpdatedClick(1, true);
          });
          //_clearController();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _deleteProduct() async {
    FocusScope.of(context).unfocus();

    // Show a dialog before deletion
    String productName = this.productName!;
    TextEditingController controller = TextEditingController();

    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Type the product name to confirm:'),
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Product Name'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (controller.text == productName) {
                  Navigator.of(context).pop(true); // Confirm deletion
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Product name does not match. Please type the correct product name.')),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    // Proceed with deletion if confirmed
    if (confirmDelete == true) {
      try {
        var result = await product.deleteProduct(widget.productId);
        print(result);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${result['message']}")));
        if (result['results'][0]['isDeleted']) {
          setState(() {
            widget.onUpdatedClick(1, true);
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  // void _deleteProduct() async {
  //   FocusScope.of(context).unfocus();
  //   try {
  //     var result = await product.deleteProduct(widget.productId);
  //     print(result);
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("${result['message']}")));
  //     if (result['isDeleted']) {
  //       setState(() {
  //         widget.onUpdatedClick(1, true);
  //       });
  //       //_clearController();
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("Error: $e")));
  //   }
  // }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _clearController() {
    setState(() {
      _nameController.text = "";
      _priceController.text = "";
      _quantityController.text = "";
      _categoryController.text = "";
      _descriptionController.text = "";
    });
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
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _quantityController,
                            readOnly: true,
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
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 188, 62, 62),
                              shape: BoxShape.circle),
                          child: IconButton(
                              onPressed: () => showUpdateDialog(
                                  context, "Add quantity", true),
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 188, 62, 62),
                              shape: BoxShape.circle),
                          child: IconButton(
                              onPressed: () => showUpdateDialog(
                                  context, "Remove quantity", false),
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              )),
                        )
                      ],
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
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter the product description';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateProduct,
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
                      onPressed: _deleteProduct,
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

  // * * * Alert when click add or remove * * *
  void showUpdateDialog(BuildContext context, String title, bool toAdd) {
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController updatedAtController = TextEditingController();

    updatedAtController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Function to handle saving the data
    void saveData(bool isAdded) {
      final int quantity = int.tryParse(quantityController.text) ?? 0;
      final String updatedAt = updatedAtController.text;

      setState(() {
        if (isAdded) {
          _quantityController.text = (oldQty! + quantity).toString();
          toUpdateQty = quantity;
          this.isAdded = true;
        } else {
          if (quantity < oldQty!) {
            _quantityController.text = (oldQty! - quantity).toString();
            toUpdateQty = quantity;
            this.isAdded = false;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("can't update less than 0 in quantity.")));
          }
        }
      });
      this.updatedAt = updatedAt;

      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                  ),
                ),
                TextField(
                  controller: updatedAtController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'Updated At',
                    hintText: 'YYYY-MM-DD',
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      updatedAtController.text =
                          "${pickedDate.toLocal()}".split(' ')[0];
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () => saveData(toAdd),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
