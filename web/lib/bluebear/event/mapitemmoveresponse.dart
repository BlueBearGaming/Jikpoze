part of bluebear;

class MapItemMoveResponse extends MapUpdateResponse {
  handleResponse(Map data) {
    super.handleResponse(data);
    EventEngine.instance.board.clearSelection();
  }
}
