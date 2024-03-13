import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
export 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    show InternetStatus;

/// Helper getter to retrieve [ConnectivityUtil] instance.
ConnectivityUtil get connectivityUtil => ConnectivityUtil();

/// A helper class to check internet connection availability.
class ConnectivityUtil {
  /// Constructor for [ConnectivityUtil].
  ConnectivityUtil()
      : _connectivity = InternetConnection.createInstance(
          checkInterval: const Duration(seconds: 1),
        );

  final InternetConnection _connectivity;

  /// A stream that yields the status of internet connection that can be listened to.
  Stream<InternetStatus> get internetConnectionListenableStatus {
    return _connectivity.onStatusChange;
  }
}
