import 'package:flutter/material.dart';

///
/// Created by Auro on 28/07/24
///

class ProductsPage extends StatefulWidget {
  static const routeName = '/products';

  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Products"),
      ),
    );
  }
}
