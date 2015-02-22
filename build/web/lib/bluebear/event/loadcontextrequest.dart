part of bluebear;

class LoadContextRequest {

    int contextId;
    static const String code = "bluebear.engine.mapLoad";

    LoadContextRequest(this.contextId);

    Object getJson() {
        return {
            "contextId": contextId,
        };
    }
}