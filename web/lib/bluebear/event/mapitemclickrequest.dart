part of bluebear;

class MapItemClickRequest implements RequestInterface {
    Base board;
    MapItem mapItem;
    String eventType;
    static const String _code = "bluebear.engine.mapItemClick";

    MapItemClickRequest(this.board, this.mapItem, this.eventType);

    String get code => _code;

    Map get json {
        Map json = {
            "contextId": board.contextId,
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
