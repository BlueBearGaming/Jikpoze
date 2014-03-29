part of jikpoze;

class Player extends DisplayObjectContainer {
	Board board;
	Cell currentCell;
	bool selected = false;
	Bitmap bitmap;

	Player(Cell cell){
		currentCell = cell;
		board = cell.board;
		TextureAtlas textureAtlas = board.resourceManager.getTextureAtlas("player");
		bitmap = new Bitmap(textureAtlas.getBitmapData("down-0"));
		addChild(bitmap);
		draw();
	}

	void draw(){
		int size = currentCell.size;
		bitmap.x = -size;
		bitmap.y = -size - size;
		bitmap.height = bitmap.height * size * 2 / bitmap.width;
		bitmap.width = size * 2;
		x = currentCell.x;
		y = currentCell.y;
		if(board.contains(this)) {
			board.removeChild(this);
		}
		board.addChild(this);
	}
}
