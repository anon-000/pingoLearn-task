import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_task/api_services/api_client.dart';
import 'package:flutter_task/config/api_routes.dart';
import 'package:flutter_task/data_models/product_model.dart';
import 'package:flutter_task/services/remote_config_service.dart';

///
/// Created by Auro on 29/07/24
///

class ProductProvider with ChangeNotifier {
  final RemoteConfigService _remoteConfigService;

  int skip = 0, limit = 20, total = 0;
  bool shouldLoadMore = true;

  List<ProductModel> _products = [];
  bool _isLoading = false, _loadingMore = false;
  String _error = '';

  ProductProvider(this._remoteConfigService);

  List<ProductModel> get products => _products;

  bool get isLoading => _isLoading;

  bool get isLoadingMore => _loadingMore;

  String get error => _error;

  bool get showDiscountedPrice => _remoteConfigService.showDiscountedPrice;

  Future<void> _fetchRemoteConfig() async {
    // final RemoteConfig remoteConfig = await RemoteConfig.instance;
    // await remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    // await remoteConfig.fetchAndActivate();
    //
    // final bool showDiscountedPrice =
    //     remoteConfig.getBoolean('show_discounted_price');
  }

  void getData() async {
    skip = 0;
    shouldLoadMore = true;
    try {
      _isLoading = true;
      notifyListeners();
      final result = await ApiClient.get(
        ApiRoutes.products,
        query: {
          '\$skip': skip,
          '\$limit': limit,
        },
      );
      log("$result");

      final response = List<ProductModel>.from(
          result.data["products"].map((e) => ProductModel.fromJson(e)));

      if (response.length < limit) {
        shouldLoadMore = false;
      }

      _products = response;
      _isLoading = false;
      notifyListeners();
    } catch (e, s) {
      log("$e $s");
      _error = "$e";
      _isLoading = false;
      notifyListeners();
    }
  }

  void getMoreData() async {
    if (shouldLoadMore && !_loadingMore) {
      log("Loading More.....");
      skip = _products.length;
      try {
        _loadingMore = true;
        notifyListeners();

        final result = await ApiClient.get(
          ApiRoutes.products,
          query: {
            '\$skip': skip,
            '\$limit': limit,
          },
        );
        log("$result");
        final response = List<ProductModel>.from(
            result.data["products"].map((e) => ProductModel.fromJson(e)));
        if (response.length < limit) {
          shouldLoadMore = false;
        }

        _products = response + _products;
        _loadingMore = false;
        notifyListeners();
      } catch (e) {
        log("$e");
        // _error = "$e";
        _loadingMore = false;
        notifyListeners();
      }
    }
  }
}
