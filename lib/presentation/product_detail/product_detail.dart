import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/utils/currency_formatter.dart';
import './widgets/add_to_cart_bottom_sheet.dart';
import './widgets/customer_reviews_content.dart';
import './widgets/expandable_section.dart';
import './widgets/product_image_gallery.dart';
import './widgets/product_info_section.dart';
import './widgets/product_variants_section.dart';
import './widgets/quantity_selector.dart';
import './widgets/related_products_section.dart';
import './widgets/specifications_content.dart';

class ProductDetail extends StatefulWidget {
  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool _isWishlisted = false;
  int _selectedQuantity = 1;
  String _selectedColorId = '';
  String _selectedStorageId = '';
  bool _showScanner = false;
  MobileScannerController? _scannerController;

  // Mock product data
  final Map<String, dynamic> _productData = {
    "id": "1",
    "name":
        "iPhone 15 Pro Max - Latest Flagship Smartphone with Advanced Camera System",
    "originalPrice": 180000.00,
    "discountPrice": 165000.00,
    "inStock": true,
    "rating": 4.8,
    "reviewCount": 2847,
    "maxQuantity": 5,
    "images": [
      "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "https://images.unsplash.com/photo-1580910051074-3eb694886505?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "https://images.unsplash.com/photo-1556656793-08538906a9f8?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3"
    ],
    "colors": [
      {"id": "1", "name": "Natural Titanium"},
      {"id": "2", "name": "Blue Titanium"},
      {"id": "3", "name": "White Titanium"},
      {"id": "4", "name": "Black Titanium"}
    ],
    "storage": [
      {"id": "1", "size": "256GB", "priceExtra": 0.0},
      {"id": "2", "size": "512GB", "priceExtra": 25000.0},
      {"id": "3", "size": "1TB", "priceExtra": 50000.0}
    ],
    "specifications": {
      "Display": "6.7-inch Super Retina XDR",
      "Chip": "A17 Pro chip",
      "Camera": "48MP Main, 12MP Ultra Wide, 12MP Telephoto",
      "Battery": "Up to 29 hours video playback",
      "Storage": "256GB, 512GB, 1TB",
      "Operating System": "iOS 17",
      "Connectivity": "5G, Wi-Fi 6E, Bluetooth 5.3",
      "Water Resistance": "IP68",
      "Weight": "221 grams",
      "Materials": "Titanium design"
    },
    "description":
        """The iPhone 15 Pro Max represents the pinnacle of smartphone technology, featuring the revolutionary A17 Pro chip built on 3-nanometer technology. This powerhouse delivers unprecedented performance for gaming, professional photography, and demanding applications.

The advanced camera system includes a 48MP Main camera with 2x Telephoto, 12MP Ultra Wide, and 12MP Telephoto with 5x optical zoom. Capture stunning photos and videos with enhanced computational photography and cinematic video recording.

Built with aerospace-grade titanium, the iPhone 15 Pro Max is both incredibly strong and remarkably light. The Action Button provides quick access to your most-used features, while USB-C connectivity offers universal compatibility.""",
    "reviews": [
      {
        "id": "1",
        "userName": "Sarah Johnson",
        "rating": 5.0,
        "comment":
            "Absolutely love this phone! The camera quality is incredible and the titanium build feels premium. Battery life easily lasts all day even with heavy usage.",
        "date": DateTime.now().subtract(Duration(days: 5)),
        "images": [
          "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?fm=jpg&q=60&w=300&ixlib=rb-4.0.3"
        ]
      },
      {
        "id": "2",
        "userName": "Michael Chen",
        "rating": 4.0,
        "comment":
            "Great performance and build quality. The 5x zoom is amazing for photography. Only wish the price was a bit lower, but you get what you pay for.",
        "date": DateTime.now().subtract(Duration(days: 12)),
        "images": []
      },
      {
        "id": "3",
        "userName": "Emma Rodriguez",
        "rating": 5.0,
        "comment":
            "Upgraded from iPhone 13 and the difference is night and day. The A17 Pro chip handles everything I throw at it. Highly recommend!",
        "date": DateTime.now().subtract(Duration(days: 18)),
        "images": [
          "https://images.unsplash.com/photo-1580910051074-3eb694886505?fm=jpg&q=60&w=300&ixlib=rb-4.0.3",
          "https://images.unsplash.com/photo-1556656793-08538906a9f8?fm=jpg&q=60&w=300&ixlib=rb-4.0.3"
        ]
      }
    ]
  };

