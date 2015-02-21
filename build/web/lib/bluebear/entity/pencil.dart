part of bluebear;

class Pencil {

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

	Pencil.fromJsonData(var data) {
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
		image = new Image.fromJsonData(data['image']);
	}
}