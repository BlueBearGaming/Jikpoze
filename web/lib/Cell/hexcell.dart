part of jikpoze;

class HexCell extends Cell {

	HexCell(Layer layer, Point position) : super(layer, position);

	void buildGraphics(Graphics g) {
		int numberOfSides = 6; // hexagon
		num a = Math.PI / 2;
		num size = layer.map.board.cellSize / Math.cos(a + 2 * Math.PI / numberOfSides);
		g.moveTo(size * Math.cos(a), size * Math.sin(a));
		for (int i = 1; i <= numberOfSides; i++) {
		    g.lineTo(size * Math.cos(a + i * 2 * Math.PI / numberOfSides), size * Math.sin(a + i * 2 * Math.PI / numberOfSides));
		}
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