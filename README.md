# Khalti Payment Gateway

Khalti is a payment gateway, digital wallet and API provider system for
various online services for Nepal.

With Khalti SDK/API, you can accepts payments from:

1. Khalti users.
2. eBanking users of our partner banks.
3. Mobile banking users of our mobile banking partner banks.
4. SCT/VISA card holders.
5. connectIPS users.

Using Khalti Payment Gateway, you do not need to integrate with individual banks.

## Packages

The repository hosts three packages:

Package Name    | Version                                                                                                                | Description                                                      | Use Case
-------------   | ---------------------------------------------------------------------------------------------------------------------  | --------------------------------------------------------------   | --------------------------------------------------------------------------------------
khalti_core     | [![khalti_core](https://img.shields.io/pub/v/khalti_core.svg)](https://pub.dartlang.org/packages/khalti_core)          | Low level abstraction over Khalti REST API                       | for Dart only project & using custom dependencies. e.g. using `dio` instead of `http`
khalti          | [![khalti](https://img.shields.io/pub/v/khalti.svg)](https://pub.dartlang.org/packages/khalti)                         | Wrapper around `khalti_core`, which includes easy-to-use methods | for Flutter project, where a custom user interface is required
khalti_flutter  | [![khalti_flutter](https://img.shields.io/pub/v/khalti_flutter.svg)](https://pub.dartlang.org/packages/khalti_flutter) | Similar to `khalti`, but includes user interface                 | Recommended one, a plug-and-play solution with limited customization


## Features

* Multiple Payment Options for Customers
* Highly secure and Easy Integrations
* SDKs are available for Web (JavaScript), Android and iOS.
* Customers can make wallet payments without leaving your
  platform.
* Secured Transaction uses 2 step authentication i.e Khalti Pin and Khalti Password.
  Transaction Processing is disabled on multiple request for wrong Khalti Pin.
* Merchant Dashboard to view transactions, issue refunds, filter and download reports etc.
* Multi User System
* Realtime Balance updates in Merchant Dashboard on every successful payments made by customers
* Amount collected in Merchant Dashboard can we deposited/transferred to bank accounts anytime

## Support
** For Queries, feel free to call us at: **

* Mobile (Viber / Whatsapp / Skype): 9801165565, 9801052293

* Email: merchant@khalti.com

### [Getting Started](https://docs.khalti.com/getting-started/)