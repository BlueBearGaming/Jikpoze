part of bluebear;

class Listener {

    String name;
    String type;
    var source;

    Listener.fromJsonData(var data) {
        name = data['name'];
    }
}