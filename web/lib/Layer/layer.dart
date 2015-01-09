part of jikpoze;

class Layer extends DisplayObjectContainer {
	Map map;
	Col.LinkedHashMap<Point, Cell> cells = new Col.LinkedHashMap(hashCode: Cell.getPointHashCode, equals: Cell.pointEquals);

	Layer(Map map) {
		this.map = map;
	}

	void renderCells() {
		Point topLeft = map.getTopLeftViewPoint();
		Point bottomRight = map.getBottomRightViewPoint();
		Point point;
		for (int cx = topLeft.x.floor(); cx <= bottomRight.x.floor() + 1; cx++) {
			for (int cy = topLeft.y.floor(); cy <= bottomRight.y.floor() + 1; cy++) {
				point = new Point(cx, cy);
				if (!cells.containsKey(point)) {
					map.createCell(this, point);
				} else {
					cells[point].updateCell();
					cells[point].draw();
				}
			}
		}
	}
}