  final List<Map<String, dynamic>> _relatedProducts = [
    {
      "id": "2",
      "name": "AirPods Pro (2nd Gen)",
      "price": 35000.00,
      "rating": 4.7,
      "reviewCount": 1523,
      "image":
          "https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3"
    },
    {
      "id": "3",
      "name": "iPhone 15 Pro",
      "price": 140000.00,
      "rating": 4.6,
      "reviewCount": 2156,
      "image":
          "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3"
    },
    {
      "id": "4",
      "name": "MagSafe Charger",
      "price": 5000.00,
      "rating": 4.4,
      "reviewCount": 892,
      "image":
          "https://images.unsplash.com/photo-1583394838336-acd977736f90?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3"
    },
    {
      "id": "5",
      "name": "iPhone 15 Plus",
      "price": 120000.00,
      "rating": 4.5,
      "reviewCount": 1678,
      "image":
          "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3"
    }
  ];

  @override
  void initState() {
    super.initState();
    if ((_productData['colors'] as List).isNotEmpty) {
      _selectedColorId = (_productData['colors'] as List).first['id'] as String;
    }
    if ((_productData['storage'] as List).isNotEmpty) {
      _selectedStorageId =
          (_productData['storage'] as List).first['id'] as String;
    }
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  void _toggleWishlist() {
    setState(() {
      _isWishlisted = !_isWishlisted;
    });
  }

  void _onQuantityChanged(int quantity) {
    setState(() {
      _selectedQuantity = quantity;
    });
  }

  void _onVariantChanged(String colorId, String storageId) {
    setState(() {
      _selectedColorId = colorId;
      _selectedStorageId = storageId;
    });
  }

  void _addToCart() {
    if (_productData['inStock'] as bool) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AddToCartBottomSheet(
          product: _productData,
          quantity: _selectedQuantity,
        ),
      );
    } else {
      _showNotifyWhenAvailable();
    }
  }

  void _showNotifyWhenAvailable() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Out of Stock'),
        content: Text(
            'This product is currently out of stock. Would you like to be notified when it becomes available?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'You will be notified when this product is back in stock')),
              );
            },
            child: Text('Notify Me'),
          ),
        ],
      ),
    );
  }

  void _toggleScanner() {
    setState(() {
      _showScanner = !_showScanner;
      if (_showScanner) {
        _scannerController = MobileScannerController();
      } else {
        _scannerController?.dispose();
        _scannerController = null;
      }
    });
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        _toggleScanner();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scanned: $code')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 45.h,
                pinned: true,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                leading: Container(
                  margin: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 6.w,
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Share functionality
                      },
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 6.w,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: IconButton(
                      onPressed: _toggleWishlist,
                      icon: CustomIconWidget(
                        iconName:
                            _isWishlisted ? 'favorite' : 'favorite_border',
                        color: _isWishlisted
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        size: 6.w,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: ProductImageGallery(
                    images: (_productData['images'] as List).cast<String>(),
                    heroTag: 'product_${_productData['id']}',
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ProductInfoSection(product: _productData),
                    ProductVariantsSection(
                      colors: (_productData['colors'] as List)
                          .cast<Map<String, dynamic>>(),
                      storage: (_productData['storage'] as List)
                          .cast<Map<String, dynamic>>(),
                      onVariantChanged: _onVariantChanged,
                    ),
                    QuantitySelector(
                      initialQuantity: _selectedQuantity,
                      maxQuantity: _productData['maxQuantity'] as int,
                      onQuantityChanged: _onQuantityChanged,
                    ),
                    SizedBox(height: 2.h),
                    ExpandableSection(
                      title: 'Specifications',
                      content: SpecificationsContent(
                        specifications: _productData['specifications']
                            as Map<String, dynamic>,
                      ),
                    ),
                    ExpandableSection(
                      title: 'Description',
                      content: Text(
                        _productData['description'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ),
                    ExpandableSection(
                      title:
                          'Customer Reviews (${_productData['reviewCount']})',
                      content: CustomerReviewsContent(
                        reviews: (_productData['reviews'] as List)
                            .cast<Map<String, dynamic>>(),
                      ),
                    ),
                    RelatedProductsSection(relatedProducts: _relatedProducts),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ],
          ),
          if (_showScanner && _scannerController != null)
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: _scannerController!,
                      onDetect: _onBarcodeDetected,
                    ),
                    Positioned(
                      top: 8.h,
                      left: 4.w,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: IconButton(
                          onPressed: _toggleScanner,
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 6.w,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: !_showScanner
          ? FloatingActionButton(
              onPressed: _toggleScanner,
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              child: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: AppTheme.lightTheme.colorScheme.onSecondary,
                size: 6.w,
              ),
            )
          : null,
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: (_productData['inStock'] as bool)
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.3),
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
            child: Text(
              (_productData['inStock'] as bool)
                  ? 'Add to Cart'
                  : 'Notify When Available',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
