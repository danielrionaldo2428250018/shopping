import 'package:flutter/material.dart';

import '../data/catalog_data.dart';
import '../utils/l10n_helpers.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;

    final categories = [
      {
        'icon': Icons.checkroom,
        'title': loc.catFashion,
        'key': 'Fashion',
        'count': catalogCountForCategory('Fashion'),
      },
      {
        'icon': Icons.phone_android,
        'title': loc.catElectronics,
        'key': 'Electronics',
        'count': catalogCountForCategory('Electronics'),
      },
      {
        'icon': Icons.watch,
        'title': loc.catAccessories,
        'key': 'Accessories',
        'count': catalogCountForCategory('Accessories'),
      },
      {
        'icon': Icons.sports_esports,
        'title': loc.catSports,
        'key': 'Gaming',
        'count': catalogCountForCategory('Gaming'),
      },
      {
        'icon': Icons.weekend,
        'title': loc.catFurniture,
        'key': 'Furniture',
        'count': catalogCountForCategory('Furniture'),
      },
      {
        'icon': Icons.menu_book,
        'title': loc.catHome,
        'key': 'Books',
        'count': catalogCountForCategory('Books'),
      },
    ];

    return Scaffold(
            appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          loc.shopByCategory,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.95,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          final title = category['title'] as String;
          final key = category['key'] as String;
          final count = category['count'] as int;

          return GestureDetector(
            onTap: () {
              String? categoryArg;
              if (key == 'Fashion' || key == 'Electronics') {
                categoryArg = key;
              }
              Navigator.pushNamed(
                context,
                '/search-results',
                arguments: categoryArg != null
                    ? <String, String>{'category': categoryArg}
                    : <String, String>{'q': key},
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7F3DFF).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      size: 42,
                      color: const Color(0xFF7F3DFF),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.productCount(count),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
