part of jikpoze;

class Pencil {

	Board board;
	BlueBear.Pencil pencil;

	Pencil(this.board) {
		if (null == board) {
			throw 'board cannot be null';
		}
	}

	Pencil.fromBlueBearPencil(this.board, this.pencil) {
		if (null == board) {
			throw 'board cannot be null';
		}
		if (null != pencil.image) {
			board.resourceManager.addBitmapData('image.' + pencil.name, 'resources/' + pencil.image.fileName);
		}
	}

	DisplayObject getDisplayObject(Point point) {
		Bitmap bitmap = new HitboxBitmap(getBitmapData());
		updateBitmap(bitmap);
		return bitmap;
	}

	void updateBitmap(Bitmap bitmap) {
		int size = board.cellSize;
		bitmap.width = size * pencil.width;
		bitmap.height = size * pencil.height;
		bitmap.x = size * pencil.imageX - bitmap.width / 2;
		bitmap.y = size * pencil.imageY - bitmap.height / 2;
	}

	BitmapData getBitmapData() {
		return board.resourceManager.getBitmapData('image.' + pencil.name);
	}
}