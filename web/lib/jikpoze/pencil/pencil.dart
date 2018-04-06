part of jikpoze;

class Pencil {
  Board board;
  BitmapData bitmapData;
  String name;
  String type;
  num width;
  num height;
  num imageX;
  num imageY;

  Pencil(this.board,
      {String name,
      String type,
      num width,
      num height,
      num imageX,
      num imageY}) {
    if (null == board) {
      throw 'board cannot be null';
    }
    if (null == name) {
      throw 'name cannot be null';
    }
    this.name = name;
    this.type = type;
    this.width = width;
    this.height = height;
    this.imageX = imageX;
    this.imageY = imageY;
    board.pencils[name] = this;
  }

  DisplayObject getDisplayObject(Point point) {
    Bitmap bitmap = new HitboxBitmap(bitmapData);
    updateBitmap(bitmap);
    return bitmap;
  }

  void updateBitmap(Bitmap bitmap) {
    int size = board.cellSize;
    bitmap.width = size * width;
    bitmap.height = size * height;
    bitmap.x = size * imageX - bitmap.width / 2;
    bitmap.y = size * imageY - bitmap.height / 2;
  }
}
