part of bluebear;

// Name "Map" conflicts with core class "Map"
class BlueBearMap {

    String name;
    String label;
    String type;
    int cellSize = 128;
    List<Layer> layers = new List<Layer>();
    List<PencilSet> pencilSets = new List<PencilSet>();

    BlueBearMap.fromJsonData(var data) {
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