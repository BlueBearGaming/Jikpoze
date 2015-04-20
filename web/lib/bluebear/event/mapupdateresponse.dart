part of bluebear;

class MapUpdateResponse {
    List<MapItem> updated = new List<MapItem>();

    MapUpdateResponse.fromJsonData(Jikpoze.Board board, Map data) {
        if (data.containsKey('updated')) {
            for (var item in data['updated']) {
                updated.add(new MapItem.fromJsonData(item));
            }
        }
    }
}