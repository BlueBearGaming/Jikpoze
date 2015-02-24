part of jikpoze;

class IsoMap extends SquareMap {

    IsoMap(Board board) : super(board) {
        skewFactor = 0.3;
    }

    Pencil getGridPencil() {
        if (null == gridPencil) {
            gridPencil = new IsoGridPencil(board);
        }
        return gridPencil;
    }

    void renderLayer(Layer layer) {
        Point topLeft = board.getTopLeftViewPoint();
        Point bottomRight = board.getBottomRightViewPoint();
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

    Point gamePointToViewPoint(Point gamePoint) {
        num viewX = (gamePoint.x - gamePoint.y) * board.cellSize / 2;
        num viewY = (gamePoint.x + gamePoint.y) * board.cellSize * skewFactor;
        return new Point(viewX, viewY);
    }

    Point viewPointToGamePoint(Point viewPoint) {
        num gameX = (viewPoint.y / 2 / skewFactor + viewPoint.x) / board.cellSize;
        num gameY = (viewPoint.y / 2 / skewFactor - viewPoint.x) / board.cellSize;
        return new Point(gameX.floor(), gameY.floor());
    }
}