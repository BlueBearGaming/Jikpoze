part of jikpoze;

class IsoCell extends Cell {

	static double skewFactor = 0.6;

	IsoCell(Layer layer, Point position) : super(layer, position);

	void buildGraphics(Graphics g) {
		int size = layer.map.board.cellSize;
		g.moveTo(0, size * skewFactor);
		g.lineTo(size, 0);
		g.lineTo(0, -size * skewFactor);
		g.lineTo(-size, 0);
		g.lineTo(0, size * skewFactor);
	}

	void updateCell(){
		super.updateCell();
		int size = layer.map.board.cellSize;
		bitmap.y = -size * skewFactor;
		bitmap.height = size * 2 * skewFactor;
	}

	void loadBitmap() {
		bitmap = new IsoBitmap(layer.map.board.resourceManager.getBitmapData('tile'));
	}

}