part of bluebear;

class EngineEvent {
    Jikpoze.Board board;
    String code;
    String name;
    DateTime timestamp;
    dynamic data;

    EngineEvent.fromJson(this.board, String jsonString) {
        var decoded = JSON.decode(jsonString);
        code = decoded['code'];
        name = decoded['name'];

        timestamp = new DateTime.fromMillisecondsSinceEpoch(decoded['timestamp']);

        switch (name) {
            case LoadContextRequest.code:
                data = new LoadContextResponse.fromJsonData(board, decoded['data']);
                break;
            case MapItemClickRequest.code:
                data = new MapItemClickResponse.fromJsonData(board, decoded['data']);
                break;
            default:
                throw 'Unknown event $name';
        }
    }


}