library main_app;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:custom_list/view_models/view_models.dart';
import 'custom_list.dart';

@CustomTag("main-app")
class MainApp extends PolymerElement {
  MainApp.created(): super.created() {
    itemList = toObservable([
      new ItemViewModel("aardvark"),
      new ItemViewModel("binturong"),
      new ItemViewModel("caribou"),
      new ItemViewModel("dingo"),
      new ItemViewModel("elephant"),]);
  }

  @observable List itemList = [];

  @observable int bounceBackNum = 5;

  @observable bool canIncrement = true;

  @observable bool canDecrement = true;

  @observable String text = "";

  void bounceBackNumChanged(int oldValue) {
    canIncrement = (bounceBackNum < CustomList.MAX_BOUNCEBACK);
    canDecrement = (bounceBackNum > CustomList.MIN_BOUNCEBACK);
  }

  void addItem(Event e, var detail, Node target) {
    itemList.add(new ItemViewModel(text));
  }

  void clearItems(Event e, var detail, Node target) {
    itemList.clear();
  }

  void incrementBounceBack(Event e, var detail, Node target) {
    bounceBackNum++;
    resetLayout();
  }

  void decrementBounceBack(Event e, var detail, Node target) {
    bounceBackNum--;
    resetLayout();
  }

  void resetLayout() {
    var list = [];
    for (var item in itemList) {
      list.add(new ItemViewModel(item.text));
    }
    itemList = toObservable(list);
  }

}
