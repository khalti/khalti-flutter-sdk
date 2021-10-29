<p align="center">
<img src="https://raw.githubusercontent.com/khalti/khalti-flutter-sdk/master/assets/khalti_logo.png" height="150" alt="Khalti Payment Gateway" />
</p>

<p align="center">
<strong>Khalti Payment Gateway for Flutter</strong>
</p>

<p align="center">
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