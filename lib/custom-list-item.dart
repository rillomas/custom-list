import 'dart:html';
import 'package:polymer/polymer.dart';
import 'item_view_model.dart';

/// A custom list item
@CustomTag("custom-list-item")
class CustomListItem extends LIElement with Polymer,Observable {
	CustomListItem.created() : super.created();

	@published
	ItemViewModel item;
}
