library custom_list;

import 'dart:html';
import 'dart:math';
import 'package:polymer/polymer.dart';
import 'package:custom_list/components/custom_list_item.dart';

part 'mutation_state.dart';

@CustomTag("custom-list")
class CustomList extends PolymerElement {
  CustomList.created(): super.created();

  @published int bouncebacknum = INITIAL_BOUNCEBACK;

  @published ObservableList itemlist;

  @override
  void attached() {
    super.attached();
    _root = $["root"];

    // observe change of child elements for a 2 pass layout approach
    var mo = new MutationObserver(onChildMutation);
    mo.observe(_root, childList: true);
    _observer = mo;
  }

  void bouncebacknumChanged(int old) {
    _resetState(bouncebacknum);
  }

  void itemlistChanged(ObservableList old) {
    if (itemlist.isEmpty) {
      // reset the whole state when the list gets emptied
      _resetState(bouncebacknum);
    }
  }

  /// Reset the mutation state to default.
  /// Called when we want to restruct the layout
  void _resetState(int bounceback) {
    _state = new MutationState(bounceback);
  }

  /// Called when a mutation occurs to the target element
  void onChildMutation(List<MutationRecord> changes, MutationObserver observer) {
    // layout children depending on its rendering size

    for (var record in changes) {
      var added = record.addedNodes;
      var removed = record.removedNodes;
      for (var a in added) {
        if (!(a.nodeType == Node.ELEMENT_NODE && a is CustomListItem)) {
          // ignore nodes expect for the one we want
          continue;
        }
        var elem = a as CustomListItem;
        var width = elem.clientWidth;
        var height = elem.clientHeight;
        // print("${width}x${height}");

        var unit = "px";
        if (elem.item.entered) {
          // This item is already displayed
          // so place the view at the same position

          var l = "${elem.item.rect.left}${unit}";
          var t = "${elem.item.rect.top}${unit}";
          elem.style.left = l;
          elem.style.top = t;
        } else {
          // This item is a new one.
          //  Layout the remark at a sufficient position
          var posRect = _state.getPositionRect(width, height);
          var l = "${posRect.left}${unit}";
          var t = "${posRect.top}${unit}";
          elem.style.left = l;
          elem.style.top = t;
          elem.item.rect = posRect;
          applyAnimation(elem, "fadein", 250);
          elem.item.entered = true;
        }
        // update current state
        _state.update(width, height);
      }
    }
  }

  /// Apply specified animation to the given element
  static void applyAnimation(Element element, String name, int msecDuration) {
    element.style.animationName = name;
    element.style.animationDuration = "${msecDuration}ms";
    element.style.animationTimingFunction = "linear";
    element.style.animationFillMode = "forwards";
  }

  static const int MAX_BOUNCEBACK = 10;
  static const int MIN_BOUNCEBACK = 2;
  static const int INITIAL_BOUNCEBACK = 3;

  Element _root;
  MutationObserver _observer;
  MutationState _state = new MutationState(INITIAL_BOUNCEBACK);
}
