library jikpoze;

import 'dart:html' as Html;
import 'dart:collection';
import 'dart:math' as Math;
import 'package:stagexl/stagexl.dart';
import 'jenkinshasher.dart';

part 'hexboard.dart';
part 'cell.dart';
part 'hexcell.dart';

class Board {

	Html.CanvasElement canvas;
	Stage stage;
	RenderLoop renderLoop;
	Map<Point, Cell> cells = new LinkedHashMap(hashCode: Cell.getPointHashCode, equals: Cell.pointEquals);
	int cellSize;

	Board(Html.CanvasElement canvas, int cellSize){
		this.canvas = canvas;
		stage = new Stage(canvas);
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		renderLoop = new RenderLoop();
		renderLoop.addStage(stage);
		this.cellSize = cellSize;
		renderCells();
		attachEvents();
	}

	void attachEvents(){
		onResizeEvent(Event e){
			renderCells();
		}
		stage.onResize.listen(onResizeEvent);
	}

	void renderCells(){
		int maxX = Cell.getMaxX(stage.contentRectangle.width, cellSize);
		int maxY = Cell.getMaxY(stage.contentRectangle.height, cellSize);
		Point point;
		for(int x = -maxX; x <= maxX; x++) {
			for(int y = -maxY; y <= maxY; y++) {
				point = new Point(x, y);
				if(!cells.containsKey(point)){
					cells[point] = createCell(point);
				}
			}
		}
	}

	Cell createCell(point) {
		return new Cell(this, point, cellSize);
	}
}