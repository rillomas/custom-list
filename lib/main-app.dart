import 'dart:html';
import 'package:polymer/polymer.dart';
import 'item_view_model.dart';

@CustomTag("main-app")
class MainApp extends PolymerElement {
	MainApp.created() : super.created() {
		itemList = toObservable([
			new ItemViewModel("aardvark"),
			new ItemViewModel("binturong"),
			new ItemViewModel("caribou"),
			new ItemViewModel("dingo"),
			new ItemViewModel("elephant"),
		]);
	}

	@observable
	List itemList;

	@observable
	int bounceBackNum = 5;

	@observable
	String text = "";

	void addItem(Event e, var detail, Node target) {
		itemList.add(new ItemViewModel(text));
	}
}
