part of jikpoze;

class HexMap extends SquareMap {
  HexMap(Board board) : super(board) {
    skewFactor = Math.cos(Math.PI / 6);
  }

  Point gamePointToViewPoint(Point gamePoint) {
    num viewX = gamePoint.x * board.cellSize;
    num viewY = gamePoint.y * board.cellSize * skewFactor;
    if (gamePoint.y.floor() % 2 == 0) {
      viewX += board.cellSize / 2;
    }
    return new Point(viewX, viewY);
  }

  Point viewPointToGamePoint(Point viewPoint) {
    num x = viewPoint.x;
    num y = viewPoint.y;
    int gameX = (x / board.cellSize).round();
    int gameY = (y / board.cellSize / skewFactor).round();
    if (0 == gameY % 2) {
      gameX = ((x - board.cellSize / 2) / board.cellSize).round();
    }
    return new Point(gameX, gameY);
  }

  void buildCellGraphics(Graphics g) {
    int numberOfSides = 6; // hexagon
    num a = Math.PI / 2;
    num size = board.cellSize / Math.cos(a + 2 * Math.PI / numberOfSides) / 2;
    g.moveTo(size * Math.cos(a), size * Math.sin(a));
    for (int i = 1; i <= numberOfSides; i++) {
      g.lineTo(size * Math.cos(a + i * 2 * Math.PI / numberOfSides),
          size * Math.sin(a + i * 2 * Math.PI / numberOfSides));
    }
    g.closePath();
  }
}
