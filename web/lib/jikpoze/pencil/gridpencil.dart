part of jikpoze;

class GridPencil extends Pencil {

    Graphics graphics;
    static bool showCoordinates = false;

    GridPencil(Board board) : super(board, name: 'grid', type: 'grid') {
        graphics = new Graphics();
        buildGraphics(graphics);
        graphics.strokeColor(Color.Gray, 0.2);
        graphics.fillColor(Color.Transparent);
    }

    DisplayObject getDisplayObject(Point point) {
        Shape shape = new Shape();
        shape.graphics = graphics;
        if (null != point && showCoordinates) {
            return new CoordinatedGridPencil(shape, point);
        }
        return shape;
    }

    void buildGraphics(Graphics g) {
        int size = (board.cellSize / 2).floor();
        g.moveTo(size, size);
        g.lineTo(size, -size);
        g.lineTo(-size, -size);
        g.lineTo(-size, size);
        g.lineTo(size, size);
    }
}