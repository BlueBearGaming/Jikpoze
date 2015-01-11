part of jikpoze;

class Cell extends DisplayObjectContainer {
	Layer layer;
	Point position;
	Pencil pencil;

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
		layer.addChild(this);
		attachEvents();
		draw();
	}

	void draw() {
		clear();
		Point viewPoint = layer.map.gamePointToViewPoint(position);
		x = viewPoint.x;
		y = viewPoint.y;
		addChild(pencil.getDisplayObject(position));
	}

	void clear() {
		removeChildren();
		if (layer.contains(this)) {
			layer.removeChild(this);
		}
		removeCache();
		layer.addChild(this);
	}

	void attachEvents() {
		onMouseClick.listen((MouseEvent e){
			if(layer.map.board.dragging != null){
				return;
			}
			Layer targetLayer = layer.map.layers['land_main'];
			if (targetLayer.cells.containsKey(position)) {
				return;
			}
			layer.map.createCell(targetLayer, position, layer.map.board.pencils['grass_01']);
			targetLayer.renderCells();
		});
	}

	List<Point> getAdjacentPoints() {
		num x = position.x;
		num y = position.y;
		return [
		        new Point(x + 1, y),
		        new Point(x, y + 1),
		        new Point(x - 1, y),
		        new Point(x, y - 1),
	        ];
	}

	static int getPointHashCode(Point point) {
		return new JenkinsHasher().add(point.x).add(point.x.sign).add(point.y).add(point.y.sign).hash;
	}

	static bool pointEquals(Point k1, Point k2) {
		return Cell.getPointHashCode(k1) == Cell.getPointHashCode(k2);
	}
}
