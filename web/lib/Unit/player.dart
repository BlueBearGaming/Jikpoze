part of jikpoze;

class Player extends DisplayObjectContainer {
	Board board;
	Cell currentCell;
	bool selected = false;
	bool mouseOver = false;
	Bitmap bitmap;
	static double sizeFactor = 0.6;

	Player(Cell cell) {
		currentCell = cell;
		board = cell.board;
		TextureAtlas textureAtlas = board.resourceManager.getTextureAtlas("player");
		bitmap = new Bitmap(textureAtlas.getBitmapData("down-0"));
		addChild(bitmap);
		draw();
		attachEvents();
	}

	void attachEvents() {
		void mouseOverEvent(MouseEvent e) {
			mouseOver = true;
			draw();
			board.updateSelected();
		}
		onMouseOver.listen(mouseOverEvent);
		void mouseOutEvent(MouseEvent e) {
			mouseOver = false;
			draw();
			board.updateSelected();
		}
		onMouseOut.listen(mouseOutEvent);
		void mouseClickEvent(MouseEvent e) {
			MouseEvent o = board.dragMouseEvent;
			if (o == null) {
				board.select(this.currentCell);
				return;
			}
			if (o.stageX == e.stageX && o.stageY == e.stageY) {
				board.select(this.currentCell);
			}
		}
		onMouseClick.listen(mouseClickEvent);
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
