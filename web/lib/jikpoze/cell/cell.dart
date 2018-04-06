part of jikpoze;

class Cell extends DisplayObjectContainer {
  Layer layer;
  SquareMap map;
  Point position;
  Pencil pencil;
  int zIndex = 0;

  Cell(this.layer, this.position, this.pencil) {
    if (null == layer) {
      throw "layer cannot be null";
    }
    if (null == position) {
      throw "position cannot be null";
    }
    if (null == pencil) {
      throw "pencil cannot be null";
    }
    layer.cells[position] = this;
    map = layer.map;
    map.addChild(this);
    draw();
  }

  void draw() {
    Point viewPoint = layer.map.gamePointToViewPoint(position);
    x = viewPoint.x;
    y = viewPoint.y;
    DisplayObject child = pencil.getDisplayObject(position);
    addChild(child);
  }

  static int getPointHashCode(Point point) {
    return new JenkinsHasher()
        .add(point.x)
        .add(point.x.sign)
        .add(point.y)
        .add(point.y.sign)
        .hash;
  }

  static bool pointEquals(Point k1, Point k2) {
    return Cell.getPointHashCode(k1) == Cell.getPointHashCode(k2);
  }
}
