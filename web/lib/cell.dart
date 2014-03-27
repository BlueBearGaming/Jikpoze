part of jikpoze;

class Cell extends DisplayObjectContainer {
	Board board;
	Point position;
	int size;
	Shape shape;
	List<Cell> adjacentCells = new List<Cell>();

	Cell(Board board, Point position, int size){
		this.board = board;
		this.position = position;
		shape = new Shape();
		updateCell(size);
		attachEvents();
		this.board.stage.addChild(this);
	}

	void attachEvents(){
		void mouseOverEvent(MouseEvent e){
			shape.graphics.fillColor(Color.Black);
			for(Cell cell in getAdjacentCells()){
				cell.shape.graphics.fillColor(Color.Gray);
			}
		}
		onMouseOver.listen(mouseOverEvent);
		void mouseOutEvent(MouseEvent e){
			shape.graphics.fillColor(Color.White);
			for(Cell cell in getAdjacentCells()){
				cell.shape.graphics.fillColor(Color.White);
			}
		}
		onMouseOut.listen(mouseOutEvent);
	}

	void updateCell(int size){
		var center = board.stage.contentRectangle.center;
		this.size = size;
		Point viewPoint = this.gamePointToViewPoint(position);
		x = center.x + viewPoint.x;
		y = center.y + viewPoint.y;
		draw();
	}

	void draw(){
		buildGraphics(shape.graphics);
		shape.graphics.strokeColor(Color.Black, 1);
		shape.graphics.fillColor(Color.White);
		addChild(shape);
	}

	void buildGraphics(Graphics g) {
		g.moveTo(size, size);
		g.lineTo(size, -size);
		g.lineTo(-size, -size);
		g.lineTo(-size, size);
		g.lineTo(size, size);
	}

	Point gamePointToViewPoint(Point gamePoint){
		return new Point(gamePoint.x * size * 2, gamePoint.y * size * 2);
	}

	static int getMaxX(num width, int size){
		return (width / size / 4).floor();
	}

	static int getMaxY(num height, int size){
		return (height / size / 4).floor();
	}

	static int getPointHashCode(Point point){
		return new JenkinsHasher().add(point.x).add(point.x.sign).add(point.y).add(point.y.sign).hash;
	}

	static bool pointEquals(Point k1, Point k2) {
		return Cell.getPointHashCode(k1) == Cell.getPointHashCode(k2);
	}

	List<Point> getAdjacentPoints() {
		num x = position.x;
		num y = position.y;
		return [
			new Point(x + 1, y),
			new Point(x, y + 1),
			new Point(x - 1, y),
			new Point(x, y - 1),
         ];
	}

	List<Cell> getAdjacentCells(){
		if(adjacentCells.isNotEmpty){
			return adjacentCells;
		}
		for (Point point in getAdjacentPoints()){
			if(board.cells.containsKey(point)){
				adjacentCells.add(board.cells[point]);
			} else {
				// Create and append
			}
		}
		return adjacentCells;
	}
}
