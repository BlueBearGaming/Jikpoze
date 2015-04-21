part of bluebear;

/**
 * This is the main class of the game, it handles the creation
 * of the stage and the creation of the cells.
 */
abstract class Base extends Jikpoze.Board {

    Context context;
    String endPoint;
    int contextId;

    Base(canvas, Map options) : super(canvas, options) {
        LoadContextRequest contextRequest = new LoadContextRequest(contextId);
        queryApi(LoadContextRequest.code, contextRequest.json, loadMap);
    }

    void parseOptions(Map options) {
        super.parseOptions(options);

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
    }

    void attachStageEvents() {
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
    }

    void attachMapItemEvents(MapItem mapItem);

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
        request.send(JSON.encode(json)); // perform the async POST
        return request;
    }

    void loadMap(String responseText) {
        if (responseText.isEmpty) {
            throw "Server endpoint returned an empty string";
        }
        // Todo interrogate engine properly
        EngineEvent response = new EngineEvent.fromJson(this, responseText);
        LoadContextResponse contextResponse = response.data;
        context = contextResponse.context;

        BlueBearMap contextMap = context.map;

        // Load right type of Map
        switch (contextMap.type) {
            case 'hexagonal':
            case 'hex':
                map = new Jikpoze.HexMap(this);
                break;
            case 'isometric':
            case 'iso':
                map = new Jikpoze.IsoMap(this);
                break;
            default:
                map = new Jikpoze.SquareMap(this);
        }
        map.name = 'map.' + contextMap.name;
        cellSize = contextMap.cellSize;

        x = stage.stageWidth / 2; // Center origin
        y = stage.stageHeight / 2;

        // Load layer from context.map
        loadLayers(context.map.layers);

        // Load all pencils in the map and load bitmap urls in the resource manager
        new Jikpoze.SelectionPencil(this); // Add special pencil for selection
        loadPencilSets(context.map.pencilSets);

        // Wait for the resource manager to actually load all the bitmap data and load mapItems and attach events
        resourceManager.load().then((res) {
            loadBitmapData(context.map.pencilSets);
            loadMapItems(context.mapItems);
            attachStageEvents();
        });
    }

    void updateMap(String responseText) {
        if (responseText.isEmpty) {
            throw "Server returned an empty string";
        }
        MapUpdateResponse response = (new EngineEvent.fromJson(this, responseText)).data as MapUpdateResponse;
        loadMapItems(response.updated);
    }

    void loadLayers(List<Layer> layers) {
        for (Layer contextLayer in layers) {
            new Jikpoze.Layer(map, contextLayer.name, contextLayer.type, contextLayer.index);
        }
    }

    void loadPencilSets(List<PencilSet> pencilSets) {
        for (PencilSet pencilSet in pencilSets) {
            for (Pencil pencil in pencilSet.pencils) {
                new Jikpoze.Pencil(this, name: pencil.name, type: pencil.type, width: pencil.width, height: pencil.height, imageX: pencil.imageX, imageY: pencil.imageY);

                if (null != pencil.image) {
                    // If pencil has an image, load it
                    resourceManager.addBitmapData('image.' + pencil.name, resourceBasePath + pencil.image.fileName);
                } else if (!resourceManager.containsBitmapData('image.' + pencil.pencilSet.name)) {
                    // Else it means it's a sprite and it takes the image from the sprite
                    resourceManager.addBitmapData('image.' + pencil.pencilSet.name, resourceBasePath + pencil.pencilSet.sprite.fileName);
                }
            }
        }
    }

    void loadMapItems(List<MapItem> mapItems) {
        for (MapItem mapItem in mapItems) {
            Jikpoze.Layer layer = map.layers[mapItem.layerName];
            Jikpoze.Pencil pencil = pencils[mapItem.pencilName];
            if (null == layer) {
                print('No layer found: ${mapItem.layerName}');
                continue;
            }
            if (null == pencil) {
                print('No pencil found: ${mapItem.pencilName}');
                continue;
            }
            mapItem.cell = map.createCell(layer, new Point(mapItem.x, mapItem.y), pencil);
            attachMapItemEvents(mapItem);
        }
    }

    void loadBitmapData(List<PencilSet> pencilSets) {
        for (PencilSet pencilSet in pencilSets) {
            for (Pencil pencil in pencilSet.pencils) {
                BitmapData bitmapData;

                if (null != pencil.image) {
                    bitmapData = resourceManager.getBitmapData('image.' + name);
                } else {
                    bitmapData = resourceManager.getBitmapData('image.' + pencil.pencilSet.name);
                    // Crop to sprite selection
                    Rectangle spriteRectangle = new Rectangle(pencil.spriteX, pencil.spriteY, pencil.spriteWidth, pencil.spriteHeight);
                    bitmapData = new BitmapData.fromBitmapData(bitmapData, spriteRectangle);
                }

                pencils[pencil.name].bitmapData = bitmapData;
            }
        }
    }

    void clearSelection() {
        map.layers['selection'].clear();
    }
}