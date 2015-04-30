part of bluebear;

class MapItemClickRequest {
    MapItem mapItem;
    Listener listener;
    static const String code = "bluebear.engine.mapItemClick";

    MapItemClickRequest(this.mapItem) {
        if (!mapItem.listeners.containsKey('click')) {
            throw 'No listener configured for click';
        }
        listener = mapItem.listeners['click'];
        EventEngine.instance.queryApi(listener.name, json);
    }

    Map get json {
        Map json = {
            "contextId": EventEngine.instance.board.contextId,
            "target": {
                "layer": mapItem.layerName,
                "position": {
                    "x": mapItem.position.x,
                    "y": mapItem.position.y
                }
            }
        };
        if (null != listener.source) {
            json['source'] = listener.source;
        }
        return json;
    }
}
