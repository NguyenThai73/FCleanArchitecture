import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // Có thể sử dụng package connectivity_plus để check network
    // Hiện tại return true cho đơn giản
    return true;
  }
}
