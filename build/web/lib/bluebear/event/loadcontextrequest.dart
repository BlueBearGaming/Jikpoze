part of bluebear;

class LoadContextRequest {

    int contextId;
    static const String code = "bluebear.engine.mapLoad";

    LoadContextRequest(this.contextId);

    Object getJson() {
        return {
            "contextId": contextId,
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
}
