part of jikpoze;

class HexBoard extends Board {

	HexBoard(Html.CanvasElement canvas, int cellSize) : super(canvas, cellSize);

	void renderCells(){
		int maxX = HexCell.getMaxX(stage.contentRectangle.width, cellSize);
		int maxY = HexCell.getMaxY(stage.contentRectangle.height, cellSize);
		Point point;
		for(int x = -maxX; x <= maxX; x++) {
			for(int y = -maxY; y <= maxY; y++) {
				point = new Point(x, y);
				cells[point] = new HexCell(this, point, cellSize);
			}
		}
	}
}