import 'package:flutter/material.dart';
import 'package:app_ourecycle_main/backend/models/waste_category_model.dart';
import 'package:app_ourecycle_main/frontend/widgets/order_screen_widgets/order_header_and_image.dart';
import 'package:app_ourecycle_main/frontend/widgets/order_screen_widgets/product_info_section.dart';
import 'package:app_ourecycle_main/frontend/widgets/order_screen_widgets/bottom_order_action_bar.dart';

enum OrderCategory { pickOff, dropOff }

class OrderScreen extends StatefulWidget {
  final WasteCategoryModel category;
  const OrderScreen({super.key, required this.category});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderCategory? _selectedCategory = OrderCategory.pickOff;

  // --- FUNGSI BARU DITAMBAHKAN DI SINI ---
  IconData _getIconForCategory(String? categoryName) {
    switch (categoryName?.toLowerCase()) {
      case 'plastik':
        return Icons.local_drink;
      case 'kertas':
        return Icons.article;
      case 'kaca':
        return Icons.wine_bar;
      case 'logam':
        return Icons.build;
      default:
        return Icons.delete_outline;
    }
  }

  void _onCategoryChanged(OrderCategory? value) {
    setState(() {
      _selectedCategory = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderHeaderAndImage(imageId: widget.category.imageId),
            const SizedBox(height: 80 + 20.0),
            ProductInfoSection(
              category: widget.category,
              selectedCategory: _selectedCategory,
              onCategoryChanged: _onCategoryChanged,
              // --- KIRIM DATA IKON KE PRODUCT INFO SECTION ---
              categoryIcon: _getIconForCategory(widget.category.name),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomOrderActionBar(
        selectedCategory: _selectedCategory,
        wasteCategoryName: widget.category.name,
        pricePerKg: widget.category.pricePerKg ?? 0.0,
        imageId: widget.category.imageId ?? '',
        info: widget.category.info,
      ),
    );
  }
}
