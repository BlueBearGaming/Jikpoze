import 'dart:html';
import 'lib/board.dart';

void main() {
	CanvasElement canvas = querySelector('#canvas');
	Board board = new IsoBoard(canvas, 64);
	board.renderLoop.start();
}

