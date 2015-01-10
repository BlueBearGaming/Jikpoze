part of bluebear;

class LoadContextResponse {
	Context context;

	LoadContextResponse.fromJsonData(var data) {
		context = new Context.fromJsonData(data['context']);
	}
}