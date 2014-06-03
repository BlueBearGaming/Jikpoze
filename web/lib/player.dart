part of jikpoze;

class Player extends DisplayObjectContainer {
	Board board;
	Cell currentCell;
	bool selected = false;
	Bitmap bitmap;
	static double sizeFactor = 0.6;

	Player(Cell cell) {
		currentCell = cell;
		board = cell.board;
		TextureAtlas textureAtlas = board.resourceManager.getTextureAtlas("player");
		bitmap = new Bitmap(textureAtlas.getBitmapData("down-0"));
		addChild(bitmap);
		draw();
	}

	void draw() {
		int size = currentCell.size;
		bitmap.x = -size * sizeFactor;
		bitmap.y = -2.2 * size * sizeFactor;
		bitmap.height = bitmap.height * size * 2 / bitmap.width * sizeFactor;
		bitmap.width = size * 2 * sizeFactor;
		x = currentCell.x;
		y = currentCell.y;
		if (board.contains(this)) {
			board.removeChild(this);
		}
		board.addChild(this);
	}
}
