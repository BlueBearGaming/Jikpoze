part of bluebear;

class MapUpdateRequest implements RequestInterface {
    Base board;
    List<Jikpoze.Cell> updated;
    List<Jikpoze.Cell> removed;
    String eventType;
    static const String _code = "bluebear.editor.mapUpdate";

    MapUpdateRequest(this.board, {List<Jikpoze.Cell> updated: null, List<Jikpoze.Cell> removed: null}) {
        this.updated = updated;
        this.removed = removed;
    }

    String get code => _code;

    Map get json {
        List mapItems = [];
        if (null != updated) {
            for (Jikpoze.Cell cell in updated) {
                mapItems.add({
                    "layerName": cell.layer.name,
                    "pencilName": cell.pencil.name,
                    "x": cell.position.x,
                    "y": cell.position.y
                });
            }
        }
        if (null != removed) {
            for (Jikpoze.Cell cell in removed) {
                mapItems.add({
                    "layerName": cell.layer.name,
                    "x": cell.position.x,
                    "y": cell.position.y
                });
            }
        }
        return {
            "contextId": board.contextId,
            "mapItems": mapItems
        };
    }
}
