import 'package:flutter/material.dart';

class CategoryItem {
  
  final String location;
  final String amount;
  final String description;
  final String contact;
  final String hostName;
  final String image;
  final String eventname;

  CategoryItem({

    required this.location,
    required this.amount,
    required this.description,
    required this.contact,
    required this.hostName,
    required this.image,
    required this.eventname,
  });
}

class CategoryProvider with ChangeNotifier {
  final Map<String, List<CategoryItem>> _categories = {};

  Map<String, List<CategoryItem>> get categories => _categories;

  void addCategoryItem(String category, CategoryItem item) {
    if (!_categories.containsKey(category)) {
      _categories[category] = [];
    }
    _categories[category]!.add(item);
    notifyListeners();
  }
}
