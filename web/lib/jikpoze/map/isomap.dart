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

    void _doRenderCells() {
        for (Layer layer in layers.values) {
            for (Cell cell in layer.cells.values) {
                cell.clear();
            }
            Point topLeft = board.getTopLeftViewPoint();
            Point bottomRight = board.getBottomRightViewPoint();
            int rankSize = ((bottomRight.x - topLeft.x) / 2).floor();
            for (int rank = -renderOffset; rank <= rankSize + renderOffset; rank++) {
                for (int col = -renderOffset; col <= rankSize + renderOffset; col++) {
                    int posX = topLeft.x.floor() + col + rank;
                    int posY = topLeft.y.floor() - col + rank;
                    print('[$posX, $posY] (rank: $rank, col: $col)');
                    renderCell(layer, new Point(posX, posY - 1));
                    renderCell(layer, new Point(posX, posY));
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
        num gameX = (viewPoint.y / 2 / skewFactor + viewPoint.x) / board.cellSize;
        num gameY = (viewPoint.y / 2 / skewFactor - viewPoint.x) / board.cellSize;
        return new Point(gameX.floor(), gameY.floor());
    }
}