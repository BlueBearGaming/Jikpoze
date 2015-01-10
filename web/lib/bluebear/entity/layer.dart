part of bluebear;

class Layer {

	String name;
	String label;
	String description;
  	int index;

	Layer.fromJsonData(var data) {
		name = data['name'];
		label = data['label'];
		description = data['description'];
		index = data['index'];
	}
}