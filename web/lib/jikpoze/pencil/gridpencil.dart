part of jikpoze;

class GridPencil extends Pencil {

	GridPencil(Board board) : super(board);

	DisplayObject getDisplayObject(Point point) {
		Shape shape = new Shape();
		buildGraphics(shape.graphics);
		shape.graphics.strokeColor(Color.Gray, 0.2);
		shape.graphics.fillColor(Color.Transparent);
		if (null != point) {
			return new CoordinatedGridPencil(shape, point);
		}
		return shape;
	}

	void buildGraphics(Graphics g) {
		int size = (board.cellSize / 2).floor();
		g.moveTo(size, size);
		g.lineTo(size, -size);
		g.lineTo(-size, -size);
		g.lineTo(-size, size);
		g.lineTo(size, size);
	}
}