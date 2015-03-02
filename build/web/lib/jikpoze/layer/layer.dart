part of jikpoze;

class Layer {
    SquareMap map;
    String type;
    int index;
    BlueBear.Layer layer;
    Col.LinkedHashMap<Point, Cell> cells = new Col.LinkedHashMap(hashCode: Cell.getPointHashCode, equals: Cell.pointEquals);

    Layer(this.map, this.type, this.index) {
        if (null == map) {
            throw 'map cannot be null';
        }
        if (null == type) {
            throw 'type cannot be null';
        }
    }
}
