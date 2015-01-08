import 'dart:html';
import 'lib/game.dart';

void main() {
	CanvasElement canvas = querySelector('#canvas');
	Board board = new IsoBoard(canvas, 64);

	var request = HttpRequest.getString("/resources/map.json").then(board.loadMap);

	board.renderLoop.start();
}

