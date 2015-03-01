part of jikpoze;

class Cell extends DisplayObjectContainer {
    Layer layer;
    SquareMap map;
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
        layer.cells[position] = this;
        map = layer.map;
        map.addChild(this);
        attachEvents();
        draw();
    }

    void draw() {
        Point viewPoint = layer.map.gamePointToViewPoint(position);
        x = viewPoint.x;
        y = viewPoint.y;
        DisplayObject child = pencil.getDisplayObject(position);
        addChild(child);
    }

    void attachEvents() {
        onMouseClick.listen((MouseEvent e) {
            Board board = layer.map.board;
            if (board.dragging != null) {
                return;
            }
            // remove large mouse offset
            if (e.stageX - 2 > board.dragMouseEvent.stageX || board.dragMouseEvent.stageX > e.stageX + 2) {
                return;
            }
            if (e.stageY - 2 > board.dragMouseEvent.stageY || board.dragMouseEvent.stageY > e.stageY + 2) {
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
