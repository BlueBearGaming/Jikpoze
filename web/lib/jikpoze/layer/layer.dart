part of jikpoze;

class Layer {
    String name;
    SquareMap map;
    String type;
    int index;
    Col.LinkedHashMap<Point, Cell> cells = new Col.LinkedHashMap(hashCode: Cell.getPointHashCode, equals: Cell.pointEquals);

    Layer(this.map, this.name, this.type, this.index) {
        if (null == map) {
            throw 'map cannot be null';
        }
        if (null == type) {
            throw 'type cannot be null';
        }
        map.layers[name] = this;
        if (type == 'grid') {
            map.updateGrid();
        }
    }
}
