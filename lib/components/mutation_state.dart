part of custom_list;

class MutationState {
	MutationState(int bouncebackNum) {
		bounceBackDelta = bouncebackNum - 1;
		nextBounceBack = bounceBackDelta;
	}

  void update(int width, int height) {
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

  /// Get sufficient position rect for the next item
  Rectangle<int> getPositionRect(int width, int height) {
    if (offsetRight) {
      return new Rectangle<int>(xOffset, yOffset, width, height);
    } else {
      return new Rectangle<int>(xOffset - width, yOffset, width, height);
    }
  }

  int itemCount = 0;
  int xOffset = 0;
  int yOffset = 0;
  bool offsetRight = true;
  int bounceBackDelta;
  int nextBounceBack;
}

