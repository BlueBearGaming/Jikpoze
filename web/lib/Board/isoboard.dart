part of jikpoze;

class IsoBoard extends Board {

	IsoBoard(Html.CanvasElement canvas, int cellSize) : super(canvas, cellSize);

	Cell createCell(point) {
		return cells[point] = new IsoCell(this, point, cellSize);
	}

	Point gamePointToViewPoint(Point gamePoint){
		num viewX = gamePoint.x * cellSize * 2;
		num viewY = gamePoint.y * cellSize * IsoCell.skewFactor;
		if(gamePoint.y.floor() % 2 == 0) {
			viewX += cellSize;
		}
		return new Point(viewX, viewY);
	}

	Point viewPointToGamePoint(Point viewPoint){
		return new Point((viewPoint.x / cellSize / 2).floor(), (viewPoint.y / cellSize / IsoCell.skewFactor).floor());
	}

}