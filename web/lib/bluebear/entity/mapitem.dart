part of bluebear;

class MapItem {
    int id;
    String layerName;
    String pencilName;
    int x;
    int y;
    Jikpoze.Cell cell;

    MapItem.fromJsonData(var data) {
        id = data['id'];
        layerName = data['layerName'];
        pencilName = data['pencilName'];
        x = data['x'];
        y = data['y'];
    }
}