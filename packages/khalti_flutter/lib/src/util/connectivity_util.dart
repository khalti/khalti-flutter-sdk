import 'package:internet_connection_checker/internet_connection_checker.dart';

/// The [ConnectivityUtil] instance.
ConnectivityUtil get connectivityUtil => ConnectivityUtil();

/// A helper class to check internet connection availability.
class ConnectivityUtil {
  /// Constructor for [ConnectivityUtil].
  ConnectivityUtil({InternetConnectionChecker? connectivity})
      : _connectivity = connectivity ?? InternetConnectionChecker();

  final InternetConnectionChecker _connectivity;

  /// Returns true if device is connected to any network.
  Future<bool> get hasInternetConnection => _connectivity.hasConnection;
}
