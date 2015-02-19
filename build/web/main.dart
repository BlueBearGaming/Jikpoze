import 'dart:html';
import 'lib/jikpoze/jikpoze.dart';

void main() {
	Element canvas = querySelector('#canvas_map');
	Board board = new Board(canvas, canvas.attributes['data-endpoint']);
	board.init();
}
