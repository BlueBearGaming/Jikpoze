part of jikpoze;

/**
 * This is the main class of the game, it handles the creation
 * of the stage and the creation of the cells.
 */
class Map extends DisplayObjectContainer {

	Board board;
	Col.LinkedHashMap<String, Layer> layers = new Col.LinkedHashMap<String, Layer>();

	Map(Board board) {
		this.board = board;
	}

	Cell createCell(Layer layer, Point point) {
		return layer.cells[point] = new Cell(layer, point);
	}

	Point gamePointToViewPoint(Point gamePoint) {
		return new Point(gamePoint.x * board.cellSize * 2, gamePoint.y * board.cellSize * 2);
	}

	Point viewPointToGamePoint(Point viewPoint) {
		return new Point((viewPoint.x / board.cellSize / 2).floor(), (viewPoint.y / board.cellSize / 2).floor());
	}

	Point getTopLeftViewPoint() {
		return viewPointToGamePoint(stage.contentRectangle.topLeft.subtract(new Point(x, y)));
	}

	Point getBottomRightViewPoint() {
		return viewPointToGamePoint(stage.contentRectangle.bottomRight.subtract(new Point(x, y)));
	}

	void renderCells() {
		for(Layer layer in layers) {
			layer.renderCells();
		}
	}
}