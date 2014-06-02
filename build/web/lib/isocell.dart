part of jikpoze;

class IsoCell extends Cell {

	static double skewFactor = 0.6;

	IsoCell(Board board, Point position, int size) : super(board, position, size);

	void buildGraphics(Graphics g) {
		g.moveTo(0, size * skewFactor);
		g.lineTo(size, 0);
		g.lineTo(0, -size * skewFactor);
		g.lineTo(-size, 0);
		g.lineTo(0, size * skewFactor);
	}

	void updateCell([int size]){
		if(size != null) {
			this.size = size;
		}
		super.updateCell(size);
		bitmap.y = -size * skewFactor;
		bitmap.height = size * 2 * skewFactor;
	}

}