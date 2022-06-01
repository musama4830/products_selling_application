import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/add_product_screen';

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String _productId = 'null';
  String dropdownvalue = 'Category';
  List<XFile> _image = [];
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    image: [],
    id: '',
    title: '',
    price: 0,
    description: '',
    category: '',
  );
  var _initValues = {
    'image': [],
    'title': '',
    'price': 0,
    'description': '',
    'category': '',
  };
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // _productId = ModalRoute.of(context)!.settings.arguments;
      // if (_productId != 'null') {
      //   _editedProduct =
      //       Provider.of<Products>(context, listen: false).findById(_productId);
      //   _initValues = {
      //     'id': _editedProduct.id,
      //     'title': _editedProduct.title,
      //     'totalQuantity': _editedProduct.totalQuantity.toString(),
      //     'purchasePrice': _editedProduct.purchasePrice.toString(),
      //     'salePrice': _editedProduct.salePrice.toString(),
      //   };
      // }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _updateImage() {
    setState(() {
      _editedProduct.image = _image;
      _editedProduct.id = DateTime.now().toString();
    });
    print(_editedProduct.image.length);
    print(_editedProduct.id);
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _updateImage();
    _form.currentState!.save();
    await Future.delayed(const Duration(milliseconds: 100), () {
      if (_productId != 'null') {
      } else {
        Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      }
    });
    Navigator.of(context).pop();
  }

  _getFromGallery() async {
    final List<XFile>? pickedFile = await ImagePicker().pickMultiImage();
    if (pickedFile != null) {
      _image.addAll(pickedFile);
    }
    setState(() {});
    // Navigator.of(context).pop();
  }

  viewWidget() {
    // setState(() {});
    return Row(
      children: [
        if (_image.isNotEmpty) ...{
          Container(
            width: 95 * double.parse(_image.length.toString()),
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).primaryColor,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _image.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 90,
                  width: 90,
                  margin: const EdgeInsets.only(right: 5),
                  child: Image.file(
                    File(_image[index].path),
                    fit: BoxFit.cover,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).backgroundColor.withOpacity(0.1),
                  ),
                );
              },
            ),
          ),
        },
        if (_image.length < 3) ...{
          buttonWidget(),
        },
      ],
    );
  }

  buttonWidget() {
    return Container(
      height: 90,
      width: 90,
      child: IconButton(
        icon: const Icon(Icons.photo),
        onPressed: _getFromGallery,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).backgroundColor.withOpacity(0.1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> _categories = Provider.of<Products>(context).categoryList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: const Text(
          'Add New Listing',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _form,
              child: Expanded(
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      // initialValue: _initValues['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a title.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          image: _editedProduct.image,
                          id: _editedProduct.id,
                          title: value.toString(),
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          category: _editedProduct.category,
                        );
                      },
                    ),
                    TextFormField(
                      // initialValue: _initValues['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid price.';
                        }
                        if (int.parse(value) <= 0) {
                          return 'Please enter a price greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          image: _editedProduct.image,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: int.parse(value.toString()),
                          description: _editedProduct.description,
                          category: _editedProduct.category,
                        );
                      },
                    ),
                    TextFormField(
                      // initialValue: _initValues['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Please enter a valid description.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          image: _editedProduct.image,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value.toString(),
                          category: _editedProduct.category,
                        );
                      },
                    ),
                    // TextFormField(
                    //   // initialValue: _initValues['category'],
                    //   decoration: const InputDecoration(labelText: 'Category'),
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Please enter a category.';
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (value) {
                    //     _editedProduct = Product(
                    //       image: _editedProduct.image,
                    //       id: _editedProduct.id,
                    //       title: _editedProduct.title,
                    //       price: _editedProduct.price,
                    //       description: _editedProduct.description,
                    //       category: value.toString(),
                    //     );
                    //   },
                    // ),
                    const SizedBox(height: 10),
                    DropdownButton(
                      hint: Text(dropdownvalue),
                      icon: Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.65),
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                      items: _categories.map((String data) {
                        return DropdownMenuItem(
                          value: data,
                          child: Text(data),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownvalue = value as String;
                        });
                        _editedProduct = Product(
                          image: _editedProduct.image,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          category: value.toString(),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    viewWidget(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: const Text('Post Listing'),
                      onPressed: _saveForm,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
