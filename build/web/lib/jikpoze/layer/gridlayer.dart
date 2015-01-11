part of jikpoze;

class GridLayer extends Layer {

	BlueBear.Pencil pencil;

	GridLayer(SquareMap map, int index) : super (map, index);

	void renderCells() {
		removeChildren();
		Point topLeft = map.board.getTopLeftViewPoint();
		Point bottomRight = map.board.getBottomRightViewPoint();
		Point point;
		for (int cx = topLeft.x.floor(); cx <= bottomRight.x.floor() + 1; cx++) {
			for (int cy = topLeft.y.floor(); cy <= bottomRight.y.floor() + 1; cy++) {
				point = new Point(cx, cy);
				map.createCell(this, point, map.getGridPencil());
			}
		}
	}
}
