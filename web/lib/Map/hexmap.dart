part of jikpoze;

class HexMap extends Map {

	HexMap(Board board) : super(board);

	Cell createCell(Layer layer, Point point) {
		return layer.cells[point] = new HexCell(layer, point);
	}

	Point gamePointToViewPoint(Point gamePoint){
		num viewX = gamePoint.x * board.cellSize * 2;
		num viewY = gamePoint.y * board.cellSize * Math.cos(Math.PI/6) * 2;
		if(gamePoint.y.floor() % 2 == 0) {
			viewX += board.cellSize;
		}
		return new Point(viewX, viewY);
	}

	Point viewPointToGamePoint(Point viewPoint){
		return new Point((viewPoint.x / board.cellSize / 2).floor(), (viewPoint.y / board.cellSize / Math.cos(Math.PI/6) / 2).floor());
	}
}
