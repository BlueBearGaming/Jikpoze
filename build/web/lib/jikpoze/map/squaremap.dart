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
                "mapItems": [{
                    "layerName": layer.layer.name,
                    "pencilName": pencil.pencil.name,
                    "x": point.x,
                    "y": point.y
                }]
            };
            board.queryApi('bluebear.editor.mapUpdate', json, (response) {
                try{
                    print(Convert.JSON.decode(response));
                } catch (e) {
                    print(response);
                }
            });
        }
        removeCell(layer, point);
        return doCreateCell(layer, point, pencil);
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
        removeChild(cell);
        return cell;
    }

    void updateGrid() {
        for (Layer layer in layers) {
            if (layer.type == 'grid') {
                Point topLeft = viewPointToGamePoint(getTopLeftViewPointForCache());
                Point bottomRight = viewPointToGamePoint(getBottomRightViewPointForCache());
                int dist = (bottomRight.x - topLeft.x).floor();
                int x = topLeft.x.floor();
                int y = topLeft.y.floor();
                for (int line = 0; line < (bottomRight.y - topLeft.y).floor(); line++) {
                    renderLayerLine(layer, x, y, x + dist, y - dist);
                    y++;
                }
            }
        }
    }

    void renderCell(Layer layer, Point point) {
        if (layer.cells.containsKey(point)) {
            //layer.cells[point].draw();
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

    Point getTopLeftViewPointForCache() {
        return new Point(-board.x - stage.stageWidth / 3, -board.y - stage.stageHeight / 3);
    }

    Point getBottomRightViewPointForCache() {
        return new Point(-board.x + stage.stageWidth * (1 + 1/3), -board.y + stage.stageHeight * (1 + 1/3));
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

    void addChildAt(DisplayObject child, int index) {
        super.addChildAt(child, index);
        if (child is Cell) {
            sortChildren(sortCells);
        }
    }

    int sortCells(DisplayObject a, DisplayObject b) {
        if (a is! Cell || b is! Cell) {
            return 0;
        }
        Cell ac = a as Cell;
        Cell bc = b as Cell;
        List specificLayerTypes = ['background', 'land', 'grid', 'events'];
        if (ac.layer.index != bc.layer.index) {
            // For certain layer types, there is no need to check the position, they are always above or below others
            if (specificLayerTypes.contains(ac.layer.type) || specificLayerTypes.contains(bc.layer.type)) {
                return ac.layer.index - bc.layer.index;
            }
        }
        if (ac.position.y == bc.position.y) { // if on same column
            if (ac.position.x == bc.position.x) { // if exactly same position
                return ac.layer.index - bc.layer.index; // then the layer's index will sort them
            }
            return ac.position.x - bc.position.x; // left to right order
        }
        return ac.position.y - bc.position.y; // back to front order
    }

    void renderLayerLine(Layer layer, int x1, int y1, int x2, int y2) {
        int dx = x2 - x1;
        int dy = y2 - y1;
        int y;
        for (int x = x1; x <= x2; x++) {
            y = (y1 + dy * (x - x1) / dx).floor();
            renderCell(layer, new Point(x, y));
        }
    }
}