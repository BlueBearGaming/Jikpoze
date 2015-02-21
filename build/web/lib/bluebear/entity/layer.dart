part of bluebear;

class Layer {

	String name;
	String label;
	String type;
	String description;
  	int index;

	Layer.fromJsonData(var data) {
		name = data['name'];
		label = data['label'];
		type = data['type'];
		description = data['description'];
		index = data['index'];
	}
}