part of jikpoze;

class EmptyPencil extends Pencil {
  Graphics overStateGraphics;

  EmptyPencil(Board board, {String name: 'empty', String type: 'events'})
      : super(board, name: name, type: type) {
    overStateGraphics = new Graphics();
    board.map.buildCellGraphics(overStateGraphics);
    overStateGraphics.strokeColor(Color.DarkBlue, 1);
    overStateGraphics.fillColor(Color.Blue);
  }

  DisplayObject getDisplayObject(Point point) {
    Sprite overStateSprite = new Sprite();
    overStateSprite.graphics = overStateGraphics;
    overStateSprite.alpha = 0.4;

    Shape hitTestState = new Shape();
    hitTestState.graphics = overStateGraphics;

    SimpleButton button =
        new SimpleButton(null, overStateSprite, null, hitTestState);

    return button;
  }
}
