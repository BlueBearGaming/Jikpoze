part of jikpoze;

/**
 * This is the main class of the game, it handles the creation
 * of the stage and the creation of the cells.
 */
class Board extends DisplayObjectContainer {

	Html.CanvasElement canvas;
	RenderLoop renderLoop;
	SquareMap map;
	BlueBear.Context context;
	Col.LinkedHashMap<String, Pencil> pencils = new Col.LinkedHashMap<String, Pencil>();
	Cell selected;
	int cellSize;
	MouseEvent dragMouseEvent;
	Point dragging;
	ResourceManager resourceManager = new ResourceManager();
	String endPoint;
	static int maxZoom = 128;
	static int minZoom = 42;
	static int zoomIncrement = 5;
	bool editionMode = true;

	Board(this.canvas, this.endPoint) {
		if (null == canvas) {
			throw "Canvas cannot be null";
		}
		if (null == endPoint) {
			throw "EndPoint cannot be null";
		}
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

	void renderCells() => map.renderCells();

	void init() {
		var request = Html.HttpRequest.getString(endPoint).then(loadMap);
	}

	void loadMap(String responseText) {
		// Todo interrogate engine properly
		BlueBear.EngineEvent response = new BlueBear.EngineEvent.fromJson(responseText);
		BlueBear.LoadContextResponse contextResponse = response.data;
		context = contextResponse.context;

		BlueBear.Map contextMap = context.map;

		// Load right type of Map
		switch (contextMap.type) {
			case 'hexagonal':
			case 'hex':
				map = new HexMap(this);
				break;
			case 'isometric':
			case 'iso':
				map = new IsoMap(this);
				break;
			default:
				map = new SquareMap(this);
		}
		map.name = 'map.' + contextMap.name;
		cellSize = 64; // @todo load from contextMap

		// Create layers
		for (BlueBear.Layer contextLayer in contextMap.layers) {
			Layer layer = new Layer(map, contextLayer.index);
			layer.name = 'layer.' + contextLayer.name;
			map.layers[contextLayer.name] = layer;
		}

		if (editionMode) {
			Layer layer = new GridLayer(map, map.layers.length - 1);
			layer.name = 'layer.edition';
			map.layers['edition'] = layer;
		}

		for (BlueBear.PencilSet pencilSet in contextMap.pencilSets) {
			for (BlueBear.Pencil pencil in pencilSet.pencils) {
				pencils[pencil.name] = new Pencil.fromBlueBearPencil(this, pencil);
			}
		}

		resourceManager.load().then((res){
			for (BlueBear.MapItem mapItem in context.mapItems) {
				Layer layer = map.layers[mapItem.layerName];
				Pencil pencil = pencils[mapItem.pencilName];
				if (null == layer) {
					throw 'No layer found: ${mapItem.layerName}';
				}
				if (null == pencil) {
					throw 'No pencil found: ${mapItem.pencilName}';
				}
				map.createCell(layer, new Point(mapItem.x, mapItem.y), pencil);
			}
			renderCells();
			attachEvents();
		});
	}

	Point getTopLeftViewPoint() =>
			map.viewPointToGamePoint(stage.contentRectangle.topLeft.subtract(new Point(x, y)));

	Point getBottomRightViewPoint() =>
			map.viewPointToGamePoint(stage.contentRectangle.bottomRight.subtract(new Point(x, y)));

}