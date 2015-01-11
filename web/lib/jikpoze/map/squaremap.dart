part of jikpoze;

/**
 * This is the main class of the game, it handles the creation
 * of the stage and the creation of the cells.
 */
class SquareMap extends DisplayObjectContainer {

	Board board;
	Pencil gridPencil;
	Col.LinkedHashMap<String, Layer> layers = new Col.LinkedHashMap<String, Layer>();

	SquareMap(Board board) {
		if (null == board) {
			throw 'board cannot be null';
		}
		board.addChild(this);
		this.board = board;
	}

	Cell createCell(Layer layer, Point point, Pencil pencil) =>
			layer.cells[point] = new Cell(layer, point, pencil);

	void renderCells() {
		for(Layer layer in layers.values) {
			layer.renderCells();
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
}