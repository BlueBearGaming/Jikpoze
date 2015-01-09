import 'dart:html';
import 'lib/game.dart';

void main() {
	CanvasElement canvas = querySelector('#canvas');

	Board board = new Board(canvas, "/resources/map.json");
	board.init();
}
