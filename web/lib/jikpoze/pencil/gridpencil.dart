part of jikpoze;

class GridPencil extends Pencil {

	GridPencil(Board board) : super(board);

	DisplayObject getDisplayObject() {
		Shape shape = new Shape();
		int size = board.cellSize;
		buildGraphics(shape.graphics);
		shape.graphics.strokeColor(Color.Gray, 0.2);
		//shape.applyCache(-size - 5, -size - 5, size * 2 + 10, size * 2 + 10);
		return shape;
	}

	void buildGraphics(Graphics g) {
		g.moveTo(board.cellSize, board.cellSize);
		g.lineTo(board.cellSize, -board.cellSize);
		g.lineTo(-board.cellSize, -board.cellSize);
		g.lineTo(-board.cellSize, board.cellSize);
		g.lineTo(board.cellSize, board.cellSize);
	}
}