part of jikpoze;

/**
 * This is the main class of the game, it handles the creation
 * of the stage and the creation of the cells.
 */
class Board extends DisplayObjectContainer {

	Html.CanvasElement canvas;
	RenderLoop renderLoop;
	Map map;
	Cell selected;
	int cellSize;
	MouseEvent dragMouseEvent;
	Point dragging;
	ResourceManager resourceManager = new ResourceManager();
	String endPoint;
	static int maxZoom = 128;
	static int minZoom = 42;
	static int zoomIncrement = 5;

	Board(Html.CanvasElement canvas, String endPoint) {
		this.canvas = canvas;
		this.endPoint = endPoint;
		Stage stage = new Stage(canvas, webGL: false);
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		renderLoop = new RenderLoop();
		renderLoop.addStage(stage);
		stage.addChild(this);
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
		map.renderCells();
	}

	void init() {
		var request = Html.HttpRequest.getString(endPoint).then(loadMap);
	}

	void loadMap(String responseText) {
		var data = JSON.decode(responseText);
		print(data);
		cellSize = 64;
//		resourceManager.addBitmapData('tile', 'resources/isometric_grass_big.png');
//		resourceManager.addTextureAtlas('player', 'resources/player-01.json', TextureAtlasFormat.JSON);
//		resourceManager.load().then((res){
//			renderCells();
//			player = new Player(layers['units'].cells[new Point(10,10)]);
//			attachEvents();
//		});
	}
}