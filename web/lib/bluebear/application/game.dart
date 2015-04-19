part of bluebear;

/**
 * This is the main class of the game, it handles the creation
 * of the stage and the creation of the cells.
 */
class Game extends Base {

    Game(canvas, Col.LinkedHashMap options) : super(canvas, options);


    void attachStageEvents() {
        super.attachStageEvents();

        map.onMouseClick.listen((MouseEvent e) {
            if (dragging != null) {
                return;
            }
            // remove large mouse offset
            if (e.stageX - 2 > dragMouseEvent.stageX || dragMouseEvent.stageX > e.stageX + 2) {
                return;
            }
            if (e.stageY - 2 > dragMouseEvent.stageY || dragMouseEvent.stageY > e.stageY + 2) {
                return;
            }

            //Point position = viewPointToGamePoint(new Point(e.stageX, e.stageY));

            clearSelection();
        });
    }

    void clearSelection() {
        map.layers['selection'].clear();
    }

    void attachMapItemEvents(MapItem mapItem) {
        if (null == mapItem.cell) {
            // This means the object has no representation on the board for some reason (check logs)
            return;
        }
        if (!mapItem.listeners.contains('selectionable')) {
            return;
        }
        mapItem.cell.onMouseClick.listen((MouseEvent e) {
            if (dragging != null) {
                return;
            }
            // remove large mouse offset
            if (e.stageX - 2 > dragMouseEvent.stageX || dragMouseEvent.stageX > e.stageX + 2) {
                return;
            }
            if (e.stageY - 2 > dragMouseEvent.stageY || dragMouseEvent.stageY > e.stageY + 2) {
                return;
            }

            e.stopImmediatePropagation();
            MapItemClickRequest mapItemClickRequest = new MapItemClickRequest(contextId, mapItem);
            queryApi(MapItemClickRequest.code, mapItemClickRequest.getJson(), (String responseText) {
                if (responseText.isEmpty) {
                    throw "Server returned an empty string";
                }

                clearSelection();
                EngineEvent response = new EngineEvent.fromJson(responseText);

                Jikpoze.GridPencil selectionPencil = map.getGridPencil(true);
                selectionPencil.type = 'selection';
                selectionPencil.graphics.strokeColor(Color.DarkBlue, 1);
                selectionPencil.graphics.fillColor(Color.Blue);
                for (MapItem mapItem in (response.data as MapItemClickResponse).mapItems) {
                    Jikpoze.Cell cell = map.createCell(map.layers['selection'], new Point(mapItem.x, mapItem.y), selectionPencil);
                    cell.alpha = 0.3;
                }
            });
        });
    }


}