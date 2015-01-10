part of jikpoze;

class Cell extends DisplayObjectContainer {
	Layer layer;
	Point position;
	BlueBear.Pencil pencil;
	Shape shape;
	List<Cell> adjacentCells = new List<Cell>();
	bool selected = false;
	bool mouseOver = false;
	Bitmap bitmap;

	Cell(this.layer, this.position, this.pencil) {
		layer.addChild(this);
		loadBitmap();
		addChild(bitmap);
		updateCell();
		draw();
	}

	void updateCell() {
		int size = layer.map.board.cellSize;
		Point viewPoint = layer.map.gamePointToViewPoint(position);
		x = viewPoint.x;
		y = viewPoint.y;
		bitmap.x = -size;
		bitmap.y = -size;
		bitmap.width = size * 2;
		bitmap.height = size * 2;
	}

	void draw() {
		int size = layer.map.board.cellSize;
		clear();
		buildGraphics(shape.graphics);
		shape.applyCache(-size - 5, -size - 5, size * 2 + 10, size * 2 + 10);
	}

	void clear() {
		if (shape != null) {
			shape.graphics.clear();
			removeChild(shape);
		}
		if (layer.contains(this)) {
			layer.removeChild(this);
		}
		removeCache();
		shape = new Shape();
		addChild(shape);
		layer.addChild(this);
	}

	void buildGraphics(Graphics g) {
		int size = layer.map.board.cellSize;
		g.moveTo(size, size);
		g.lineTo(size, -size);
		g.lineTo(-size, -size);
		g.lineTo(-size, size);
		g.lineTo(size, size);
	}

	void loadBitmap() {
		bitmap = new Bitmap(getBitmapData());
	}

	BitmapData getBitmapData() {
		return layer.map.board.resourceManager.getBitmapData('image.' + pencil.name);
	}

	List<Point> getAdjacentPoints() {
		num x = position.x;
		num y = position.y;
		return [new Point(x + 1, y), new Point(x, y + 1), new Point(x - 1, y), new Point(x, y - 1),];
	}

	List<Cell> getAdjacentCells() {
		if (adjacentCells.isNotEmpty) {
			return adjacentCells;
		}
		for (Point point in getAdjacentPoints()) {
			if (layer.cells.containsKey(point)) {
				adjacentCells.add(layer.cells[point]);
			} else {
				// Create and append
			}
		}
		return adjacentCells;
	}

	static int getPointHashCode(Point point) {
		return new JenkinsHasher().add(point.x).add(point.x.sign).add(point.y).add(point.y.sign).hash;
	}

	static bool pointEquals(Point k1, Point k2) {
		return Cell.getPointHashCode(k1) == Cell.getPointHashCode(k2);
	}
}
