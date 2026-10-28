import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:take_home_test/domain/entities/entities.dart';

class AliasListItemWidget extends StatelessWidget {
  const AliasListItemWidget({super.key, required this.alias});

  final AliasEntity alias;

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: alias.shortUrl));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Short URL copied!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _copyToClipboard(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            alias.shortUrl,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            alias.originalUrl,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
