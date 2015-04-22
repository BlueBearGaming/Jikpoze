part of bluebear;

class MapUpdateResponse implements ResponseInterface {
    List<MapItem> updated = new List<MapItem>();
    List<MapItem> removed = new List<MapItem>();

    handleResponse(Map data) {
        if (data.containsKey('updated')) {
            for (var item in data['updated']) {
                updated.add(new MapItem.fromJsonData(item));
            }
        }
        if (data.containsKey('removed')) {
            for (var item in data['removed']) {
                removed.add(new MapItem.fromJsonData(item));
            }
        }
        EventEngine.instance.board.loadMapItems(updated);
        // @todo handle deletion
    }
}
