part of jikpoze;

/**
 * This is the main class of the game, it handles the creation
 * of the stage and the creation of the cells.
 */
class Map extends DisplayObjectContainer {

	Board board;
	Col.LinkedHashMap<String, Layer> layers = new Col.LinkedHashMap<String, Layer>();

	Map(this.board) {
		board.addChild(this);
	}

	Cell createCell(Layer layer, Point point, BlueBear.Pencil pencil) =>
			layer.cells[point] = new Cell(layer, point, pencil);

	Point gamePointToViewPoint(Point gamePoint) {
		return new Point(
				gamePoint.x * board.cellSize * 2,
				gamePoint.y * board.cellSize * 2
			);
	}

	Point viewPointToGamePoint(Point viewPoint) {
		return new Point(
				(viewPoint.x / board.cellSize / 2).floor(),
				(viewPoint.y / board.cellSize / 2).floor()
			);
	}

	Point getTopLeftViewPoint() =>
			viewPointToGamePoint(stage.contentRectangle.topLeft.subtract(new Point(x, y)));

	Point getBottomRightViewPoint() =>
			viewPointToGamePoint(stage.contentRectangle.bottomRight.subtract(new Point(x, y)));

	void renderCells() {
		for(Layer layer in layers.values) {
			layer.renderCells();
		}
	}
}