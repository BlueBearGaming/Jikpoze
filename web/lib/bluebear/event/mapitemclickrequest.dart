part of bluebear;

class MapItemClickRequest {

    Base board;
    MapItem mapItem;
    String eventType;
    static const String code = "bluebear.engine.mapItemClick";

    MapItemClickRequest(this.board, this.mapItem, this.eventType) {
        board.queryApi(MapItemClickRequest.code, json, board.updateMap);
    }

    Object get json {
        var json = {
            "contextId": board.contextId,
            "target": {
                "layer": mapItem.layerName,
                "position": {
                    "x": mapItem.x,
                    "y": mapItem.y
                }
            }
        };
        if (mapItem.listeners.contains(eventType)) {
            json['source'] = mapItem.listeners[eventType].source;
        }
        return json;
    }
}
