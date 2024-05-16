import 'package:flutter/material.dart';

import '../graph/interface/inode.dart';

class TextFieldKey {
  final focusNode = FocusNode();
  final textController = TextEditingController();
  String query = '';
  dynamic selectedItem;

  void unFocus() {
    focusNode.unfocus();
  }

  void clear() {
    query = '';
    textController.clear();
    selectedItem = null;
  }

  void setSelected(dynamic item) {
    selectedItem = item;
    textController.text = item.name;
    query = item.name;
  }

  INode? getSelectedNode() {
    if (selectedItem == null) return null;
    return selectedItem.node;
  }

  void dispose() {
    focusNode.dispose();
    textController.dispose();
  }
}
