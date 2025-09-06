import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../routes/app_routes.dart';

class SuggestedProductsWidget extends StatelessWidget {
  const SuggestedProductsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final suggestedProducts = [
      SuggestedProduct(
        id: 'sp1',
        name: 'iPhone 15 Case',
        price: 29.99,
        imageUrl:
            'https://images.unsplash.com/photo-1601593346740-925612772716?w=400',
        originalPrice: 39.99,
      ),
      SuggestedProduct(
        id: 'sp2',
        name: 'Wireless Charging Pad',
        price: 19.99,
        imageUrl:
            'https://images.unsplash.com/photo-1609592067157-b9a9e2b98d57?w=400',
      ),
      SuggestedProduct(
        id: 'sp3',
        name: 'USB-C Cable',
        price: 12.99,
        imageUrl:
            'https://images.unsplash.com/photo-1585792180666-f7347c490ee2?w=400',
      ),
      SuggestedProduct(
        id: 'sp4',
        name: 'Screen Protector',
        price: 15.99,
        imageUrl:
            'https://images.unsplash.com/photo-1617864820495-bfd68a9f6d10?w=400',
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'You might also like',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: suggestedProducts.length,
              itemBuilder: (context, index) {
                final product = suggestedProducts[index];
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.productDetail,
                          arguments: {'productId': product.id},
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: product.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    child: const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    child:
                                        const Icon(Icons.image_not_supported),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                                if (product.originalPrice != null) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    '\$${product.originalPrice!.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('${product.name} added to cart'),
                                      action: SnackBarAction(
                                        label: 'View Cart',
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/shopping-cart');
                                        },
                                      ),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Add'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SuggestedProduct {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final double? originalPrice;

  const SuggestedProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.originalPrice,
  });
}
