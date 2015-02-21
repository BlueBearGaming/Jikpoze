part of bluebear;

class LoadContextRequest {

	int contextId;
	static String code = "bluebear.engine.onMapLoad";

	LoadContextRequest(this.contextId);

	Object getJson() {
		return {
			"contextId": contextId,
		};
	}
}