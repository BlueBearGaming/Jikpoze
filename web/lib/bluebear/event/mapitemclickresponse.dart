part of bluebear;

class MapItemClickResponse {
    List<MapItem> mapItems = new List();

    MapItemClickResponse.fromJsonData(var data) {
        for (var item in data) {
            mapItems.add(new MapItem.fromJsonData(item));
        }
    }
}