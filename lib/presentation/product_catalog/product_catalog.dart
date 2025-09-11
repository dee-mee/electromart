import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/utils/currency_formatter.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/product_card_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';

class ProductCatalog extends StatefulWidget {
  const ProductCatalog({Key? key}) : super(key: key);

  @override
  State<ProductCatalog> createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final RefreshIndicator _refreshIndicatorKey = RefreshIndicator(
    onRefresh: () async {},
    child: Container(),
  );

  // State variables
  bool _isLoading = false;
  bool _isLoadingMore = false;
  SortOption _currentSort = SortOption.relevance;
  Map<String, dynamic> _activeFilters = {};
  String _selectedCategory = "All";
  int _currentPage = 1;
  final int _itemsPerPage = 20;

  // Categories
  final List<String> _categories = [
    "All",
    "Smartphones",
    "Earphones",
    "Earpods",
    "Accessories"
  ];

  // Mock product data
  final List<Map<String, dynamic>> _allProducts = [
    {
      "id": 1,
      "name": "iPhone 15 Pro Max",
      "category": "Smartphones",
      "brand": "Apple",
      "price": 1199.99,
      "originalPrice": 1299.99,
      "rating": 4.8,
      "reviewCount": 2847,
      "stock": 15,
      "image":
          "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=400&fit=crop",
      "isWishlisted": false,
      "features": ["5G Compatible", "Wireless", "Fast Charging"],
      "createdAt": DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      "id": 2,
      "name": "Samsung Galaxy S24 Ultra",
      "category": "Smartphones",
      "brand": "Samsung",
      "price": 1099.99,
      "originalPrice": 1199.99,
      "rating": 4.7,
      "reviewCount": 1923,
      "stock": 8,
      "image":
          "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=400&fit=crop",
      "isWishlisted": true,
      "features": [
        "5G Compatible",
        "Wireless",
        "Fast Charging",
        "Water Resistant"
      ],
      "createdAt": DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      "id": 3,
      "name": "Sony WH-1000XM5",
      "category": "Earphones",
      "brand": "Sony",
      "price": 349.99,
      "originalPrice": 399.99,
      "rating": 4.9,
      "reviewCount": 5672,
      "stock": 23,
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop",
      "isWishlisted": false,
      "features": ["Wireless", "Noise Cancelling", "Bluetooth 5.0+"],
      "createdAt": DateTime.now().subtract(const Duration(days: 12)),
    },
    {
      "id": 4,
      "name": "Apple AirPods Pro 2",
      "category": "Earpods",
      "brand": "Apple",
      "price": 249.99,
      "originalPrice": 279.99,
      "rating": 4.6,
      "reviewCount": 8934,
      "stock": 0,
      "image":
          "https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=400&h=400&fit=crop",
      "isWishlisted": true,
      "features": ["Wireless", "Noise Cancelling", "Water Resistant"],
      "createdAt": DateTime.now().subtract(const Duration(days: 8)),
    },
    {
      "id": 5,
      "name": "Bose QuietComfort Earbuds",
      "category": "Earpods",
      "brand": "Bose",
      "price": 279.99,
      "originalPrice": 299.99,
      "rating": 4.5,
      "reviewCount": 3421,
      "stock": 12,
      "image":
          "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&h=400&fit=crop",
      "isWishlisted": false,
      "features": ["Wireless", "Noise Cancelling", "Bluetooth 5.0+"],
      "createdAt": DateTime.now().subtract(const Duration(days: 15)),
    },
    {
      "id": 6,
      "name": "JBL Charge 5 Speaker",
      "category": "Accessories",
      "brand": "JBL",
      "price": 179.99,
      "originalPrice": 199.99,
      "rating": 4.4,
      "reviewCount": 2156,
      "stock": 18,
      "image":
          "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400&h=400&fit=crop",
      "isWishlisted": false,
      "features": ["Wireless", "Water Resistant", "Fast Charging"],
      "createdAt": DateTime.now().subtract(const Duration(days: 20)),
    },
    {
      "id": 7,
      "name": "OnePlus 12 Pro",
      "category": "Smartphones",
      "brand": "OnePlus",
      "price": 899.99,
      "originalPrice": 999.99,
      "rating": 4.6,
      "reviewCount": 1567,
      "stock": 25,
      "image":
          "https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=400&h=400&fit=crop",
      "isWishlisted": false,
      "features": ["5G Compatible", "Fast Charging", "Wireless"],
      "createdAt": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "id": 8,
      "name": "Google Pixel Buds Pro",
      "category": "Earpods",
      "brand": "Google",
      "price": 199.99,
      "originalPrice": 229.99,
      "rating": 4.3,
      "reviewCount": 2789,
      "stock": 14,
      "image":
          "https://images.unsplash.com/photo-1484704849700-f032a568e944?w=400&h=400&fit=crop",
      "isWishlisted": true,
      "features": ["Wireless", "Noise Cancelling", "Water Resistant"],
      "createdAt": DateTime.now().subtract(const Duration(days: 6)),
    },
  ];

