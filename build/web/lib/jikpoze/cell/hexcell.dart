part of jikpoze;

class HexCell extends Cell {

    HexCell(Layer layer, Point position, Pencil pencil) : super(layer, position, pencil);

    List<Point> getAdjacentPoints() {
        num x = position.x;
        num y = position.y;
        List<Point> points = [
            new Point(x + 1, y),
            new Point(x - 1, y),
            new Point(x, y + 1),
            new Point(x, y - 1),
        ];
        if (y.floor() % 2 == 0) {
            points.add(new Point(x + 1, y - 1));
            points.add(new Point(x + 1, y + 1));
        } else {
            points.add(new Point(x - 1, y - 1));
            points.add(new Point(x - 1, y + 1));
        }
        return points;
    }
}