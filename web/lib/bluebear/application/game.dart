part of bluebear;

/**
 * This is the main class of the game, it handles the creation
 * of the stage and the creation of the cells.
 */
class Game extends Base {
    Game(canvas, Map options) : super(canvas, options);

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

    void attachMapItemEvents(MapItem mapItem) {
        if (null == mapItem.cell) {
            // This means the object has no representation on the board for some reason (check logs)
            return;
        }
        if (!mapItem.listeners.containsKey('click')) {
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

            // Launch event
            new MapItemClickRequest(mapItem, 'click');
        });
    }
}