part of jikpoze;

class HexMap extends SquareMap {

    HexMap(Board board) : super(board) {
        skewFactor = Math.cos(Math.PI / 6);
    }

    Pencil _createGridPencil() {
        return new HexGridPencil(board);
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
        return new Point(
            (viewPoint.x / board.cellSize).floor(),
            (viewPoint.y / board.cellSize / skewFactor).floor()
        );
    }
}
