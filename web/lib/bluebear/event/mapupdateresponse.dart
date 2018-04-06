part of bluebear;

class MapUpdateResponse implements ResponseInterface {
  List<MapItem> updated = new List<MapItem>();
  List<MapItem> removed = new List<MapItem>();
  List<MapItem> moved = new List<MapItem>();

  handleResponse(Map data) {
    if (data.containsKey('clearSelection') && data['clearSelection']) {
      EventEngine.instance.board.clearSelection();
    }
    if (data.containsKey('removed')) {
      for (var item in data['removed']) {
        MapItem mapItem = new MapItem.fromJsonData(item);
        mapItem.pencilName = null;
        removed.add(mapItem);
      }
    }
    EventEngine.instance.board.loadMapItems(removed);

    if (data.containsKey('updated')) {
      for (var item in data['updated']) {
        updated.add(new MapItem.fromJsonData(item));
      }
    }
    EventEngine.instance.board.loadMapItems(updated);

    if (data.containsKey('moved')) {
      for (var item in data['moved']) {
        removed.add(new MapItem.fromJsonData(item));
      }
    }
    EventEngine.instance.board.loadMapItems(moved);
  }
}
