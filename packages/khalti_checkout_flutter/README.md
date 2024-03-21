<p align="center">
<img src="https://raw.githubusercontent.com/khalti/khalti-flutter-sdk/master/assets/khalti_logo.png" height="100" alt="Khalti Payment Gateway" />
</p>

<p align="center">
<strong>Khalti Payment Gateway for Flutter</strong>
</p>

<p align="center">
<a href="https://pub.dartlang.org/packages/khalti_flutter"><img src="https://img.shields.io/pub/v/khalti_flutter.svg" alt="Pub"></a>
<a href="https://docs.khalti.com/"><img src="https://img.shields.io/badge/Khalti-Docs-blueviolet" alt="Khalti Docs"></a>
<a href="https://github.com/khalti/khalti-flutter-sdk/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-BSD--3-informational" alt="BSD-3 License"></a>
<a href="https://github.com/khalti/khalti-flutter-sdk/issues"><img src="https://img.shields.io/github/issues/khalti/khalti-flutter-sdk" alt="GitHub issues"></a>
<a href="https://khalti.com"><img src="https://img.shields.io/website?url=https%3A%2F%2Fdocs.khalti.com" alt="Website"></a>
<a href="https://www.facebook.com/khalti.official"><img src="https://img.shields.io/badge/follow--000?style=social&logo=facebook" alt="Follow Khalti in Facebook"></a>
<a href="https://www.instagram.com/khaltiofficial"><img src="https://img.shields.io/badge/follow--000?style=social&logo=instagram" alt="Follow Khalti in Instagram"></a>
<a href="https://twitter.com/intent/follow?screen_name=khaltiofficial"><img src="https://img.shields.io/twitter/follow/khaltiofficial?style=social" alt="Follow Khalti in Twitter"></a>
<a href="https://www.youtube.com/channel/UCrXM4HqK9th3E2a04Z9Lh-Q"><img src="https://img.shields.io/youtube/channel/subscribers/UCrXM4HqK9th3E2a04Z9Lh-Q?label=Subscribe&style=social" alt="Subscribe Youtube Channel"></a>
</p>

---

Khalti is a payment gateway, digital wallet and API provider system for various online services for Nepal.

With this package, you can accepts payments from:
- Khalti users.
- eBanking users of our partner banks.
- Mobile banking users of our mobile banking partner banks.
- SCT/VISA card holders.
- connectIPS users.

Using Khalti Payment Gateway, you do not need to integrate with individual banks.

