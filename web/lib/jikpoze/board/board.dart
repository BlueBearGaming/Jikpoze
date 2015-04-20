part of jikpoze;

/**
 * This is the main class of the game, it handles the creation
 * of the stage and the creation of the cells.
 */
class Board extends DisplayObjectContainer {

    Html.CanvasElement canvas;
    RenderLoop renderLoop;
    SquareMap map;
    Col.LinkedHashMap<String, Pencil> pencils = new Col.LinkedHashMap<String, Pencil>();
    Cell selected;
    int cellSize;
    MouseEvent dragMouseEvent;
    Point dragging;
    ResourceManager resourceManager = new ResourceManager();
    String resourceBasePath;
    bool showGrid = false;

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

    void parseOptions(Col.LinkedHashMap options) {
        if (options.containsKey('resourceBasePath')) {
            resourceBasePath = options['resourceBasePath'];
        }
    }

    Rectangle get gameViewPort {
        Point topLeft = viewPointToGamePoint(stage.contentRectangle.topLeft);
        Point bottomRight = viewPointToGamePoint(stage.contentRectangle.bottomRight);
        return new Rectangle(topLeft.x, topLeft.y, bottomRight.x - topLeft.x, bottomRight.y - bottomRight.y);
    }

    Point gamePointToViewPoint(Point gamePoint) {
        return map.gamePointToViewPoint(gamePoint);
    }

    Point viewPointToGamePoint(Point viewPoint) {
        return map.viewPointToGamePoint(viewPoint - new Point(x, y));
    }
}