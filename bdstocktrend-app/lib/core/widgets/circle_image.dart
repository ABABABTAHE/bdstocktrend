import 'package:bd_stock_trend/core/core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleImage extends StatelessWidget {
  final String url;
  final double? size;

  const CircleImage({super.key, required this.url, this.size});

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size ?? Dimens.space46;
    final trimmed = url.trim();

    if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') {
      return _placeholder(resolvedSize);
    }

    if (trimmed.startsWith('data:')) {
      return _placeholder(resolvedSize);
    }

    if (trimmed.toLowerCase().endsWith('.svg')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(360),
        child: SizedBox(
          width: resolvedSize,
          height: resolvedSize,
          child: SvgPicture.network(
            trimmed,
            fit: BoxFit.cover,
            placeholderBuilder: (_) => SizedBox(
              width: resolvedSize,
              height: resolvedSize,
              child: const Loading(showMessage: false),
            ),
            errorBuilder: (context, error, stackTrace) =>
                _placeholder(resolvedSize),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(360),

      /// 360 degree circle
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        width: resolvedSize,
        height: resolvedSize,
        fadeInDuration: const Duration(milliseconds: 300),
        imageUrl: trimmed,
        placeholder: (context, url) => SizedBox(
          width: resolvedSize,
          height: resolvedSize,
          child: const Loading(showMessage: false),
        ),
        errorWidget: (context, url, error) => _placeholder(resolvedSize),
      ),
    );
  }

  Widget _placeholder(double size) {
    return Container(
      width: size,
      height: size,
      color: Palette.background,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_rounded,
        color: Palette.subText.withOpacity(0.5),
        size: size * 0.5,
      ),
    );
  }
}
