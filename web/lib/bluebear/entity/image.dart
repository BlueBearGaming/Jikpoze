part of bluebear;

class Image {
  String name;
  String fileName;

  Image.fromJsonData(var data) {
    name = data['name'];
    fileName = data['fileName'];
  }
}
