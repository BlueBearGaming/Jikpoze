
import 'dart:html' as Html;
import 'dart:math' as Math;
import 'package:stagexl/stagexl.dart';

void main() {
	Html.CanvasElement canvas = Html.querySelector('#canvas');
	Board board = new HexagonBoard(canvas, 200);
	board.renderLoop.start();
}

class Board {

	Html.CanvasElement canvas;
	Stage stage;
	RenderLoop renderLoop;
	List<Cell> cells;
	int cellSize;

	Board(Html.CanvasElement canvas, int cellSize){
		this.canvas = canvas;
		stage = new Stage(canvas);
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		renderLoop = new RenderLoop();
		renderLoop.addStage(stage);
		this.cellSize = cellSize;
		renderCells(cellSize);
	}

	void renderCells(int cellSize){

	}
}

class HexagonBoard extends Board {

	HexagonBoard(Html.CanvasElement canvas, int cellSize) : super(canvas, cellSize);

	void renderCells(int cellSize){
		int maxX = (stage.contentRectangle.width / cellSize / 4).round();
		int maxY = (stage.contentRectangle.height / cellSize / 7 * 2).round();
		for(int x = -maxX; x <= maxX; x++) {
			for(int y = -maxY; y <= maxY; y++) {
				num coordX = stage.contentRectangle.center.x + x * cellSize * 2;
				if(y % 2 == 0){
					coordX += cellSize;
				}
				num coordY = stage.contentRectangle.center.y + y * cellSize * 7 / 4;
				Point point = new Point(coordX, coordY);
				Cell cell = new HexagonCell(this, point, cellSize);
			}
		}
	}
}

class Cell extends DisplayObjectContainer {
	Board board;
	Point position;
	int size;
	Shape shape;
	List<Cell> adjacentCells;

	Cell(Board board, Point position, int size){
		this.board = board;
		this.position = position;
		this.size = size;
		x = position.x;
		y = position.y;
		draw();
		addChild(shape);
		attachEvents();
		this.board.stage.addChild(this);
	}

	void attachEvents(){
		mouseOverEvent(MouseEvent e){
			shape.graphics.fillColor(Color.Black);
		}
		onMouseOver.listen(mouseOverEvent);
		mouseOutEvent(MouseEvent e){
			shape.graphics.fillColor(Color.White);
		}
		onMouseOut.listen(mouseOutEvent);
	}

	void draw(){

	}
}

class HexagonCell extends Cell {

	HexagonCell(Board board, Point position, int size) : super(board, position, size);

	void draw(){
		shape = new Shape();
		Graphics g = shape.graphics;
		int numberOfSides = 6; // hexagon
		num a = Math.PI / 2;
		num size = this.size / Math.cos(a + 2 * Math.PI / numberOfSides);
		g.moveTo(size * Math.cos(a), size * Math.sin(a));
		for (int i = 1; i <= numberOfSides; i++) {
		    g.lineTo(size * Math.cos(a + i * 2 * Math.PI / numberOfSides), size * Math.sin(a + i * 2 * Math.PI / numberOfSides));
		}
		g.strokeColor(Color.Black, 0.5);
		g.fillColor(Color.White);
	}
}
