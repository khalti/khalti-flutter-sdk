import 'package:flutter/material.dart';
import 'package:khalti_flutter/src/widget/image.dart';

class KhaltiBankTile extends StatelessWidget {
  const KhaltiBankTile({
    Key? key,
    required this.logoUrl,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final String logoUrl;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox.square(
        dimension: 32,
        child: KhaltiImage.network(url: logoUrl),
      ),
      minLeadingWidth: 0,
      title: Text(
        name,
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onTap: onTap,
    );
  }
}
