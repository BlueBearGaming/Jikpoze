part of jikpoze;

class HexMap extends Map {

	num gameToViewYFactor = Math.cos(Math.PI/6) * 2;
	num viewToGameYFactor = Math.cos(Math.PI/6) / 2;

	HexMap(Board board) : super(board);

	Cell createCell(Layer layer, Point point, BlueBear.Pencil pencil) =>
			layer.cells[point] = new HexCell(layer, point, pencil);

	Point gamePointToViewPoint(Point gamePoint){
		num viewX = gamePoint.x * board.cellSize * 2;
		num viewY = gamePoint.y * board.cellSize * gameToViewYFactor;
		if(gamePoint.y.floor() % 2 == 0) {
			viewX += board.cellSize;
		}
		return new Point(viewX, viewY);
	}

	Point viewPointToGamePoint(Point viewPoint){
		return new Point(
				(viewPoint.x / board.cellSize / 2).floor(),
				(viewPoint.y / board.cellSize / viewToGameYFactor).floor()
			);
	}
}
