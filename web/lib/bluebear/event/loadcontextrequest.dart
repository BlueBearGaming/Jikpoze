part of bluebear;

class LoadContextRequest {
    static const String code = "bluebear.engine.mapLoad";

    LoadContextRequest() {
        EventEngine.instance.queryApi(LoadContextRequest.code, json);
    }

    Map get json => {
        "contextId": EventEngine.instance.board.contextId,
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
