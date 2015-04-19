part of bluebear;

class MapItemClickRequest {

    int contextId;
    MapItem mapItem;
    static const String code = "bluebear.engine.mapItemClick";

    MapItemClickRequest(this.contextId, this.mapItem);

    Object getJson() {
        return {
            "contextId": contextId,
            "x": mapItem.x,
            "y": mapItem.y,
            "pencil": mapItem.pencilName,
            "layer": mapItem.layerName,
            "source": {
                "position": {
                    "x": mapItem.x,
                    "y": mapItem.y
                }
            },
            "target": {
                "position": {
                    "x": mapItem.x,
                    "y": mapItem.y
                }
            }
        };
    }
}
