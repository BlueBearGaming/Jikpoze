part of jikpoze;

class HexBoard extends Board {

	HexBoard(Html.CanvasElement canvas, int cellSize) : super(canvas, cellSize);

	Cell createCell(point) {
		return cells[point] = new HexCell(this, point, cellSize);
	}

	int getMaxX() {
		return HexCell.getMaxX(stage.contentRectangle.width, cellSize);
	}

	int getMaxY() {
		return HexCell.getMaxY(stage.contentRectangle.height, cellSize);
	}
}