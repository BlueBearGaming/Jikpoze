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
	Cell selected;

	Board(Html.CanvasElement canvas, int cellSize){
		this.canvas = canvas;
		stage = new Stage(canvas, webGL: false);
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
		onScaleEvent(MouseEvent e){
			if(e.deltaY.isNegative){
				if(cellSize < 100){
					cellSize += 10;
					renderCells();
				}
			} else if(cellSize > 20) {
				cellSize -= 10;
				renderCells();
			}
		}
		stage.onMouseWheel.listen(onScaleEvent);
	}

	void renderCells(){
		for(Cell cell in cells.values) {
			cell.updateCell(cellSize);
		}
		int maxX = getMaxX();
		int maxY = getMaxY();
		Point point;
		for(int x = -maxX; x <= maxX; x++) {
			for(int y = -maxY; y <= maxY; y++) {
				point = new Point(x, y);
				if(!cells.containsKey(point)){
					createCell(point);
				}
			}
		}
		updateSelected();
	}

	Cell createCell(point) {
		return cells[point] = new Cell(this, point, cellSize);
	}

	int getMaxX() {
		return Cell.getMaxX(stage.contentRectangle.width, cellSize);
	}

	int getMaxY() {
		return Cell.getMaxY(stage.contentRectangle.height, cellSize);
	}

	void select(Cell cell){
		if(selected != null) {
			Cell oldCell = selected;
			selected = null;
			oldCell.updateCell();
		}
		selected = cell;
		selected.draw();
	}

	void updateSelected(){
		if(selected != null) {
			selected.draw();
		}
	}
}