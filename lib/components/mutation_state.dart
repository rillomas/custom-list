part of custom_list;

class MutationState {
	MutationState(int bouncebackNum) {
		_bounceBackDelta = bouncebackNum - 1;
		_nextBounceBack = _bounceBackDelta;
	}

  /// update current state with the given width and height of the next item
  void update(int width, int height) {
    // update offset depending on direction
    if (_offsetRight) {
      _xOffset += width;
    } else {
      _xOffset -= width;
    }

    // update bounceback state
    if (_offsetRight && _itemCount == _nextBounceBack) {
      _offsetRight = false;
      _xOffset -= width;
      _nextBounceBack += _bounceBackDelta;
    } else if (!_offsetRight && _itemCount == _nextBounceBack) {
      _offsetRight = true;
      _xOffset += width;
      _nextBounceBack += _bounceBackDelta;
    }

    _yOffset += height;
    _itemCount++;
  }

  /// Get sufficient position rect for the next item
  Rectangle<int> getPositionRect(int width, int height) {
    if (_offsetRight) {
      return new Rectangle<int>(_xOffset, _yOffset, width, height);
    } else {
      return new Rectangle<int>(_xOffset - width, _yOffset, width, height);
    }
  }

  int _itemCount = 0;
  int _xOffset = 0;
  int _yOffset = 0;
  bool _offsetRight = true;
  int _bounceBackDelta;
  int _nextBounceBack;
}

