part of jikpoze;

class GridPencil extends Pencil {

    Graphics graphics;
    static bool showCoordinates = false;

    GridPencil(Board board) : super(board, name: 'grid', type: 'grid') {
        graphics = new Graphics();
        board.map.buildCellGraphics(graphics);
        graphics.strokeColor(Color.Gray, 0.2);
        graphics.fillColor(Color.Transparent);
    }

    DisplayObject getDisplayObject(Point point) {
        Sprite sprite = new Sprite();
        sprite.graphics = graphics;
        if (null != point && showCoordinates) {
            sprite.addChild(getCoordinates(point));
        }
        return sprite;
    }

    TextField getCoordinates(Point point) {
        TextFormat format = new TextFormat('Monospace', 10, Color.LightGray);
        TextField coordinates = new TextField('${point.x},${point.y}', format);
        coordinates.x = -10;
        coordinates.y = -5;
        return coordinates;
    }
}