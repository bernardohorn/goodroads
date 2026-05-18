import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Exibe imagens remotas com cache (ocorrências, perfil, etc.).
class ImagemRede extends StatelessWidget {
  const ImagemRede({
    super.key,
    required this.url,
    this.largura,
    this.altura,
    this.ajuste = BoxFit.cover,
  });

  final String url;
  final double? largura;
  final double? altura;
  final BoxFit ajuste;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: largura,
      height: altura,
      fit: ajuste,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) =>
          const Icon(Icons.broken_image_outlined),
    );
  }
}