- [Introduction](#introduction)
- [Getting Started](#getting-started)
- [Supported Platforms](#supported-platforms)
- [Setup](#setup)
  - [Android](#android)
  - [iOS](#ios)
  - [Web](#web)
- [Launching Payment Interface](#launching-payment-interface)
  - [Generating the pidx](#generating-the-pidx)
  - [Khalti Initialization](#khalti-initialization)
  - [Loading payment interface](#loading-payment-interface)
- [Payment verification API](#payment-verification-api)
- [Closing the Khalti payment gateway page](#closing-the-khalti-payment-gateway-page)
- [Example](#example)
- [Contributing](#contributing)
- [Support](#support)
- [License](#license)


# Introduction
Read the introduction [here](https://docs.khalti.com/).

# Getting Started
Integrating Khalti Payment Gateway requires merchant account. 
You can always [create one easily from here](https://khalti.com/join/merchant/#/).

Read the steps to integrate Khalti Payment Gateway in details [here](https://docs.khalti.com/getting-started/).

# Supported Platforms
Android | iOS | Web | Desktop (macOS, Linux, Windows)
:-----: | :-: | :-: | :-----------------------------:
  ✔️    |  ✔️ |  ✔️ |                ❌

# Setup
Detailed setup for each platform.

## Android
No configuration is required for android.

## iOS
No configuration is required for iOS.

## Web
Since, the SDK uses [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview) internally to load the payment gateway, check its doc for the necessary web setup.

# Launching Payment Interface

## Generating the pidx
A unique product identifier `pidx` must be generated via a server side POST request before being able to proceed. Read [here](https://docs.khalti.com/khalti-epayment/#initiating-a-payment-request) for information on how one can generate pidx along with other extra parameters.

## Khalti Initialization
Before being able to launch Khalti payment gateway, it is necessary to initialize `Khalti` object. The initialization can be done by a static `init()` method.

It is suggested that the initialization be done inside the `initState` method of a `StatefulWidget`.

```dart
class KhaltiSDKDemo extends StatefulWidget {
  const KhaltiSDKDemo({super.key});

  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  late final Future<Khalti> khalti;

  @override
  void initState() {
    super.initState();
    final payConfig = KhaltiPayConfig(
      publicKey: '__live_public_key__', // Merchant's public key
      pidx: pidx, // This should be generated via a server side POST request.
      returnUrl: Uri.parse('https://your_return_url'),
      environment: Environment.prod,
    );

    khalti = Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult, khalti) {
        log(paymentResult.toString());
      },
      onMessage: (
        khalti, {
        description,
        statusCode,
        event,
        needsPaymentConfirmation,
      }) async {
        log(
          'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
        );
      },
      onReturn: () => log('Successfully redirected to return_url.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Rest of the code
  }
}
```

The static `init()` method takes in a few arguments:

- **enableDebugging**: A boolean argument that is when set to true can be used to view network logs in the debug console. It is set to `false` by default.
- **payConfig**: An instance of `KhaltiPayConfig()`. It is used to set few config data. The instance of `KhaltiPayConfig` takes in few arguments:

  ```dart
  final payConfig = KhaltiPayConfig(
    publicKey: '__live_public_key__', // Merchant's public key
    pidx: pidx, // This should be generated via a server side POST request.
    returnUrl: Uri.parse('https://your_return_url'),
    environment: Environment.prod,
  );
  ```
  - **publicKey**: Merchant's live or test public key provided by Khalti.
  - **pidx**: Unique product identifier received after initiating the payment via a server-side POST request.
  - **returnUrl**: Merchant's URL where the user must be redirected after the payment is (un)successfully made.
  - **environment**: An enum that determines whether test API or production API should be invoked. Can be either `Environment.prod` or `Environment.test`. Set to `Environment.prod` by default.
- **onPaymentResult**: A callback function that is triggered if the payment is successfully made and redirected to merchant's return URL. The callback takes in two arguments.
  - **paymentResult**: An instance of `PaymentResult` class. It provides some informations about the payment after it is successfully made. Following data is provided by this instance.
    - **status**: A string representing the status of the payment.
    - **payload**: An instance of `PaymentPayload`. It contains general informations such as `pidx`, `amount` and `transactionId` regarding the payment made. 
  - **khalti**: An instance of `Khalti`. Can be used to invoke any methods provided by this instance.

  ```dart
  onPaymentResult(paymentResult, khalti) {
    print(paymentResult.status);
    print(paymentResult.payload.pidx);
    print(paymentResult.payload.amount);
    print(paymentResult.payload.transactionId);
  }
  ```
  
- **onReturn**: A callback function that gets triggered when the retunr_url is successfully loaded.

- **onMessage**: A callback function that is triggered if any error is encountered. This callback provides error informations such as error description and status code. It also provides information about why the error occured via `KhaltiEvent` enum. This enum consists of:
  
  ```dart
  enum KhaltiEvent {
    /// Event for when khalti payment page is disposed.
    kpgDisposed,

    /// Event for when return url fails to load.
    returnUrlLoadFailure,

    /// Event for when there's an exception when making a network call.
    networkFailure,

    /// Event for when there's a HTTP failure when making a network call.
    paymentLookupfailure,

    /// An unknown event.
    unknown
  }
  ```
  Additionally, it also provides a bool `needsPaymentConfirmation` which needs to be checked. If it is true, developers should invoke payment confirmation API that is provided by the SDK to confirm the status of their payment. The callback also provides the instance of `Khalti`.

  ```dart
  onMessage: (
    khalti, {
    description,
    statusCode,
    event,
    needsPaymentConfirmation,
  }) {
    log('Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation');
  }
  ```

## Loading payment interface
The SDK internally uses [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview) to load the khalti payment gateway. SDK users should invoke `open()` method provided by the SDK to push a new page in their route.

```dart
khalti.open(context); // Assuming that khalti is a variable that holds the instance of `Khalti`.
```

# Payment verification API
A payment verification API that confirms the status of the payment made, is already called by the SDK internally. However, if the users receive `needsPaymentConfirmation` as true in `onMessage` callback, they are supposed to called the payment verification API manually to be sure about the payment status. It can be done with a method provided by the `Khalti` instance.

```dart
await khalti.verify(); // Assuming that khalti is a variable that holds the instance of `Khalti`.
```

The instance of `Khalti` is provided in the `onPaymentResult` and `onMessage` callback which can be used to invoke any public functions provide by `Khalti` class.

# Closing the Khalti payment gateway page
After payment is successfully made, developers can opt to pop the page that was pushed in their route. The SDK provides a `close()` method.

```dart
khalti.close(context);
```

# Example
For a more detailed example, check the [examples](./example/) directory inside `khalti_flutter` package.

# Contributing
Contributions are always welcome. Also, if you have any confusion, please feel free to create an issue.
   
# Support
**For Queries, feel free to call us at:**

_**Contact Our Merchant Team**_
* Mobile (Viber / Whatsapp): 9801165567, 9801165538
* Email: merchant@khalti.com

(To integrate Khalti to your business and other online platforms.)

_**Contact Our Merchant Support**_
* Mobile (Viber / Whatsapp): 9801165565, 9801856383, 9801856451
* Email: merchantcare@khalti.com

_**Contact Our Technical Team**_
* Mobile (Viber / Whatsapp): 9843007232
* Email / Skype: sashant@khalti.com

(For payment gateway integration support.)
   
# License
```
Copyright (c) 2024 The Khalti Authors. All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of Sparrow Pay Pvt. Ltd. nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
