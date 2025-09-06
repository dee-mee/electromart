import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/no_results_widget.dart';
import './widgets/product_grid_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/search_header_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';
import './widgets/voice_search_widget.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  String _searchQuery = '';
  String _currentSort = 'relevance';
  Map<String, dynamic> _currentFilters = {};
  bool _showVoiceSearch = false;
  bool _isLoading = false;
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  final ImagePicker _imagePicker = ImagePicker();

  // Mock data
  final List<Map<String, dynamic>> _allProducts = [
    {
      "id": 1,
      "name": "iPhone 15 Pro Max",
      "price": "\$1,199",
      "rating": 4.8,
      "image":
          "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Smartphones",
      "brand": "Apple",
      "inStock": true,
      "isScanned": false,
      "relevanceScore": 0.95,
    },
    {
      "id": 2,
      "name": "Samsung Galaxy S24 Ultra",
      "price": "\$1,299",
      "rating": 4.7,
      "image":
          "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Smartphones",
      "brand": "Samsung",
      "inStock": true,
      "isScanned": false,
      "relevanceScore": 0.88,
    },
    {
      "id": 3,
      "name": "Sony WH-1000XM5 Headphones",
      "price": "\$399",
      "rating": 4.9,
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Earphones",
      "brand": "Sony",
      "inStock": true,
      "isScanned": true,
      "relevanceScore": 0.92,
    },
    {
      "id": 4,
      "name": "AirPods Pro 2nd Gen",
      "price": "\$249",
      "rating": 4.6,
      "image":
          "https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Earpods",
      "brand": "Apple",
      "inStock": false,
      "isScanned": false,
      "relevanceScore": 0.85,
    },
    {
      "id": 5,
      "name": "Bose QuietComfort Earbuds",
      "price": "\$279",
      "rating": 4.5,
      "image":
          "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Earpods",
      "brand": "Bose",
      "inStock": true,
      "isScanned": false,
      "relevanceScore": 0.78,
    },
    {
      "id": 6,
      "name": "OnePlus 12 Pro",
      "price": "\$899",
      "rating": 4.4,
      "image":
          "https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Smartphones",
      "brand": "OnePlus",
      "inStock": true,
      "isScanned": false,
      "relevanceScore": 0.72,
    },
  ];

  final List<String> _recentSearches = [
    'iPhone 15',
    'Samsung Galaxy',
    'AirPods Pro',
    'Sony headphones',
    'Wireless earbuds',
  ];

  final List<String> _suggestedSearches = [
    'iPhone 15 Pro',
    'Samsung Galaxy S24',
    'AirPods Pro',
    'Sony WH-1000XM5',
    'Wireless earbuds',
    'Gaming headphones',
  ];

  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _filteredProducts = List.from(_allProducts);

    // Get search query from route arguments if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['query'] != null) {
        setState(() {
          _searchQuery = args['query'] as String;
        });
        _performSearch();
      }
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      // Handle camera initialization error silently
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _openBarcodeScanner();
    }
  }

  Future<void> _openBarcodeScanner() async {
    if (_cameras.isEmpty) return;

    try {
      _cameraController = CameraController(
        _cameras.first,
        ResolutionPreset.medium,
      );
      await _cameraController!.initialize();

      if (mounted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _BarcodeScannerScreen(
              cameraController: _cameraController!,
            ),
          ),
        );

        if (result != null) {
          _handleBarcodeResult(result as String);
        }
      }
    } catch (e) {
      // Handle camera error silently
    }
  }

  void _handleBarcodeResult(String barcode) {
    // Simulate barcode product lookup
    final scannedProduct = _allProducts.firstWhere(
      (product) => product['id'] == 3, // Sony headphones as example
      orElse: () => _allProducts.first,
    );

    setState(() {
      scannedProduct['isScanned'] = true;
      _searchQuery = scannedProduct['name'] as String;
      _filteredProducts = [scannedProduct];
    });
  }

  void _performSearch() {
    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _filteredProducts = _filterAndSortProducts();
          _isLoading = false;
        });
      }
    });
  }

  List<Map<String, dynamic>> _filterAndSortProducts() {
    List<Map<String, dynamic>> filtered = List.from(_allProducts);

    // Apply search query filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final name = (product['name'] as String).toLowerCase();
        final brand = (product['brand'] as String).toLowerCase();
        final category = (product['category'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            brand.contains(query) ||
            category.contains(query);
      }).toList();
    }

    // Apply filters
    if (_currentFilters.isNotEmpty) {
      // Price range filter
      if (_currentFilters['minPrice'] != null ||
          _currentFilters['maxPrice'] != null) {
        filtered = filtered.where((product) {
          final priceStr = (product['price'] as String)
              .replaceAll('\$', '')
              .replaceAll(',', '');
          final price = double.tryParse(priceStr) ?? 0;
          final minPrice = _currentFilters['minPrice'] ?? 0;
          final maxPrice = _currentFilters['maxPrice'] ?? double.infinity;
          return price >= minPrice && price <= maxPrice;
        }).toList();
      }

      // Category filter
      final categories = _currentFilters['categories'] as List<String>?;
      if (categories != null && categories.isNotEmpty) {
        filtered = filtered
            .where(
                (product) => categories.contains(product['category'] as String))
            .toList();
      }

      // Brand filter
      final brands = _currentFilters['brands'] as List<String>?;
      if (brands != null && brands.isNotEmpty) {
        filtered = filtered
            .where((product) => brands.contains(product['brand'] as String))
            .toList();
      }

      // In stock filter
      if (_currentFilters['inStockOnly'] == true) {
        filtered =
            filtered.where((product) => product['inStock'] == true).toList();
      }
    }

    // Apply sorting
    switch (_currentSort) {
      case 'price_low':
        filtered.sort((a, b) {
          final priceA = double.tryParse((a['price'] as String)
                  .replaceAll('\$', '')
                  .replaceAll(',', '')) ??
              0;
          final priceB = double.tryParse((b['price'] as String)
                  .replaceAll('\$', '')
                  .replaceAll(',', '')) ??
              0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_high':
        filtered.sort((a, b) {
          final priceA = double.tryParse((a['price'] as String)
                  .replaceAll('\$', '')
                  .replaceAll(',', '')) ??
              0;
          final priceB = double.tryParse((b['price'] as String)
                  .replaceAll('\$', '')
                  .replaceAll(',', '')) ??
              0;
          return priceB.compareTo(priceA);
        });
        break;
      case 'rating':
        filtered.sort(
            (a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
        break;
      case 'relevance':
      default:
        filtered.sort((a, b) => (b['relevanceScore'] as double)
            .compareTo(a['relevanceScore'] as double));
        break;
    }

    return filtered;
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_currentFilters['minPrice'] != null && _currentFilters['minPrice'] > 0)
      count++;
    if (_currentFilters['maxPrice'] != null &&
        _currentFilters['maxPrice'] < 2000) count++;
    if ((_currentFilters['categories'] as List<String>? ?? []).isNotEmpty)
      count++;
    if ((_currentFilters['brands'] as List<String>? ?? []).isNotEmpty) count++;
    if ((_currentFilters['ratings'] as List<String>? ?? []).isNotEmpty) count++;
    if (_currentFilters['inStockOnly'] == true) count++;
    if (_currentFilters['freeShipping'] == true) count++;
    return count;
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        currentFilters: _currentFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _performSearch();
        },
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheetWidget(
        currentSort: _currentSort,
        onSortChanged: (sort) {
          setState(() {
            _currentSort = sort;
          });
          _performSearch();
        },
      ),
    );
  }

  void _showVoiceSearchModal() {
    setState(() => _showVoiceSearch = true);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) => VoiceSearchWidget(
        onTranscriptionComplete: (transcription) {
          Navigator.pop(context);
          setState(() {
            _searchQuery = transcription;
            _showVoiceSearch = false;
          });
          _performSearch();
        },
        onCancel: () {
          Navigator.pop(context);
          setState(() => _showVoiceSearch = false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Search Results',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: _requestCameraPermission,
            icon: CustomIconWidget(
              iconName: 'qr_code_scanner',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchHeaderWidget(
            searchQuery: _searchQuery,
            filterCount: _getActiveFilterCount(),
            onEditSearch: () {
              // Focus search bar
            },
            onFilterTap: _showFilterModal,
            onSortTap: _showSortBottomSheet,
          ),
          SearchBarWidget(
            searchQuery: _searchQuery,
            onSearchChanged: (query) {
              setState(() => _searchQuery = query);
              _performSearch();
            },
            onVoiceSearch: _showVoiceSearchModal,
            onRecentSearchTap: (search) {
              setState(() => _searchQuery = search);
              _performSearch();
            },
            recentSearches: _recentSearches,
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? NoResultsWidget(
                        searchQuery: _searchQuery,
                        onClearFilters: () {
                          setState(() {
                            _currentFilters.clear();
                          });
                          _performSearch();
                        },
                        onSuggestedSearch: (suggestion) {
                          setState(() => _searchQuery = suggestion);
                          _performSearch();
                        },
                        suggestedSearches: _suggestedSearches,
                      )
                    : ProductGridWidget(
                        products: _filteredProducts,
                        searchQuery: _searchQuery,
                        onProductTap: (product) {
                          Navigator.pushNamed(
                            context,
                            '/product-detail',
                            arguments: {'product': product},
                          );
                        },
                        onWishlistTap: (product) {
                          // Handle wishlist action
                        },
                        onCompareTap: (product) {
                          // Handle compare action
                        },
                        onShareTap: (product) {
                          // Handle share action
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _BarcodeScannerScreen extends StatefulWidget {
  final CameraController cameraController;

  const _BarcodeScannerScreen({
    Key? key,
    required this.cameraController,
  }) : super(key: key);

  @override
  State<_BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<_BarcodeScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Scan Barcode',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          CameraPreview(widget.cameraController),
          Center(
            child: Container(
              width: 60.w,
              height: 30.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 10.h,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Simulate barcode scan result
                  Navigator.pop(context, 'SAMPLE_BARCODE_123');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                ),
                child: const Text('Simulate Scan'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
