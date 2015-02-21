import 'dart:html';
import 'dart:convert';
import 'lib/jikpoze/jikpoze.dart';

void main() {
	Element canvas = querySelector('#canvas_map');
	Board board = new Board(canvas, JSON.decode(canvas.attributes['data-options']));
	board.init();
}
