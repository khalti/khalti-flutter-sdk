<p align="center">
<img src="https://raw.githubusercontent.com/khalti/khalti-flutter-sdk/master/assets/khalti_logo.png" height="100" alt="Khalti Payment Gateway" />
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

Use Khalti Payment Gateway solution in your app or website to simplify payment for your customers. 
You do not need to integrate with individual banks when using Khalti Payment Gateway.

With Khalti SDK/API, you can accepts payments from:

1. Khalti Users
2. eBanking users of our partner banks
3. Mobile banking users of our partner banks
4. SCT/VISA card Holders
5. connectIPS Users

## Payment Solutions

The repository hosts three packages:

Payment Solutions             | Package Name    | Version                                                                                                                | Description                                                      | Use Case
---------------------------   | -------------   | ---------------------------------------------------------------------------------------------------------------------  | --------------------------------------------------------------   | --------------------------------------------------------------------------------------
Payment API only              | khalti_core     | [![khalti_core](https://img.shields.io/pub/v/khalti_core.svg)](https://pub.dartlang.org/packages/khalti_core)          | Low level abstraction over Khalti REST API                       | for Dart only project & using custom dependencies. e.g. using `dio` instead of `http`
SDK without UI                | khalti          | [![khalti](https://img.shields.io/pub/v/khalti.svg)](https://pub.dartlang.org/packages/khalti)                         | Wrapper around `khalti_core`, which includes easy-to-use methods | for Flutter project, where a custom user interface is required
Quick Integration SDK with UI | khalti_flutter  | [![khalti_flutter](https://img.shields.io/pub/v/khalti_flutter.svg)](https://pub.dartlang.org/packages/khalti_flutter) | Similar to `khalti`, but includes user interface                 | Recommended one, a plug-and-play solution with limited customization


## Features

* Highly secure and easy Integrations
* SDKs available for Web (JavaScript), Android and iOS
* Payments by customers without leaving your platform
* Secured transactions using 2-step authentication i.e Khalti Password and Khalti Pin (4 digit pin in Khalti App also used for Khalti App and transaction lock)
* Transaction processing is disabled on multiple requests for the wrong Khalti Pin
* Multi-user Merchant Dashboard to view transactions, issue refunds, filter and download reports etc.
* Realtime payment updates in Merchant Dashboard
* Amount transfer feature to banks from Merchant Dashboards anytime
* Multiple Payment Options for Customers


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