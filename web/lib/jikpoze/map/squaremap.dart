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
    int renderOffset = 10;

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
        _doRenderCells();
        applyCache(-width.floor(), -height.floor(), width.floor() * 2, height.floor() * 2, debugBorder: true);
    }

    void _doRenderCells() {
        for (Layer layer in layers.values) {
            for (Cell cell in layer.cells.values) {
                cell.clear();
            }
            Point topLeft = board.getTopLeftViewPoint();
            Point bottomRight = board.getBottomRightViewPoint();
            for (int cy = topLeft.y.floor() - renderOffset; cy <= bottomRight.y.floor() + renderOffset; cy++) {
                for (int cx = topLeft.x.floor() - renderOffset; cx <= bottomRight.x.floor() + renderOffset; cx++) {
                    renderCell(layer, new Point(cx, cy));
                }
            }
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