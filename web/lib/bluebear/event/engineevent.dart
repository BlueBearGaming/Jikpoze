part of bluebear;

class EngineEvent {
    String code;
    String name;
    DateTime timestamp;
    dynamic data;

    EngineEvent.fromJson(String jsonString) {
        var decoded = JSON.decode(jsonString);
        code = decoded['code'];
        name = decoded['name'];

        timestamp = new DateTime.fromMillisecondsSinceEpoch(decoded['timestamp']);

        switch (name) {
            case LoadContextRequest.code:
                data = new LoadContextResponse.fromJsonData(decoded['data']);
                break;
            default:
                throw 'Unknown event $name';
        }
    }


}