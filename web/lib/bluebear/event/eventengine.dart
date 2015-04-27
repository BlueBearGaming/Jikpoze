part of bluebear;

class EventEngine {
    Base board;
    List<Handle> handlers = [];

    EventEngine(this.board);

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
        String code = decoded['code'];
        String name = decoded['name'];

        if ('error' == code) {
            throw "API returned an error: ${decoded['message']}";
        }

        DateTime timestamp = new DateTime.fromMillisecondsSinceEpoch(decoded['timestamp']);

        for (Handle callback in handlers) {
            ResponseInterface response = callback(code);
            if (null != response) {
                response.handleResponse(decoded['data']);
            }
        }
    }
}