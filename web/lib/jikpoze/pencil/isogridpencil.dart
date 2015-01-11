part of jikpoze;

class IsoGridPencil extends GridPencil {

	IsoGridPencil(Board board) : super(board);

	void buildGraphics(Graphics g) {
		g.moveTo(0, board.cellSize * IsoMap.skewFactor);
		g.lineTo(board.cellSize, 0);
		g.lineTo(0, -board.cellSize * IsoMap.skewFactor);
		g.lineTo(-board.cellSize, 0);
		g.lineTo(0, board.cellSize * IsoMap.skewFactor);
	}
}