library custom_list_item;
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:custom_list/view_models/view_models.dart';

/// A custom list item
@CustomTag("custom-list-item")
class CustomListItem extends LIElement with Polymer, Observable {
  CustomListItem.created(): super.created();

  @published
  ItemViewModel item;
}
