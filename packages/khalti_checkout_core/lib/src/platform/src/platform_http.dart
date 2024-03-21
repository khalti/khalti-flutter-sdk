// Copyright (c) 2024 The Khalti Authors. All rights reserved.

/// The web implementation of [Platform].
abstract class Platform {
  /// A string representing the operating system or platform.
  static String get operatingSystem => 'web';

  /// Whether the operating system is a version of
  /// [Linux](https://en.wikipedia.org/wiki/Linux).
  ///
  /// This value is `false` if the operating system is a specialized
  /// version of Linux that identifies itself by a different name,
  /// for example Android (see [isAndroid]).
  static bool get isLinux => false;

  /// Whether the operating system is a version of
  /// [macOS](https://en.wikipedia.org/wiki/MacOS).
  static bool get isMacOS => false;

  /// Whether the operating system is a version of
  /// [Microsoft Windows](https://en.wikipedia.org/wiki/Microsoft_Windows).
  static bool get isWindows => false;

  /// Whether the operating system is a version of
  /// [Android](https://en.wikipedia.org/wiki/Android_%28operating_system%29).
  static bool get isAndroid => false;

  /// Whether the operating system is a version of
  /// [iOS](https://en.wikipedia.org/wiki/IOS).
  static bool get isIOS => false;

  /// Whether the operating system is a version of
  /// [Fuchsia](https://en.wikipedia.org/wiki/Google_Fuchsia).
  static bool get isFuchsia => false;
}

/// Exception through by underlying http client.
abstract class HttpException implements Exception {
  /// Creates a [HttpException] with the provided value.
  const HttpException(this.message, {this.uri});

  /// Description of the error.
  final String message;

  /// The location [uri] of the error.
  final Uri? uri;
}

/// Exception thrown when a socket operation fails.
abstract class SocketException implements Exception {
  /// Creates a [SocketException] with the provided values.
  const SocketException(this.message, {this.osError, this.port});

  /// Creates an exception reporting that a socket was used after it was closed.
  const SocketException.closed()
      : message = 'Socket has been closed',
        osError = null,
        port = null;

  /// Description of the error.
  final String message;

  /// The underlying OS error.
  ///
  /// If this exception is not thrown due to an OS error, the value is `null`.
  final OSError? osError;

  /// The port of the socket giving rise to the exception.
  ///
  /// This is either the source or destination address of a socket,
  /// or it can be `null` if no socket end-point was involved in the cause of
  /// the exception.
  final int? port;
}

/// The OS Error.
abstract class OSError {
  /// Creates an OSError object from a message and an errorCode.
  const OSError([this.message = "", this.errorCode = noErrorCode]);

  /// Error message supplied by the operating system. This will be empty if no
  /// message is associated with the error.
  final String message;

  /// Error code supplied by the operating system.
  ///
  /// Will have the value [OSError.noErrorCode] if there is no error code
  /// associated with the error.
  final int errorCode;

  /// Constant used to indicate that no OS error code is available.
  static const int noErrorCode = -1;
}
