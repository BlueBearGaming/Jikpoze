import 'dart:html';
import 'lib/jikpoze/jikpoze.dart';

void main() {
	CanvasElement canvas = querySelector('#canvas');

	Board board = new Board(canvas, "/resources/map.json");
	board.init();
}
