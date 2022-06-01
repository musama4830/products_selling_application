import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductsScreen extends StatelessWidget {
  static const routeName = '/products_screen';

  @override
  Widget build(BuildContext context) {
    List<Product> _productsList = Provider.of<Products>(context).items;
    return ListView.builder(
      itemCount: _productsList.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.only(left: 16, top: 10, right: 16),
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GridTile(
              child: GestureDetector(
                  onTap: () {},
                    child: Image.file(
                      File(_productsList[index].image[0].path),
                      fit: BoxFit.cover,
                    ),
                  ),
              footer: GridTileBar(
                backgroundColor: Colors.black87.withOpacity(0.7),
                title: Text(
                  _productsList[index].title,
                ),
                subtitle: Text(
                  '\$${_productsList[index].price}',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
