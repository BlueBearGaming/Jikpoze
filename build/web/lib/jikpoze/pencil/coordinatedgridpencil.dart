part of jikpoze;

class CoordinatedGridPencil extends DisplayObjectContainer {

    CoordinatedGridPencil(Shape shape, Point point) {
        addChild(shape);
        TextFormat format = new TextFormat('Monospace', 10, Color.LightGray);
        TextField coordinates = new TextField('${point.x},${point.y}', format);
        coordinates.x = -10;
        coordinates.y = -5;
        addChild(coordinates);
    }
}