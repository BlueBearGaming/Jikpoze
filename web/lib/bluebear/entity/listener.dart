part of bluebear;

class Listener {
  String name;
  var source;

  Listener.fromJsonData(Map data) {
    name = data['name'];
    if (data.containsKey('source') && null != data['source']) {
      source = data['source'];
    }
  }
}
