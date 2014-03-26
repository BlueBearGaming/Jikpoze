part of jikpoze;

class HexCell extends Cell {

	HexCell(Board board, Point position, int size) : super(board, position, size);

	void buildGraphics(Graphics g) {
		int numberOfSides = 6; // hexagon
		num a = Math.PI / 2;
		num size = this.size / Math.cos(a + 2 * Math.PI / numberOfSides);
		g.moveTo(size * Math.cos(a), size * Math.sin(a));
		for (int i = 1; i <= numberOfSides; i++) {
		    g.lineTo(size * Math.cos(a + i * 2 * Math.PI / numberOfSides), size * Math.sin(a + i * 2 * Math.PI / numberOfSides));
		}
	}

	Point gamePointToViewPoint(Point gamePoint){
		num viewX = gamePoint.x * size * 2;
		num viewY = gamePoint.y * size * Math.cos(Math.PI/6) * 2;
		if(gamePoint.y.floor() % 2 == 0) {
			viewX += size;
		}
		return new Point(viewX, viewY);
	}

	static int getMaxX(num width, int size){
		return (width / size / 4).floor();
	}

	static int getMaxY(num height, int size){
		return (height / size / Math.cos(Math.PI/6) / 4).floor();
	}

	List<Point> getAdjacentPoints() {
		num x = position.x;
		num y = position.y;
		List<Point> points = [
			new Point(x + 1, y),
			new Point(x - 1, y),
			new Point(x, y + 1),
			new Point(x, y - 1),
		];
		if(y.floor() % 2 == 0) {
			points.add(new Point(x + 1, y - 1));
			points.add(new Point(x + 1, y + 1));
		} else {
			points.add(new Point(x - 1, y - 1));
			points.add(new Point(x - 1, y + 1));
		}
     	return points;
	}
}