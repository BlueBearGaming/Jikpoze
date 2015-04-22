part of bluebear;

class MapItem {
    int id;
    String layerName;
    String pencilName;
    int x;
    int y;
    Map<String, Listener> listeners = new Map<String, Listener>();
    Jikpoze.Cell cell;

    MapItem.fromJsonData(Map data) {
        id = data['id'];
        layerName = data['layerName'];
        pencilName = data['pencilName'];
        x = data['x'];
        y = data['y'];
        if (data.containsKey('listeners') && !data['listeners'].isEmpty) {
            (data['listeners'] as Map).forEach((String key, Map value){
                listeners[key] = new Listener.fromJsonData(value);
            });
        }
    }
}