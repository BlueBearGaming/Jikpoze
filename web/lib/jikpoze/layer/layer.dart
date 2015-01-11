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
		for (Cell cell in cells.values) {
			cell.draw();
		}
	}

}
