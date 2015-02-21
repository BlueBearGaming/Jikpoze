part of bluebear;

class Map {

	String name;
	String label;
	String type;
	int cellSize = 128;
	List<Layer> layers = new List<Layer>();
	List<PencilSet> pencilSets = new List<PencilSet>();

	Map.fromJsonData(var data) {
		name = data['name'];
		label = data['label'];
		type = data['type'];
		cellSize = data['cellSize'];
		for (var layer in data['layers']) {
			layers.add(new Layer.fromJsonData(layer));
		}
		for (var pencilSet in data['pencilSets']) {
			pencilSets.add(new PencilSet.fromJsonData(pencilSet));
		}
	}
}