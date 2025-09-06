import 'package:flutter/material.dart';

class PromoCodeWidget extends StatefulWidget {
  final String? currentPromoCode;
  final bool isProcessing;
  final Function(String) onApplyPromoCode;
  final VoidCallback onRemovePromoCode;

  const PromoCodeWidget({
    Key? key,
    this.currentPromoCode,
    required this.isProcessing,
    required this.onApplyPromoCode,
    required this.onRemovePromoCode,
  }) : super(key: key);

  @override
  State<PromoCodeWidget> createState() => _PromoCodeWidgetState();
}

class _PromoCodeWidgetState extends State<PromoCodeWidget> {
  final TextEditingController _promoController = TextEditingController();
  final FocusNode _promoFocusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentPromoCode != null) {
      _promoController.text = widget.currentPromoCode!;
      _isExpanded = true;
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    _promoFocusNode.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _promoFocusNode.requestFocus();
      });
    }
  }

  void _applyPromoCode() {
    final code = _promoController.text.trim();
    if (code.isNotEmpty) {
      widget.onApplyPromoCode(code);
    }
  }

  void _removePromoCode() {
    _promoController.clear();
    widget.onRemovePromoCode();
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Card(
        child: Column(
          children: [
            InkWell(
              onTap: widget.currentPromoCode == null ? _toggleExpanded : null,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.local_offer_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.currentPromoCode != null
                                ? 'Promo Code Applied'
                                : 'Add Promo Code',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (widget.currentPromoCode != null) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withAlpha(26),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.currentPromoCode!.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 4),
                            Text(
                              'Get discounts with promo codes',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.currentPromoCode != null)
                      IconButton(
                        onPressed: _removePromoCode,
                        icon: const Icon(Icons.close, size: 20),
                        tooltip: 'Remove Promo Code',
                      )
                    else
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded && widget.currentPromoCode == null
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          Divider(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withAlpha(128),
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _promoController,
                                  focusNode: _promoFocusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Enter promo code',
                                    prefixIcon: const Icon(
                                        Icons.confirmation_number_outlined),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  onFieldSubmitted: (_) => _applyPromoCode(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: widget.isProcessing
                                    ? null
                                    : _applyPromoCode,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                ),
                                child: widget.isProcessing
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Text('Apply'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Try code "SAVE10" for 10% off your order',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
