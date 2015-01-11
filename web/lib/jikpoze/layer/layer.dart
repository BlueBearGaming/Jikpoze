part of jikpoze;

class Layer extends DisplayObjectContainer {
	SquareMap map;
	int index;
	Col.LinkedHashMap<Point, Cell> cells = new Col.LinkedHashMap(hashCode: Cell.getPointHashCode, equals: Cell.pointEquals);

	Layer(this.map, this.index) {
		if (null == map) {
			throw 'map cannot be null';
		}
		if (null == index) {
			map.addChild(this);
		} else {
			map.addChildAt(this, index);
		}
	}

	void renderCells() {
		Point topLeft = map.board.getTopLeftViewPoint();
		Point bottomRight = map.board.getBottomRightViewPoint();
		Point point;
		for (int cy = topLeft.y.floor(); cy <= bottomRight.y.floor() + 1; cy++) {
			for (int cx = topLeft.x.floor(); cx <= bottomRight.x.floor() + 1; cx++) {
				point = new Point(cx, cy);
				if (cells.containsKey(point)) {
					cells[point].draw();
				}
			}
		}
	}

}
