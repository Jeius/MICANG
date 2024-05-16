import 'package:flutter/material.dart';

class ExpandableTile {
  String title;
  Icon? icon;
  final List<ExpandableTile> tiles;
  bool isExpanded;
  dynamic item;

  ExpandableTile({
    required this.title,
    this.tiles = const [],
    this.isExpanded = false,
    this.item,
  }) {
    // icon = CategoryIcon().getIcon(item.category);
  }
}