  List<Map<String, dynamic>> _filteredProducts = [];
  List<Map<String, dynamic>> _displayedProducts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
    _filteredProducts = List.from(_allProducts);
    _loadProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategory = _categories[_tabController.index];
        _currentPage = 1;
      });
      _applyFilters();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _displayedProducts.length < _filteredProducts.length) {
      _loadMoreProducts();
    }
  }

  void _loadProducts() {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _applyFilters();
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _loadMoreProducts() {
    setState(() {
      _isLoadingMore = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _currentPage++;
        final startIndex = (_currentPage - 1) * _itemsPerPage;
        final endIndex =
            (_currentPage * _itemsPerPage).clamp(0, _filteredProducts.length);

        if (startIndex < _filteredProducts.length) {
          _displayedProducts.addAll(
            _filteredProducts.sublist(startIndex, endIndex),
          );
        }
        _isLoadingMore = false;
      });
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _currentPage = 1;
    });
    await Future.delayed(const Duration(seconds: 1));
    _applyFilters();
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allProducts);

    // Category filter
    if (_selectedCategory != "All") {
      filtered = filtered
          .where(
              (product) => (product["category"] as String) == _selectedCategory)
          .toList();
    }

    // Apply active filters
    if (_activeFilters.isNotEmpty) {
      // Categories filter
      if (_activeFilters['categories'] != null &&
          (_activeFilters['categories'] as List).isNotEmpty) {
        filtered = filtered
            .where((product) => (_activeFilters['categories'] as List)
                .contains(product["category"]))
            .toList();
      }

      // Price range filter
      if (_activeFilters['minPrice'] != null ||
          _activeFilters['maxPrice'] != null) {
        final minPrice = (_activeFilters['minPrice'] as double?) ?? 0;
        final maxPrice =
            (_activeFilters['maxPrice'] as double?) ?? double.infinity;
        filtered = filtered.where((product) {
          final price = (product["price"] as num).toDouble();
          return price >= minPrice && price <= maxPrice;
        }).toList();
      }

      // Brand filter
      if (_activeFilters['brands'] != null &&
          (_activeFilters['brands'] as List).isNotEmpty) {
        filtered = filtered
            .where((product) =>
                (_activeFilters['brands'] as List).contains(product["brand"]))
            .toList();
      }

      // Features filter
      if (_activeFilters['features'] != null &&
          (_activeFilters['features'] as List).isNotEmpty) {
        filtered = filtered.where((product) {
          final productFeatures = (product["features"] as List<String>?) ?? [];
          return (_activeFilters['features'] as List)
              .any((feature) => productFeatures.contains(feature));
        }).toList();
      }

      // Rating filter
      if (_activeFilters['minRating'] != null) {
        final minRating = _activeFilters['minRating'] as int;
        filtered = filtered
            .where((product) => (product["rating"] as double) >= minRating)
            .toList();
      }
    }

    // Apply sorting
    _applySorting(filtered);

    setState(() {
      _filteredProducts = filtered;
      _displayedProducts = filtered.take(_itemsPerPage).toList();
      _currentPage = 1;
    });
  }

  void _applySorting(List<Map<String, dynamic>> products) {
    switch (_currentSort) {
      case SortOption.priceLowToHigh:
        products
            .sort((a, b) => (a["price"] as num).compareTo(b["price"] as num));
        break;
      case SortOption.priceHighToLow:
        products
            .sort((a, b) => (b["price"] as num).compareTo(a["price"] as num));
        break;
      case SortOption.rating:
        products
            .sort((a, b) => (b["rating"] as num).compareTo(a["rating"] as num));
        break;
      case SortOption.newest:
        products.sort((a, b) =>
            (b["createdAt"] as DateTime).compareTo(a["createdAt"] as DateTime));
        break;
      case SortOption.relevance:
      default:
        // Keep original order for relevance
        break;
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SortBottomSheetWidget(
        currentSort: _currentSort,
        onSortSelected: (sortOption) {
          setState(() {
            _currentSort = sortOption;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _showFilters() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterModalWidget(
          currentFilters: _activeFilters,
          onFiltersApplied: (filters) {
            setState(() {
              _activeFilters = filters;
            });
            _applyFilters();
          },
        ),
      ),
    );
  }

  void _removeFilter(String filterType, String value) {
    setState(() {
      if (_activeFilters[filterType] != null) {
        (_activeFilters[filterType] as List).remove(value);
        if ((_activeFilters[filterType] as List).isEmpty) {
          _activeFilters.remove(filterType);
        }
      }
    });
    _applyFilters();
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters.clear();
    });
    _applyFilters();
  }

  List<Widget> _buildActiveFilterChips() {
    List<Widget> chips = [];

    // Category chips
    if (_activeFilters['categories'] != null) {
      for (String category in _activeFilters['categories'] as List) {
        chips.add(FilterChipWidget(
          label: category,
          isSelected: true,
          onRemove: () => _removeFilter('categories', category),
        ));
      }
    }

    // Brand chips
    if (_activeFilters['brands'] != null) {
      for (String brand in _activeFilters['brands'] as List) {
        chips.add(FilterChipWidget(
          label: brand,
          isSelected: true,
          onRemove: () => _removeFilter('brands', brand),
        ));
      }
    }

    // Features chips
    if (_activeFilters['features'] != null) {
      for (String feature in _activeFilters['features'] as List) {
        chips.add(FilterChipWidget(
          label: feature,
          isSelected: true,
          onRemove: () => _removeFilter('features', feature),
        ));
      }
    }

    // Price range chip
    if (_activeFilters['minPrice'] != null ||
        _activeFilters['maxPrice'] != null) {
      final minPrice = (_activeFilters['minPrice'] as double?) ?? 0;
      final maxPrice = (_activeFilters['maxPrice'] as double?) ?? 2000;
      chips.add(FilterChipWidget(
        label: "${formatCurrencyKsh(minPrice.roundToDouble())}-${formatCurrencyKsh(maxPrice.roundToDouble())}",
        isSelected: true,
        onRemove: () {
          setState(() {
            _activeFilters.remove('minPrice');
            _activeFilters.remove('maxPrice');
          });
          _applyFilters();
        },
      ));
    }

    // Rating chip
    if (_activeFilters['minRating'] != null) {
      chips.add(FilterChipWidget(
        label: "${_activeFilters['minRating']}+ Stars",
        isSelected: true,
        onRemove: () {
          setState(() {
            _activeFilters.remove('minRating');
          });
          _applyFilters();
        },
      ));
    }

    return chips;
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_activeFilters['categories'] != null) {
      count += (_activeFilters['categories'] as List).length;
    }
    if (_activeFilters['brands'] != null) {
      count += (_activeFilters['brands'] as List).length;
    }
    if (_activeFilters['features'] != null) {
      count += (_activeFilters['features'] as List).length;
    }
    if (_activeFilters['minPrice'] != null ||
        _activeFilters['maxPrice'] != null) {
      count += 1;
    }
    if (_activeFilters['minRating'] != null) {
      count += 1;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Catalog"),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/search-results'),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
          Stack(
            children: [
              GestureDetector(
                onTap: _showFilters,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomIconWidget(
                    iconName: 'tune',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ),
              if (_getActiveFilterCount() > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _getActiveFilterCount().toString(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: Column(
        children: [
          // Active Filters
          if (_buildActiveFilterChips().isNotEmpty)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _buildActiveFilterChips(),
                    ),
                  ),
                  if (_buildActiveFilterChips().isNotEmpty)
                    TextButton(
                      onPressed: _clearAllFilters,
                      child: Text(
                        "Clear All",
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          // Product Grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _displayedProducts.isEmpty
                    ? EmptyStateWidget(
                        title: "No Products Found",
                        subtitle:
                            "Try adjusting your filters or search criteria to find what you're looking for.",
                        actionText: "Clear Filters",
                        onActionPressed: _clearAllFilters,
                        iconName: 'inventory_2',
                      )
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 100.w > 600 ? 3 : 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: _displayedProducts.length +
                              (_isLoadingMore ? 2 : 0),
                          itemBuilder: (context, index) {
                            if (index >= _displayedProducts.length) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final product = _displayedProducts[index];
                            return ProductCardWidget(
                              product: product,
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/product-detail',
                                arguments: product,
                              ),
                              onWishlistTap: () {
                                setState(() {
                                  product["isWishlisted"] =
                                      !(product["isWishlisted"] as bool? ??
                                          false);
                                });
                              },
                              onCompareTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "${product["name"]} added to comparison"),
                                  ),
                                );
                              },
                              onShareTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Sharing ${product["name"]}"),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSortOptions,
        child: CustomIconWidget(
          iconName: 'sort',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
