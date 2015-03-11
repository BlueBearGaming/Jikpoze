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
    String resourceBasePath;
    String layerSelectorName;
    String pencilSelectorName;
    int contextId;
    bool editionMode = true;
    bool showGrid = true;

    Board(this.canvas, Col.LinkedHashMap options) {
        if (null == canvas) {
            throw "Canvas cannot be null";
        }
        parseOptions(options);
        Stage stage = new Stage(canvas, webGL: false);
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        renderLoop = new RenderLoop();
        renderLoop.addStage(stage);
        stage.addChild(this);
    }

    void attachEvents() {
        stage.onMouseWheel.listen((MouseEvent e) {
            if (e.deltaY.isNegative) {
				scaleX*=1.1;
				scaleY*=1.1;
            } else {
				scaleX*=0.9;
			    scaleY*=0.9;
            }
        });

        stage.onMouseDown.listen((MouseEvent e) {
            dragMouseEvent = e;
            dragging = new Point(e.stageX, e.stageY);
        });


        stage.onMouseUp.listen((MouseEvent e) {
            dragging = null;
            map.updateGrid();
            //map.updateCells(); //@todo: query missing cells
        });

        stage.onMouseMove.listen((MouseEvent e) {
            if (dragging != null) {
                x += e.stageX - dragging.x;
                y += e.stageY - dragging.y;
                dragging = new Point(e.stageX, e.stageY);
            }
        });
        addButton();
    }

    void parseOptions(Col.LinkedHashMap options) {
        if (options.containsKey('endPoint')) {
            endPoint = options['endPoint'];
        } else {
            throw "Option 'endPoint' cannot be null";
        }
        if (options.containsKey('contextId')) {
            contextId = options['contextId'];
        } else {
            throw "Option 'contextId' cannot be null";
        }
        if (options.containsKey('resourceBasePath')) {
            resourceBasePath = options['resourceBasePath'];
        }
        if (options.containsKey('editionMode')) {
            editionMode = options['editionMode'];
        }
        if (options.containsKey('layerSelectorName')) {
            layerSelectorName = options['layerSelectorName'];
        }
        if (options.containsKey('pencilSelectorName')) {
            pencilSelectorName = options['pencilSelectorName'];
        }
    }

    void init() {
        BlueBear.LoadContextRequest contextRequest = new BlueBear.LoadContextRequest(contextId);
        queryApi(BlueBear.LoadContextRequest.code, contextRequest.getJson(), loadMap);
    }

    Html.HttpRequest queryApi(String eventName, Object json, Function handler) {
        Html.HttpRequest request = new Html.HttpRequest(); // create a new XHR
        // add an event handler that is called when the request finishes
        request.onReadyStateChange.listen((_) {
            if (request.readyState == Html.HttpRequest.DONE && (request.status == 200 || request.status == 0)) {
                handler(request.responseText);
            }
        });

        // POST the data to the server
        String finalEndPoint = endPoint + eventName;
        request.open("POST", finalEndPoint);
        request.send(Convert.JSON.encode(json)); // perform the async POST
        return request;
    }

    void loadMap(String responseText) {
        if (responseText.isEmpty) {
            throw "Server endpoint returned an empty string";
        }
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
        cellSize = contextMap.cellSize; // @todo load from contextMap

        // Create layers
        for (BlueBear.Layer contextLayer in contextMap.layers) {
            Layer layer;
            layer = new Layer(map, contextLayer.type, contextLayer.index);
            layer.layer = contextLayer;
            map.layers[contextLayer.name] = layer;
            if (layer.type == 'grid') {
                map.updateGrid();
            }
        }

        for (BlueBear.PencilSet pencilSet in contextMap.pencilSets) {
            for (BlueBear.Pencil pencil in pencilSet.pencils) {
                pencils[pencil.name] = new Pencil.fromBlueBearPencil(this, pencil);
            }
        }

        resourceManager.load().then((res) {
            for (BlueBear.MapItem mapItem in context.mapItems) {
                Layer layer = map.layers[mapItem.layerName];
                Pencil pencil = pencils[mapItem.pencilName];
                if (null == layer) {
                    print('No layer found: ${mapItem.layerName}');
                    continue;
                }
                if (null == pencil) {
                    print('No pencil found: ${mapItem.pencilName}');
                    continue;
                }
                map.createCell(layer, new Point(mapItem.x, mapItem.y), pencil, false);
            }
            attachEvents();
        });
    }

    Layer getSelectedLayer() {
        Html.ElementList els = Html.querySelectorAll('[name="$layerSelectorName"]');
        for (Html.Element el in els) {
            if ('SELECT' == el.tagName) {
                return map.layers[(el as Html.SelectElement).value];
            }
        }
        throw "No layer selected or missing layer";
    }

    Pencil getSelectedPencil() {
        Html.ElementList els = Html.querySelectorAll('[name="$pencilSelectorName"]');
        for (Html.Element el in els) {
            if ('SELECT' == el.tagName) {
                return pencils[(el as Html.SelectElement).value];
            }
            if ('INPUT' == el.tagName) {
                Html.InputElement input = (el as Html.InputElement);
                if ('radio' == input.type && input.checked) {
                    return pencils[input.value];
                }
            }
        }
        throw "No pencil selected or missing pencil";
    }

    SimpleButton addButton() {
        var shape = new Shape();
        shape.graphics.rectRound(2, 2, 100, 25, 5, 5);
        shape.graphics.strokeColor(Color.LightGray, 2);
        GraphicsGradient grad = new GraphicsGradient.linear(0, 0, 0, 40);
        grad.addColorStop(0, Color.WhiteSmoke);
        grad.addColorStop(0.2, Color.White);
        grad.addColorStop(1, Color.GhostWhite);
        shape.graphics.fillGradient(grad);
        SimpleButton button = new SimpleButton(shape, shape, shape);
        button.hitTestState = shape;
        button.onMouseClick.listen((MouseEvent e){
            showGrid = !showGrid;
            for (Layer layer in map.layers.values) {
                if (layer.type != 'grid') {
                    continue;
                }
                for (Cell cell in layer.cells.values) {
                    cell.visible = showGrid;
                }
            }
        });
        stage.addChild(button);
        return button;
    }

    Point getTopLeftViewPoint() =>
    map.viewPointToGamePoint(stage.contentRectangle.topLeft.subtract(new Point(x, y)));

    Point getBottomRightViewPoint() =>
    map.viewPointToGamePoint(stage.contentRectangle.bottomRight.subtract(new Point(x, y)));

}