part of jikpoze;

class EmptyPencil extends Pencil {
  Graphics upStateGraphics;
  Graphics overStateGraphics;

  EmptyPencil(Board board, {String name: 'empty', String type: 'events'})
      : super(board, name: name, type: type) {

    upStateGraphics = new Graphics();
    board.map.buildCellGraphics(upStateGraphics);
    upStateGraphics.strokeColor(Color.Transparent, 1);
    upStateGraphics.fillColor(Color.Transparent);

    overStateGraphics = new Graphics();
    board.map.buildCellGraphics(overStateGraphics);
    overStateGraphics.strokeColor(Color.Blue, 1);
    overStateGraphics.fillColor(Color.Blue);
  }

  DisplayObject getDisplayObject(Point point) {
    Sprite upStateSprite = new Sprite();
    upStateSprite.graphics = upStateGraphics;

    Sprite overStateSprite = new Sprite();
    overStateSprite.graphics = overStateGraphics;

    SimpleButton button = new SimpleButton(upStateSprite, overStateSprite);
    button.onAddedToStage.listen((e) {
      print(e);
    });

    return button;
  }
}
