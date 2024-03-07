import 'package:internet_connection_checker/internet_connection_checker.dart';

export 'package:internet_connection_checker/internet_connection_checker.dart'
    show InternetConnectionStatus;

/// Helper getter to retrieve [ConnectivityUtil] instance.
ConnectivityUtil get connectivityUtil => ConnectivityUtil();

/// A helper class to check internet connection availability.
class ConnectivityUtil {
  /// Constructor for [ConnectivityUtil].
  ConnectivityUtil()
      : _connectivity = InternetConnectionChecker.createInstance(
          checkInterval: const Duration(seconds: 1),
        );

  final InternetConnectionChecker _connectivity;

  /// A stream that yields the status of internet connection that can be listened to.
  Stream<InternetConnectionStatus> get internetConnectionListenableStatus {
    return _connectivity.onStatusChange;
  }
}
