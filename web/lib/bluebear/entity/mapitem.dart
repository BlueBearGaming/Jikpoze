part of bluebear;

class MapItem {
    String layerName;
    String pencilName;
    Point position;
    Map<String, Listener> listeners = {};
    List<Point> path = [];
    Jikpoze.Cell cell;

    MapItem.fromJsonData(Map data) {
        layerName = data['layerName'];
        pencilName = data['pencilName'];
        position = new Point(data['position']['x'], data['position']['y']);
        if (data.containsKey('listeners') && !data['listeners'].isEmpty) {
            (data['listeners'] as Map).forEach((String key, Map value){
                listeners[key] = new Listener.fromJsonData(value);
            });
        }
        if (data.containsKey('path') && !data['path'].isEmpty) {
            for (Map position in data['path'] as List) {
                path.add(new Point(position['x'], position['y']));
            }
        }
    }
}