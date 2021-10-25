import 'package:flutter/material.dart';
import 'package:khalti_flutter/src/helper/error_info.dart';
import 'package:khalti_flutter/src/widget/image.dart';
import 'package:khalti_flutter/src/widget/khalti_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

Future<void> showProgressDialog(
  BuildContext context, {
  required String message,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Color(0xFF474747)), //s400
        child: Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: KhaltiProgressIndicator()),
                const SizedBox(height: 16),
                Text(message, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showErrorDialog(
  BuildContext context, {
  required Object error,
  required VoidCallback onPressed,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      final errorInfo = ErrorInfo.from(error);

      return _Dialog(
        assetName: 'dialog/error.svg',
        titleText: errorInfo.primary,
        subtitle: errorInfo.secondary == null
            ? null
            : _ErrorBodyWidget(message: errorInfo.secondary!),
        onPressed: onPressed,
      );
    },
  );
}

Future<void> showSuccessDialog(
  BuildContext context, {
  required String title,
  required String subtitle,
  required VoidCallback onPressed,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return _Dialog(
        assetName: 'dialog/success.svg',
        titleText: title,
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: Color(0xFF474747),
                height: 1.5,
              ),
        ),
        onPressed: onPressed,
      );
    },
  );
}

class _Dialog extends StatelessWidget {
  const _Dialog({
    Key? key,
    required this.assetName,
    required this.titleText,
    required this.subtitle,
    required this.onPressed,
  }) : super(key: key);

  final String assetName;
  final String titleText;
  final Widget? subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    KhaltiImage.asset(asset: assetName, height: 72),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        titleText,
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (subtitle != null) subtitle!,
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 8, bottom: 2),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Color(0xFF5C2D91),
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('OK'),
                  onPressed: onPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBodyWidget extends StatelessWidget {
  const _ErrorBodyWidget({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(color: Color(0xFF474747));

    final regex = RegExp(r"(.+)?<a.*href='(.+)' .*>(.+)</a>(.+)?");

    if (regex.hasMatch(message)) {
      final match = regex.firstMatch(message);
      if (match!.groupCount == 4) {
        final leadingText = match.group(1);
        final trailingText = match.group(4);
        final link = match.group(2);
        final anchorText = match.group(3);

        return Text.rich(
          TextSpan(
            text: leadingText ?? '',
            children: [
              WidgetSpan(
                child: InkWell(
                  onTap: () {
                    if (link != null) launcher.launch(link);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      anchorText ?? '',
                      style: TextStyle(
                        height: 1.4,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              if (trailingText != null) TextSpan(text: trailingText),
            ],
            style: textStyle.copyWith(height: 1.5),
          ),
        );
      }
    }

    return Text(message, style: textStyle);
  }
}
