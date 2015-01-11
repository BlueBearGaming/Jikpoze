import 'dart:html';
import 'lib/jikpoze/jikpoze.dart';

void main() {
	Board board = new Board(querySelector('#canvas_square'), "resources/map.json");
	board.init();
	Board isoboard = new Board(querySelector('#canvas_iso'), "resources/isomap.json");
	isoboard.init();
	Board hexboard = new Board(querySelector('#canvas_hex'), "resources/hexmap.json");
	hexboard.init();
}
