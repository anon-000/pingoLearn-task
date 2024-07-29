import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

///
/// Created by Auro on 29/07/24
///

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 1),
    ));
    await _remoteConfig.fetchAndActivate();
    log(">>REMOTE CONFIG: ${_remoteConfig.getAll()['show_discounted_price']!.asBool()}");
  }

  bool get showDiscountedPrice =>
      _remoteConfig.getBool('show_discounted_price');
}
