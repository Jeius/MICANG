import 'dart:core';

class BinaryHeap<E> {
  late Comparator<E> comparator;
  late List<E?> array;
  int _size = 0;

  BinaryHeap(Comparator<E> c) {
    comparator = c;
    array = List<E?>.filled(8, null);
  }

  void clear() {
    array.fillRange(0, array.length, null);
    _size = 0;
  }

  int size() {
    return _size;
  }

  void ensureCapacity() {
    if (array.length <= _size) {
      int newSize = array.length;
      while ((newSize *= 2) <= _size) {}
      array = List<E?>.from(array, growable: true);
      array.length = newSize;
    }
  }

  void add(E e) {
    _size++;
    ensureCapacity();
    array[_size] = e;
    bubbleUp(_size);
  }

  E? removeTop() {
    if (_size > 0) {
      E? obj = array[1];
      array[1] = array[_size];
      _size--;
      siftDown(1);
      return obj;
    }
    return null;
  }

  void remove(E e) {
    int index = indexOf(e);
    if (index != -1) {
      if (index == _size) {
        array[_size] = null;
        _size--;
      } else {
        array[index] = array[_size];
        _size--;
        siftDown(index);
      }
    }
  }

  bool contains(E e) {
    return indexOf(e) != -1;
  }

  int indexOf(E e) {
    for (int i = 0; i < array.length; i++) {
      if (e == array[i]) {
        return i;
      }
    }
    return -1;
  }

  void bubbleUp(int i) {
    while (i > 1) {
      if (comparator(array[i]!, array[i ~/ 2]!) >= 0) break;
      E? obj = array[i];
      array[i] = array[i ~/ 2];
      array[i ~/ 2] = obj;
      i ~/= 2;
    }
  }

  void siftDown(int i) {
    int i1 = i;
    while (true) {
      int i2 = i1;
      if (i2 * 2 + 1 <= _size) {
        if (comparator(array[i2]!, array[i2 * 2]!) > 0) {
          i1 = i2 * 2;
        }
        if (comparator(array[i1]!, array[i2 * 2 + 1]!) > 0) {
          i1 = i2 * 2 + 1;
        }
      } else if (i2 * 2 <= _size) {
        if (comparator(array[i1]!, array[i2 * 2]!) > 0) {
          i1 = i2 * 2;
        }
      }
      if (i2 != i1) {
        E? obj = array[i2];
        array[i2] = array[i1];
        array[i1] = obj;
      } else {
        break;
      }
    }
  }
}
