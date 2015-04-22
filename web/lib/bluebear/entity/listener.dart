part of bluebear;

class Listener {
    String name;
    Point source;

    Listener.fromJsonData(Map data) {
        name = data['name'];
        if (data.containsKey('source')) {
            source = new Point(data['source']['x'], data['source']['y']);
        }
    }
}