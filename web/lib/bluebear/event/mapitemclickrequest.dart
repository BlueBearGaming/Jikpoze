part of bluebear;

class MapItemClickRequest {
    MapItem mapItem;
    String eventType;
    static const String code = "bluebear.engine.mapItemClick";

    MapItemClickRequest(this.mapItem, this.eventType) {
        EventEngine.instance.queryApi(MapItemClickRequest.code, json);
    }

    Map get json {
        Map json = {
            "contextId": EventEngine.instance.board.contextId,
            "target": {
                "layer": mapItem.layerName,
                "position": {
                    "x": mapItem.x,
                    "y": mapItem.y
                }
            }
        };
        if (mapItem.listeners.containsKey(eventType)) {
            json['source'] = mapItem.listeners[eventType].source;
        }
        return json;
    }
}
