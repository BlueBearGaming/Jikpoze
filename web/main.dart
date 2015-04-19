import 'dart:html';
import 'dart:convert';
import 'lib/bluebear/bluebear.dart';

void main() {
    Element canvas = querySelector('#canvas_map');
    new Editor(canvas, JSON.decode(canvas.attributes['data-options']));
}
