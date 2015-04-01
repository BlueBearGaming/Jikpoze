part of bluebear;

class Pencil {
    PencilSet pencilSet;
    String name;
    String label;
    String description;
    String type;
    num imageX;
    num imageY;
    num width;
    num height;
    List<Point> boundingBox = new List<Point>();
    List<String> allowedLayerTypes = new List<String>();
    Image image;
    num spriteX;
    num spriteY;
    num spriteWidth;
    num spriteHeight;

    Pencil.fromJsonData(var data, PencilSet this.pencilSet) {
        if (null == this.pencilSet) {
            throw "Parent pencil-set cannot be null";
        }
        name = data['name'];
        label = data['label'];
        description = data['description'];
        type = data['type'];
        imageX = data['imageX'];
        imageY = data['imageY'];
        width = data['width'];
        height = data['height'];
        for (var point in data['boundingBox']) {
            boundingBox.add(new Point(point[0], point[1]));
        }
        for (String allowedLayerType in data['allowedLayerTypes']) {
            allowedLayerTypes.add(allowedLayerType);
        }
        if (null != data['image']) {
            image = new Image.fromJsonData(data['image']);
        }
        spriteX = data['spriteX'];
        spriteY = data['spriteY'];
        spriteWidth = data['spriteWidth'];
        spriteHeight = data['spriteHeight'];
    }
}