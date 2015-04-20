part of jikpoze;

class IsoMap extends SquareMap {

    IsoMap(Board board) : super(board) {
        skewFactor = 0.3;
    }

    void updateGrid() {
        for (Layer layer in layers.values) {
            if (layer.type == 'grid') {
                Point topLeft = viewPointToGamePoint(cacheViewPort.topLeft);
                Point bottomRight = viewPointToGamePoint(cacheViewPort.bottomRight);
                int dist = (bottomRight.distanceTo(topLeft) / 2).ceil();
                int x = topLeft.x.floor();
                int y = topLeft.y.floor();
                for (int line = 0; line < dist * 2; line++) {
                    renderLayerLine(layer, x, y, x + dist, y - dist);
                    if (0 == line % 2) {
                        x++;
                    } else {
                        y++;
                    }
                }
            }
        }
    }

    Point gamePointToViewPoint(Point gamePoint) {
        num viewX = (gamePoint.x - gamePoint.y) * board.cellSize / 2;
        num viewY = (gamePoint.x + gamePoint.y) * board.cellSize * skewFactor;
        return new Point(viewX, viewY);
    }

    Point viewPointToGamePoint(Point viewPoint) {
        num x = viewPoint.x;
        num y = viewPoint.y + board.cellSize / 4;
        num gameX = (y / 2 / skewFactor + x) / board.cellSize;
        num gameY = (y / 2 / skewFactor - x) / board.cellSize;
        return new Point(gameX.floor(), gameY.floor());
    }

    void buildCellGraphics(Graphics g) {
        num size = board.cellSize / 2;
        num skewFactor = board.map.skewFactor * 2;
        g.moveTo(0, size * skewFactor);
        g.lineTo(size, 0);
        g.lineTo(0, -size * skewFactor);
        g.lineTo(-size, 0);
        g.lineTo(0, size * skewFactor);
    }
}