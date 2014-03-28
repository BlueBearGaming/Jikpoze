library jikpoze;

import 'dart:html' as Html;
import 'dart:collection';
import 'dart:math' as Math;
import 'package:stagexl/stagexl.dart';
import 'jenkinshasher.dart';

part 'hexboard.dart';
part 'cell.dart';
part 'hexcell.dart';

class Board extends DisplayObjectContainer {

	Html.CanvasElement canvas;
	RenderLoop renderLoop;
	Map<Point, Cell> cells = new LinkedHashMap(hashCode: Cell.getPointHashCode, equals: Cell.pointEquals);
	int cellSize;
	Cell selected;
	Point startDrag;

	Board(Html.CanvasElement canvas, int cellSize){
		this.canvas = canvas;
		Stage stage = new Stage(canvas, webGL: false);
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		renderLoop = new RenderLoop();
		renderLoop.addStage(stage);
		stage.addChild(this);
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
		onMouseDownEvent(MouseEvent e){
			startDrag = new Point(e.stageX + x, e.stageY + y);
		}
		stage.onMouseDown.listen(onMouseDownEvent);
		onMouseUpEvent(MouseEvent e){
			startDrag = null;
		}
		stage.onMouseUp.listen(onMouseUpEvent);
		onMouseMoveEvent(MouseEvent e){
			if (startDrag != null) {
				x = e.stageX - startDrag.x;
				y = e.stageY - startDrag.y;
			}
			renderCells();
		}
		stage.onMouseMove.listen(onMouseMoveEvent);
	}

	void renderCells(){
		for(Cell cell in cells.values) {
			cell.updateCell(cellSize);
		}
		Point topLeft = viewPointToGamePoint(stage.contentRectangle.topLeft.add(new Point(x, y)));
		Point bottomRight = viewPointToGamePoint(stage.contentRectangle.bottomRight.add(new Point(x, y)));
		Point point;
		for(int cx = topLeft.x.floor(); cx <= bottomRight.x.floor(); cx++) {
			for(int cy = topLeft.y.floor(); cy <= bottomRight.y.floor(); cy++) {
				point = new Point(cx, cy);
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

	Point gamePointToViewPoint(Point gamePoint){
		return new Point(gamePoint.x * cellSize * 2, gamePoint.y * cellSize * 2);
	}

	Point viewPointToGamePoint(Point viewPoint){
		return new Point((viewPoint.x / cellSize / 2).floor(), (viewPoint.y / cellSize / 2).floor());
	}
}