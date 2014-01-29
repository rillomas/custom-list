import 'dart:html';
import 'dart:math';
import 'package:polymer/polymer.dart';
import 'custom-list-item.dart';

@CustomTag("custom-list")
class CustomList extends PolymerElement {
	CustomList.created() : super.created();

	@published
	int bouncebacknum = 3;

	@published
	List itemlist = toObservable([]);

	@override
	void enteredView() {
		super.enteredView();
		_root = shadowRoot.querySelector("#root");

		// observe change of child elements for a 2 pass layout approach
		var mo = new MutationObserver(onChildMutation);
		mo.observe(_root, childList:true);
		_observer = mo;
	}

	/// Called when a mutation occurs to the target element
	void onChildMutation(List<MutationRecord> changes, MutationObserver observer) {
		// layout children depending on its rendering size

		int itemCount = 0;
		int bounceBackDelta = bouncebacknum - 1;
		int nextBounceBack = bounceBackDelta;
		int xOffset = 0;
		int yOffset = 0;
		bool offsetRight = true;
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
					Rectangle<int> posRect;
					if (offsetRight) {
						posRect = new Rectangle<int>(xOffset,yOffset,width, height);
					} else {
						posRect = new Rectangle<int>(xOffset-width, yOffset, width, height);
					}
					var l = "${posRect.left}${unit}";
					var t = "${posRect.top}${unit}";
					elem.style.left = l;
					elem.style.top = t;
					elem.item.rect = posRect;
					applyAnimation(elem, "fadein", 250);
					elem.item.entered = true;
				}

				// update offset depending on direction
				if (offsetRight) {
					xOffset += width;
				} else {
					xOffset -= width;
				}

				// update bounceback state
				if (offsetRight && itemCount == nextBounceBack) {
					offsetRight = false;
					xOffset -= width;
					nextBounceBack += bounceBackDelta;
				} else if (!offsetRight && itemCount == nextBounceBack) {
					offsetRight = true;
					xOffset += width;
					nextBounceBack += bounceBackDelta;
				}

				yOffset += height;
				itemCount++;
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

	Element _root;
	MutationObserver _observer;
}