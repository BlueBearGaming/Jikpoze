library jikpoze;

import 'dart:html' as Html;
import 'dart:collection';
import 'dart:math' as Math;
import 'package:stagexl/stagexl.dart';
import 'jenkinshasher.dart';

part 'hexboard.dart';
part 'cell.dart';
part 'hexcell.dart';
part 'player.dart';

/**
 * This is the main class of the game, it handles the creation
 * of the stage and the creation of the cells.
 */
class Board extends DisplayObjectContainer {

	Html.CanvasElement canvas;
	RenderLoop renderLoop;
	Map<Point, Cell> cells = new LinkedHashMap(hashCode: Cell.getPointHashCode, equals: Cell.pointEquals);
	int cellSize;
	Cell selected;
	MouseEvent dragMouseEvent;
	Point dragging;
	ResourceManager resourceManager = new ResourceManager();
	Player player;

	Board(Html.CanvasElement canvas, int cellSize){
		this.canvas = canvas;
		Stage stage = new Stage(canvas, webGL: false);
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		renderLoop = new RenderLoop();
		renderLoop.addStage(stage);
		stage.addChild(this);
		this.cellSize = cellSize;
		resourceManager.addBitmapData('tile', 'resources/grass-01.png');
		resourceManager.addTextureAtlas('player', 'resources/player-01.json', TextureAtlasFormat.JSON);
		resourceManager.load().then((res){
			renderCells();
			player = new Player(cells[new Point(10,10)]);
			attachEvents();
		});
	}

	void attachEvents(){
		onResizeEvent(Event e){
			renderCells();
		}
		stage.onResize.listen(onResizeEvent);
		onScaleEvent(MouseEvent e){
			if(e.deltaY.isNegative){
				if(cellSize < 40){
					cellSize += 10;
					renderCells();
				}
			} else if(cellSize > 16) {
				cellSize -= 10;
				if(cellSize < 16){
					cellSize = 16;
				}
				renderCells();
			}
		}
		stage.onMouseWheel.listen(onScaleEvent);
		onMouseDownEvent(MouseEvent e){
			dragMouseEvent = e;
			dragging = new Point(e.stageX, e.stageY);
		}
		stage.onMouseDown.listen(onMouseDownEvent);
		onMouseUpEvent(MouseEvent e){
			dragging = null;
		}
		stage.onMouseUp.listen(onMouseUpEvent);
		onMouseMoveEvent(MouseEvent e){
			if (dragging != null) {
				x += e.stageX - dragging.x;
				y += e.stageY - dragging.y;
				dragging = new Point(e.stageX, e.stageY);
				renderCells();
			}
		}
		stage.onMouseMove.listen(onMouseMoveEvent);
	}

	void renderCells(){
		Point topLeft = viewPointToGamePoint(stage.contentRectangle.topLeft.subtract(new Point(x, y)));
		Point bottomRight = viewPointToGamePoint(stage.contentRectangle.bottomRight.subtract(new Point(x, y)));
		Point point;
		for(int cx = topLeft.x.floor(); cx <= bottomRight.x.floor() + 1; cx++) {
			for(int cy = topLeft.y.floor(); cy <= bottomRight.y.floor() + 1; cy++) {
				point = new Point(cx, cy);
				if(!cells.containsKey(point)){
					createCell(point);
				} else {
					if(cells[point].size != cellSize) {
						cells[point].updateCell(cellSize);
						cells[point].draw();
        			}
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
			oldCell.draw();
		}
		selected = cell;
		print(cell.position);
		selected.draw();
	}

	void updateSelected(){
		if(selected != null) {
			selected.draw();
		}
		if(player != null){
			player.draw();
		}
	}

	Point gamePointToViewPoint(Point gamePoint){
		return new Point(gamePoint.x * cellSize * 2, gamePoint.y * cellSize * 2);
	}

	Point viewPointToGamePoint(Point viewPoint){
		return new Point((viewPoint.x / cellSize / 2).floor(), (viewPoint.y / cellSize / 2).floor());
	}
}