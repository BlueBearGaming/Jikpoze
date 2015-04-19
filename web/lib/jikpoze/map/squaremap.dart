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

    Cell createCell(Layer layer, Point point, Pencil pencil) {
        if (layer.type != pencil.type) {
            print("Warning ! Layer and pencil types does not match: ${layer.type} != ${pencil.type} for layer '${layer.name}' and pencil '${pencil.name}' at position ${point.x}, ${point.y}");
            return null;
        }
        Cell cell = new Cell(layer, point, pencil);
        if (layer.type == 'grid' && !board.showGrid) {
            cell.visible = false;
        }
        return cell;
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
        for (Layer layer in layers.values) {
            if (layer.type == 'grid') {
                Point topLeft = viewPointToGamePoint(getTopLeftViewPointForCache());
                Point bottomRight = viewPointToGamePoint(getBottomRightViewPointForCache());
                int dist = (bottomRight.x - topLeft.x).floor();
                int x = topLeft.x.floor();
                int y = topLeft.y.floor();
                for (int line = 0; line < (bottomRight.y - topLeft.y).floor(); line++) {
                    renderLayerLine(layer, x, y, x + dist, y);
                    y++;
                }
            }
        }
    }

    void renderCell(Layer layer, Point point) {
        if (layer.cells.containsKey(point)) {
            //layer.cells[point].draw(); // Not necessary anymore ?
        } else if (layer.type == 'grid') {
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
        return new Point(-board.x + stage.stageWidth * (1 + 1 / 3), -board.y + stage.stageHeight * (1 + 1 / 3));
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
        // if on same column
        if (ac.position.y == bc.position.y) {
            // if exactly same position
            if (ac.position.x == bc.position.x) {
                // then the layer's index will sort them
                if (ac.layer.index == bc.layer.index) {
                    // If same layer index (case when hovering with pencil in edition mode)
                    return ac.zIndex - bc.zIndex;
                }
                return ac.layer.index - bc.layer.index;
            }
            // left to right order
            return ac.position.x - bc.position.x;
        }
        // back to front order
        return ac.position.y - bc.position.y;
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