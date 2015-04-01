part of bluebear;

class PencilSet {

    String name;
    String label;
    List<Pencil> pencils = new List<Pencil>();
    Image sprite;
    String type;

    PencilSet.fromJsonData(var data) {
        name = data['name'];
        label = data['label'];
        for (var pencil in data['pencils']) {
            pencils.add(new Pencil.fromJsonData(pencil, this));
        }
        if (null != data['sprite']) {
            sprite = new Image.fromJsonData(data['sprite']);
        }
        type = data['type'];
    }
}