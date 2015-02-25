part of jikpoze;

class Cell extends DisplayObjectContainer {
    Layer layer;
    Point position;
    Pencil pencil;

    Cell(this.layer, this.position, this.pencil) {
        if (null == layer) {
            throw "layer cannot be null";
        }
        if (null == position) {
            throw "position cannot be null";
        }
        if (null == pencil) {
            throw "pencil cannot be null";
        }
        layer.addChild(this);
        attachEvents();
        draw();
    }

    void draw() {
        clear();
        Point viewPoint = layer.map.gamePointToViewPoint(position);
        x = viewPoint.x;
        y = viewPoint.y;
        DisplayObject child = pencil.getDisplayObject(position);
        addChild(child);
        //applyCache(child.x.floor(), child.y.floor(), child.width.ceil(), child.height.ceil(), debugBorder: false);
    }

    void clear() {
        removeChildren();
        if (layer.contains(this)) {
            layer.removeChild(this);
        }
        removeCache();
        layer.addChild(this);
    }

    void attachEvents() {
        onMouseClick.listen((MouseEvent e) {
            Board board = layer.map.board;
            if (board.dragging != null) {
                return;
            }
            try {
                Pencil selectedPencil = board.getSelectedPencil();
                Layer targetLayer = board.getSelectedLayer();
                if (targetLayer.cells.containsKey(position)) {
                    Cell cell = layer.map.removeCell(targetLayer, position);
                    if (cell.pencil == selectedPencil) {
                        return;
                    }
                }
                layer.map.createCell(targetLayer, position, selectedPencil);
                layer.map.renderCells();
            } catch (exception) {
                print(exception);
            }
        });
    }

    static int getPointHashCode(Point point) {
        return new JenkinsHasher().add(point.x).add(point.x.sign).add(point.y).add(point.y.sign).hash;
    }

    static bool pointEquals(Point k1, Point k2) {
        return Cell.getPointHashCode(k1) == Cell.getPointHashCode(k2);
    }
}
