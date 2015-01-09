part of jikpoze;

class IsoMap extends Map {

	IsoMap(Board board) : super(board);

	Cell createCell(Layer layer, Point point) {
		return layer.cells[point] = new IsoCell(layer, point);
	}

	Point gamePointToViewPoint(Point gamePoint){
		num viewX = gamePoint.x * board.cellSize * 2;
		num viewY = gamePoint.y * board.cellSize * IsoCell.skewFactor;
		if(gamePoint.y.floor() % 2 == 0) {
			viewX += board.cellSize;
		}
		return new Point(viewX, viewY);
	}

	Point viewPointToGamePoint(Point viewPoint){
		return new Point((viewPoint.x / board.cellSize / 2).floor(), (viewPoint.y / board.cellSize / IsoCell.skewFactor).floor());
	}

}