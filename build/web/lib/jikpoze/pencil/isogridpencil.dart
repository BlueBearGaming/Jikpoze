part of jikpoze;

class IsoGridPencil extends GridPencil {

	IsoGridPencil(Board board) : super(board);

	void buildGraphics(Graphics g) {
		num size = board.cellSize / 2;
		num skewFactor = board.map.skewFactor * 2;
		g.moveTo(0, size * skewFactor);
		g.lineTo(size, 0);
		g.lineTo(0, -size * skewFactor);
		g.lineTo(-size, 0);
		g.lineTo(0, size * skewFactor);
	}
}