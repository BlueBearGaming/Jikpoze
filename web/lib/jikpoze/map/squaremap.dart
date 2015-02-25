part of jikpoze;

/**
 * This is the main class of the game, it handles the creation
 * of the stage and the creation of the cells.
 */
class SquareMap extends DisplayObjectContainer {

    Board board;
    Pencil gridPencil;
    Col.LinkedHashMap<String, Layer> layers = new Col.LinkedHashMap<String, Layer>();
    num skewFactor = 1;
    int renderOffset = 1;

    SquareMap(Board board) {
        if (null == board) {
            throw 'board cannot be null';
        }
        board.addChild(this);
        this.board = board;
    }

    Cell createCell(Layer layer, Point point, Pencil pencil, [bool callApi = true]) {
        if (null == layer) {
            throw 'layer cannot be null';
        }
        if (null == point) {
            throw 'point cannot be null';
        }
        if (null != layer.layer && null != pencil.pencil && callApi) {
            Object json = {
                "contextId": board.contextId,
                "layerName": layer.layer.name,
                "pencilName": pencil.pencil.name,
                "x": point.x,
                "y": point.y
            };
            board.queryApi('bluebear.editor.putPencil', json, (response) {
                print(response);
            });
        }
        removeCell(layer, point);
        return layer.cells[point] = doCreateCell(layer, point, pencil);
    }

    Cell doCreateCell(layer, point, pencil) {
        return new Cell(layer, point, pencil);
    }

    Cell removeCell(Layer layer, Point point) {
        if (!layer.cells.containsKey(point)) {
            return null;
        }
        Cell cell = layer.cells[point];
        layer.cells.remove(point);
        cell.clear();
        return cell;
    }

    void renderCells([bool forceUpdate = false]) {
        if (!forceUpdate) {
           	//refreshCache();
            return;
        }
        removeCache();
        Col.LinkedHashMap<String, Layer> layerToRender = layers;
        for (Layer layer in layers.values) {
        	if (['background', 'land', 'grid'].contains(layer.layer.type)) {
            	renderLayer(layer);
            	layerToRender.remove(layer);
        	}
        }
        renderLayers(layerToRender.values);
        applyViewCache();
    }

    void applyViewCache() {
    	Point topLeft = getTopLeftViewPointForCache();
    	Point bottomRight = getBottomRightViewPointForCache();
        applyCache(topLeft.x.floor(), topLeft.y.floor(),
        		(bottomRight.x - topLeft.x).abs().floor(), (bottomRight.y - topLeft.y).abs().floor(),
        		debugBorder: true);
    }

    Point getTopLeftViewPointForCache() {
		return new Point(-board.x - stage.stageWidth / 3, -board.y - stage.stageHeight / 3);
    }

    Point getBottomRightViewPointForCache() {
		return new Point(-board.x + stage.stageWidth * (1 + 1/3), -board.y + stage.stageHeight * (1 + 1/3));
    }

    void renderLayer(Layer layer) {
    	renderLayers([layer]);
    }

    void renderLayers(Iterable<Layer> layers) {
    	for (Layer layer in layers) {
	    	layer.clearCells();
    	}
        Point topLeft = viewPointToGamePoint(getTopLeftViewPointForCache());
        Point bottomRight = viewPointToGamePoint(getBottomRightViewPointForCache());
        int dist = (bottomRight.x - topLeft.x).floor();
        int x = topLeft.x.floor();
        int y = topLeft.y.floor();
        for (int line = 0; line < (bottomRight.y - topLeft.y).floor(); line++) {
        	for (Layer layer in layers) {
            	renderLayerLine(layer, x, y, x + dist, y - dist);
        	}
            y++;
        }
    }

    void renderLayerLine(Layer layer, int x, int y, int x2, int y2) {
        bool yLonger = false;
        int shortLen = y2 - y;
        int longLen = x2 - x;
        if (shortLen.abs() > longLen.abs()) {
            int swap = shortLen;
            shortLen = longLen;
            longLen = swap;
            yLonger = true;
        }
        int decInc;
        if (longLen == 0) {
            decInc = 0;
        } else {
            decInc = ((shortLen << 16) / longLen).floor();
        }

        if (yLonger) {
            if (longLen > 0) {
                longLen += y;
                for (int j = 0x8000 + (x << 16); y <= longLen; ++y) {
                    renderCell(layer, new Point(j >> 16, y));
                    j += decInc;
                }
                return;
            }
            longLen += y;
            for (int j = 0x8000 + (x << 16); y >= longLen; --y) {
                renderCell(layer, new Point(j >> 16, y));
                j -= decInc;
            }
            return;
        }

        if (longLen > 0) {
            longLen += x;
            for (int j = 0x8000 + (y << 16); x <= longLen; ++x) {
                renderCell(layer, new Point(x, j >> 16));
                j += decInc;
            }
            return;
        }
        longLen += x;
        for (int j = 0x8000 + (y << 16); x >= longLen; --x) {
            renderCell(layer, new Point(x, j >> 16));
            j -= decInc;
        }
    }

    void renderCell(Layer layer, Point point) {
        if (layer.cells.containsKey(point)) {
            layer.cells[point].draw();
        } else if (layer.layer.type == 'grid') {
            createCell(layer, point, getGridPencil());
        }
    }

    Pencil getGridPencil() {
        if (null == gridPencil) {
            gridPencil = new GridPencil(board);
        }
        return gridPencil;
    }

    Point gamePointToViewPoint(Point gamePoint) {
        return new Point(
            gamePoint.x * board.cellSize,
            gamePoint.y * board.cellSize
        );
    }

    Point viewPointToGamePoint(Point viewPoint) {
        return new Point(
            (viewPoint.x / board.cellSize).floor(),
            (viewPoint.y / board.cellSize).floor()
        );
    }
}