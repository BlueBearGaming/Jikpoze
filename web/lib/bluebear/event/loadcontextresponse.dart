part of bluebear;

class LoadContextResponse implements ResponseInterface {
  EventEngine eventEngine;
  Context context;

  handleResponse(Map data) {
    context = new Context.fromJsonData(data);
    EventEngine.instance.board.loadContext(context);
  }
}
