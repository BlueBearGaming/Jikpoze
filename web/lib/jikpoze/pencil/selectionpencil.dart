part of jikpoze;

class SelectionPencil extends GridPencil {
  SelectionPencil(Board board,
      {String name: 'selection', String type: 'selection'})
      : super(board, name: name, type: type) {
    graphics.strokeColor(Color.DarkBlue, 1);
    graphics.fillColor(Color.Blue);
  }

  DisplayObject getDisplayObject(Point point) {
    Sprite sprite = super.getDisplayObject(point);
    sprite.alpha = 0.4;
    return sprite;
  }
}
