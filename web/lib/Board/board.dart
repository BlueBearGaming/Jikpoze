part of jikpoze;

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
	static int maxZoom = 128;
	static int minZoom = 42;
	static int zoomIncrement = 5;

	Board(Html.CanvasElement canvas, int cellSize) {
		this.canvas = canvas;
		Stage stage = new Stage(canvas, webGL: false);
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		renderLoop = new RenderLoop();
		renderLoop.addStage(stage);
		stage.addChild(this);
		this.cellSize = cellSize;
		resourceManager.addBitmapData('tile', 'resources/isometric_grass_big.png');
		resourceManager.addTextureAtlas('player', 'resources/player-01.json', TextureAtlasFormat.JSON);
		resourceManager.load().then((res){
			renderCells();
			player = new Player(cells[new Point(10,10)]);
			attachEvents();
		});
	}

	void attachEvents() {
		onResizeEvent(Event e){
			renderCells();
		}
		stage.onResize.listen(onResizeEvent);
		onScaleEvent(MouseEvent e){
			if(e.deltaY.isNegative){
				if(cellSize < maxZoom){
					cellSize += zoomIncrement;
					renderCells();
				}
			} else if(cellSize > minZoom) {
				cellSize -= zoomIncrement;
				if(cellSize < minZoom){
					cellSize = minZoom;
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

	void renderCells() {
		Point topLeft = getTopLeftViewPoint();
		Point bottomRight = getBottomRightViewPoint();
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

	void select(Cell cell) {
		if(selected != null) {
			Cell oldCell = selected;
			selected = null;
			oldCell.draw();
		}
		selected = cell;
		print(cell.position);
		updateSelected();
	}

	void updateSelected() {
		if(selected != null) {
			selected.draw();
		}
		if(player != null){
			player.draw();
		}
	}

	Point gamePointToViewPoint(Point gamePoint) {
		return new Point(gamePoint.x * cellSize * 2, gamePoint.y * cellSize * 2);
	}

	Point viewPointToGamePoint(Point viewPoint) {
		return new Point((viewPoint.x / cellSize / 2).floor(), (viewPoint.y / cellSize / 2).floor());
	}

	Point getTopLeftViewPoint() {
		return viewPointToGamePoint(stage.contentRectangle.topLeft.subtract(new Point(x, y)));
	}

	Point getBottomRightViewPoint() {
		return viewPointToGamePoint(stage.contentRectangle.bottomRight.subtract(new Point(x, y)));
	}

}