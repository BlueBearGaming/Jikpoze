part of bluebear;

class MapItem {
    int id;
    String layerName;
    String pencilName;
    int x;
    int y;
    List<String> listeners;
    Jikpoze.Cell cell;

    MapItem.fromJsonData(var data) {
        id = data['id'];
        layerName = data['layerName'];
        pencilName = data['pencilName'];
        x = data['x'];
        y = data['y'];
        listeners = data['listeners'];
    }
}