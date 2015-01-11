part of jikpoze;

class IsoMap extends HexMap {

	static double skewFactor = 0.6;
	num gameToViewYFactor = skewFactor;
	num viewToGameYFactor = skewFactor;

	IsoMap(Board board) : super(board);

	Point gamePointToViewPoint(Point gamePoint){
		num viewX = gamePoint.x * board.cellSize * 2;
		num viewY = gamePoint.y * board.cellSize * skewFactor;
		if(gamePoint.y.floor() % 2 == 0) {
			viewX += board.cellSize;
		}
		return new Point(viewX, viewY);
	}

	Point viewPointToGamePoint(Point viewPoint){
		return new Point((viewPoint.x / board.cellSize / 2).floor(), (viewPoint.y / board.cellSize / skewFactor).floor());
	}

	Pencil getGridPencil() {
		if (null == gridPencil) {
			gridPencil = new IsoGridPencil(board);
		}
		return gridPencil;
	}
}