part of bluebear;

/**
 * This is the main class of the game, it handles the creation
 * of the stage and the creation of the cells.
 */
abstract class Base extends Jikpoze.Board {
  EventEngine eventEngine;
  Context context;
  String endPoint;
  String socketIOUri;
  int contextId;
  InputEvent dragEvent;

  Base(canvas, Map options) : super(canvas, options) {
    eventEngine = new EventEngine(this);
    new LoadContextRequest();
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
    if (options.containsKey('socketIOUri')) {
      socketIOUri = options['socketIOUri'];
    } else {
      throw "Option 'socketIOUri' cannot be null";
    }
  }

  void attachStageEvents() {
    eventBegin(InputEvent e) {
      dragEvent = e;
      dragging = new Point(e.stageX, e.stageY);
    }

    stage.onTouchBegin.listen(eventBegin);
    stage.onMouseDown.listen(eventBegin);

    eventEnd(InputEvent e) {
      dragging = null;
      //map.updateGrid();
      //map.updateCells(); //@todo: query missing cells
    }

    stage.onTouchEnd.listen(eventEnd);
    stage.onMouseUp.listen(eventEnd);

    eventMove(InputEvent e) {
      if (dragging != null) {
        x += e.stageX - dragging.x;
        y += e.stageY - dragging.y;
        dragging = new Point(e.stageX, e.stageY);
      }
    }

    stage.onTouchMove.listen(eventMove);
    stage.onMouseMove.listen(eventMove);
  }

  void attachMapItemEvents(MapItem mapItem);

  void loadContext(Context context) {
    if (null != this.context) {
      throw 'Context already loaded';
    }
    this.context = context;

    // Load right type of Map
    switch (context.map.type) {
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
    map.name = 'map.' + context.map.name;
    cellSize = context.map.cellSize;

    x = stage.stageWidth / 2; // Center origin
    y = stage.stageHeight / 2;

    // Load layer from context.map
    loadLayers(context.map.layers);

    // Load all pencils in the map and load bitmap urls in the resource manager
    new Jikpoze.SelectionPencil(this); // Add special pencil for selection
    new Jikpoze.EmptyPencil(this); // Add special pencil for selection
    loadPencilSets(context.map.pencilSets);

    // Wait for the resource manager to actually load all the bitmap data and load mapItems and attach events
    resourceManager.load().then((res) {
      loadBitmapData(context.map.pencilSets);
      loadMapItems(context.mapItems);
      attachStageEvents();
    });
  }

  void loadLayers(List<Layer> layers) {
    for (Layer contextLayer in layers) {
      new Jikpoze.Layer(
          map, contextLayer.name, contextLayer.type, contextLayer.index);
    }
  }

  void loadPencilSets(List<PencilSet> pencilSets) {
    for (PencilSet pencilSet in pencilSets) {
      for (Pencil pencil in pencilSet.pencils) {
        new Jikpoze.Pencil(this,
            name: pencil.name,
            type: pencil.type,
            width: pencil.width,
            height: pencil.height,
            imageX: pencil.imageX,
            imageY: pencil.imageY);

        if (null != pencil.image) {
          // If pencil has an image, load it
          resourceManager.addBitmapData(
              'image.' + pencil.name, resourceBasePath + pencil.image.fileName);
        } else if (!resourceManager
            .containsBitmapData('image.' + pencil.pencilSet.name)) {
          // Else it means it's a sprite and it takes the image from the sprite
          resourceManager.addBitmapData('image.' + pencil.pencilSet.name,
              resourceBasePath + pencil.pencilSet.sprite.fileName);
        }
      }
    }
  }

  void loadMapItems(List<MapItem> mapItems) {
    for (MapItem mapItem in mapItems) {
      Jikpoze.Layer layer = map.layers[mapItem.layerName];
      if (null == layer) {
        print('No layer found: ${mapItem.layerName}');
        continue;
      }

      if (null == mapItem.pencilName || mapItem.pencilName.isEmpty) {
        map.removeCell(layer, mapItem.position);
      } else {
        Jikpoze.Pencil pencil = pencils[mapItem.pencilName];
        if (null == pencil) {
          print('No pencil found: ${mapItem.pencilName}');
          continue;
        }
        if (layer.cells.containsKey(mapItem.position)) {
          map.removeCell(layer, mapItem.position);
        }
        Point position = mapItem.position;
        if (0 < mapItem.path.length) {
          position = mapItem.path.last;
        }
        mapItem.cell = map.createCell(layer, position, pencil);
        mapItem.position = position;
        attachMapItemEvents(mapItem);
      }
    }
  }

  void loadBitmapData(List<PencilSet> pencilSets) {
    for (PencilSet pencilSet in pencilSets) {
      for (Pencil pencil in pencilSet.pencils) {
        BitmapData bitmapData;

        if (null != pencil.image) {
          bitmapData = resourceManager.getBitmapData('image.' + pencil.name);
        } else {
          bitmapData =
              resourceManager.getBitmapData('image.' + pencil.pencilSet.name);
          // Crop to sprite selection
          Rectangle spriteRectangle = new Rectangle(pencil.spriteX,
              pencil.spriteY, pencil.spriteWidth, pencil.spriteHeight);
          bitmapData =
              new BitmapData.fromBitmapData(bitmapData, spriteRectangle);
        }

        pencils[pencil.name].bitmapData = bitmapData;
      }
    }
  }

  void clearSelection() {
    map.layers['selection'].clear();
    map.layers['events'].clear();
  }

  Jikpoze.Cell createCell(
      Jikpoze.Layer layer, Point point, Jikpoze.Pencil pencil) {
    if (null == layer) {
      throw 'layer cannot be null';
    }
    if (null == point) {
      throw 'point cannot be null';
    }

    map.removeCell(layer, point);
    Jikpoze.Cell cell = map.createCell(layer, point, pencil);
    new MapUpdateRequest(updated: [cell]);
    return cell;
  }

  Jikpoze.Cell removeCell(Jikpoze.Layer layer, Point point) {
    if (null == layer) {
      throw 'layer cannot be null';
    }
    if (null == point) {
      throw 'point cannot be null';
    }

    Jikpoze.Cell cell = map.removeCell(layer, point);
    new MapUpdateRequest(removed: [cell]);
    return cell;
  }
}
