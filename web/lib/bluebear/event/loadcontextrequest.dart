part of bluebear;

class LoadContextRequest implements RequestInterface {
    Base board;
    static const String _code = "bluebear.engine.mapLoad";

    LoadContextRequest(this.board);

    String get code => _code;

    Map get json => {
        "contextId": board.contextId,
        "userContext": {
            "viewCenter": {
                "x": 0,
                "y": 0
            }
        },
        "loadContext": {
            "topLeft": {
                "x": -20,
                "y": -20
            },
            "bottomRight": {
                "x": 20,
                "y": 20
            }
        }
    };
}
