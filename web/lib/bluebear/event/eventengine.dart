part of bluebear;

class EventEngine {
    Base board;
    String code;
    String name;
    DateTime timestamp;
    ResponseInterface response;
    SocketIoClient socket;
    static EventEngine instance;

    EventEngine(this.board) {
        instance = this;
        SocketIoClient socket = new SocketIoClient(board.socketIOUri);
        socket.onConnect((){
            print('[SocketIO] Connected to ${board.socketIOUri}');
            socket.onDisconnect(() {
                print('[SocketIO] Disconnected');
            });

            socket.on('bluebear.engine.clientUpdate', (message) {
                try {
                    handleResponse(message['event']);
                } catch (e) {
                    print('Error during handleResponse: ');
                    print(message);
                    throw e;
                }
            });
        });
    }

    Html.HttpRequest queryApi(String eventName, Object json) {
        Html.HttpRequest request = new Html.HttpRequest(); // create a new XHR
        // add an event handler that is called when the request finishes
        request.onReadyStateChange.listen((_) {
            if (request.readyState == Html.HttpRequest.DONE) {
                if (request.status == 200 || request.status == 0) {
                    handleResponse(request.responseText);
                } else {
                    throw "Unexpected error: ${request.responseText}";
                }
            }
        });

        // POST the data to the server
        String finalEndPoint = board.endPoint + eventName;
        request.open("POST", finalEndPoint);
        request.send(JSON.encode(json)); // perform the async POST
        return request;
    }

    handleResponse(String jsonString) {
        if (jsonString.isEmpty) {
            throw "Server responded with an empty string";
        }
        var decoded = JSON.decode(jsonString);
        code = decoded['code'];
        name = decoded['name'];

        if ('error' == code) {
            throw "API returned an error: ${decoded['message']}";
        }

        DateTime timestamp = new DateTime.fromMillisecondsSinceEpoch(decoded['timestamp']);
        if (timestamp == this.timestamp) {
            return;
        }
        this.timestamp = timestamp;
        print("Received '${name}' at ${timestamp.toIso8601String()}");
        switch (name) {
            case LoadContextRequest.code:
                response = new LoadContextResponse();
                break;
            case MapItemClickRequest.code:
                response = new MapItemClickResponse();
                break;
            case MapUpdateRequest.code:
                response = new MapUpdateResponse();
                break;
            case 'bluebear.engine.mapItemMove':
                response = new MapItemMoveResponse();
                break;
            default:
                print(decoded);
                throw 'Unknown event $name';
        }
        response.handleResponse(decoded['data']);
    }
}