import 'package:flutter/material.dart';
import 'package:flutter_task/data_models/product_model.dart';
import 'package:flutter_task/pages/auth/login_page.dart';
import 'package:flutter_task/pages/home/widgets/product_card.dart';
import 'package:flutter_task/providers/auth_provider.dart';
import 'package:flutter_task/widgets/dialogs/alert_dialog.dart';
import 'package:flutter_task/widgets/shimmers/product_grid_shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';

///
/// Created by Auro on 28/07/24
///

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();

  GoRouter get router => GoRouter.of(context);

  ProductProvider get prodProvider =>
      Provider.of<ProductProvider>(context, listen: false);

  List<ProductModel> get products => prodProvider.products;

  _getData() {
    Future.microtask(() => prodProvider.getData());
  }

  @override
  void initState() {
    super.initState();
    _getData();
    scrollController.addListener(() {
      final maxGeneralScroll = scrollController.position.maxScrollExtent;
      final currentGeneralScroll = scrollController.position.pixels;
      if (maxGeneralScroll <= currentGeneralScroll) {
        prodProvider.getMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('e-Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              showAppAlertDialog(
                      context: context,
                      title: "Are you sure you want to Log out?")
                  .then(
                (c) async {
                  if (c != null && c) {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .signOut();
                    router.pushReplacementNamed(LoginPage.routeName);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: productProvider.isLoading
          ? const ProductGridShimmer()
          : productProvider.error.isNotEmpty
              ? Center(child: Text(productProvider.error))
              : RefreshIndicator(
                  onRefresh: () async {
                    _getData();
                  },
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 70),
                    itemBuilder: (c, i) {
                      if (i >= products.length) {
                        return const ProductCardShimmer();
                      }
                      return ProductCard(
                        products[i],
                        showDiscountedPrice:
                            productProvider.showDiscountedPrice,
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: productProvider.isLoadingMore
                        ? products.length + 1
                        : products.length,
                  ),
                ),
    );
  }
}
