import 'dart:html';
import 'lib/board.dart';

void main() {
	CanvasElement canvas = querySelector('#canvas');
	Board board = new Board(canvas, 16);
	board.renderLoop.start();
}

