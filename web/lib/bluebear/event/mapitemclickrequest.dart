part of bluebear;

class MapItemClickRequest {

    Base board;
    MapItem mapItem;
    static const String code = "bluebear.engine.mapItemClick";

    MapItemClickRequest(this.board, this.mapItem) {
        board.queryApi(MapItemClickRequest.code, json, (String responseText) {
            if (responseText.isEmpty) {
                throw "Server returned an empty string";
            }

            board.clearSelection();
            EngineEvent response = new EngineEvent.fromJson(responseText);

            Jikpoze.SelectionPencil selectionPencil = new Jikpoze.SelectionPencil(board);
            for (MapItem mapItem in (response.data as MapItemClickResponse).mapItems) {
                Jikpoze.Cell cell = board.map.createCell(board.map.layers['selection'], new Point(mapItem.x, mapItem.y), selectionPencil);
                cell.alpha = 0.3;
            }
        });
    }

    Object get json {
        return {
            "contextId": board.contextId,
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
