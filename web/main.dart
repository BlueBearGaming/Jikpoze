import 'dart:html';
import 'dart:convert';
import 'lib/bluebear/bluebear.dart' as BlueBear;

void main() {
  Element canvas = querySelector('#canvas_map');
  Map options = JSON.decode(canvas.attributes['data-options']);
  if (options.containsKey('edition') && true == options['edition']) {
    new BlueBear.Editor(canvas, options);
  } else {
    new BlueBear.Game(canvas, options);
  }
}
