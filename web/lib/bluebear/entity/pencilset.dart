part of bluebear;

class PencilSet {

    String name;
    String label;
    List<Pencil> pencils = new List<Pencil>();

    PencilSet.fromJsonData(var data) {
        name = data['name'];
        label = data['label'];
        for (var pencil in data['pencils']) {
            pencils.add(new Pencil.fromJsonData(pencil));
        }
    }
}