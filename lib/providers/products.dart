import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class Product {
  List<XFile> image;
  String id;
  String title;
  int price;
  String category;
  String description;

  Product({
    required this.image,
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
  });
}

class Products with ChangeNotifier {
  String token;
 
  List<Product> _items = [];

  Products(this.token, this._items);

  CollectionReference fbProduct = FirebaseFirestore.instance.collection('listings');

  List<Product> get items {

    return [..._items];
  }

  final List<String> _categoryList = [
    'All',
    'Books',
    'Cameras',
    'Cars',
    'Clothes',
    'Furniture',
    'Sports',
    'Other'
  ];
  get categoryList {
    return [..._categoryList];
  }

  void addProduct(Product product) {

    final newProduct = Product(
      image: product.image,
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      category: product.category,
    );
    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('Product data not updated...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
