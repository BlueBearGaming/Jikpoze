part of bluebear;

class Context {
  int id;
  String label;
  BlueBearMap map;
  List<MapItem> mapItems = new List<MapItem>();

  Context.fromJsonData(var data) {
    id = data['id'];
    label = data['label'];
    map = new BlueBearMap.fromJsonData(data['map']);
    if (null != data['mapItems']) {
      for (var mapItem in data['mapItems']) {
        mapItems.add(new MapItem.fromJsonData(mapItem));
      }
    }
  }
}
