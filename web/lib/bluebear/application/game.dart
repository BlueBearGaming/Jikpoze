part of bluebear;

/**
 * This is the main class of the game, it handles the creation
 * of the stage and the creation of the cells.
 */
class Game extends Base {
  Game(canvas, Map options) : super(canvas, options);

  void attachStageEvents() {
    super.attachStageEvents();

    clickEvent(InputEvent e) {
      if (dragging != null) {
        return;
      }
      // remove large mouse offset
      if (e.stageX - 2 > dragEvent.stageX || dragEvent.stageX > e.stageX + 2) {
        return;
      }
      if (e.stageY - 2 > dragEvent.stageY || dragEvent.stageY > e.stageY + 2) {
        return;
      }

      //Point position = viewPointToGamePoint(new Point(e.stageX, e.stageY));

      clearSelection();
    }

    map.onTouchTap.listen(clickEvent);
    map.onMouseClick.listen(clickEvent);
  }

  void attachMapItemEvents(MapItem mapItem) {
    if (null == mapItem.cell) {
      // This means the object has no representation on the board for some reason (check logs)
      return;
    }
    if (!mapItem.listeners.containsKey('click')) {
      return;
    }
    clickEvent(InputEvent e) {
      if (dragging != null) {
        return;
      }
      // remove large mouse offset
      if (e.stageX - 2 > dragEvent.stageX || dragEvent.stageX > e.stageX + 2) {
        return;
      }
      if (e.stageY - 2 > dragEvent.stageY || dragEvent.stageY > e.stageY + 2) {
        return;
      }

      e.stopImmediatePropagation();

      new MapItemClickRequest(mapItem);
    }

    mapItem.cell.onTouchTap.listen(clickEvent);
    mapItem.cell.onMouseClick.listen(clickEvent);
  }
}
