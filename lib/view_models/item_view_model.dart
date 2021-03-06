part of view_models;

class ItemViewModel extends Object with Observable {
  ItemViewModel(this.text);

  /// text of this item
  @observable String text;

  /// position and size
  Rectangle<int> rect = new Rectangle<int>(0, 0, 0, 0);

  /// true if this item is already shown
  bool entered = false;
}
