part of bluebear;

class MapUpdateRequest {
  List<Jikpoze.Cell> updated;
  List<Jikpoze.Cell> removed;
  String eventType;
  static const String code = "bluebear.editor.mapUpdate";

  MapUpdateRequest(
      {List<Jikpoze.Cell> updated: null, List<Jikpoze.Cell> removed: null}) {
    this.updated = updated;
    this.removed = removed;
    EventEngine.instance.queryApi(MapUpdateRequest.code, json);
  }

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
      "contextId": EventEngine.instance.board.contextId,
      "mapItems": mapItems
    };
  }
}
