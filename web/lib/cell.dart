part of jikpoze;

class Cell extends DisplayObjectContainer {
	Board board;
	Point position;
	int size;
	Shape shape;
	List<Cell> adjacentCells = new List<Cell>();
	int color;
	bool selected = false;
	bool mouseOver = false;
	static List<int> colors = [
			Color.Beige,
			Color.DarkKhaki,
			Color.BurlyWood,
			Color.DarkGreen,
			Color.DimGray,
			Color.ForestGreen,
		];

	Cell(Board board, Point position, int size){
		this.board = board;
		this.position = position;
		color = colors.elementAt(new Math.Random().nextInt(colors.length));
		updateCell(size);
		attachEvents();
	}

	void attachEvents(){
		void mouseOverEvent(MouseEvent e){
			mouseOver = true;
			draw();
			board.updateSelected();
		}
		onMouseOver.listen(mouseOverEvent);
		void mouseOutEvent(MouseEvent e){
			mouseOver = false;
            draw();
			board.updateSelected();
		}
		onMouseOut.listen(mouseOutEvent);
		void mouseClickEvent(MouseEvent e){
			board.select(this);
		}
		onMouseClick.listen(mouseClickEvent);
	}

	void updateCell([int size]){
		if(size != null) {
			this.size = size;
		}
		Point viewPoint = board.gamePointToViewPoint(position);
		x = viewPoint.x;
		y = viewPoint.y;
		draw();
	}

	void draw(){
		clear();
		buildGraphics(shape.graphics);
		if(board.selected == this){
			shape.graphics.strokeColor(Color.Aqua, 10);
		} else if(mouseOver){
			shape.graphics.strokeColor(Color.Azure, 5);
		} else {
			shape.graphics.strokeColor(Color.Gray, 1);
		}
		shape.graphics.fillColor(color);

	}

	void clear() {
		if(shape != null) {
			shape.graphics.clear();
			removeChild(shape);
		}
		if(board.contains(this)) {
			board.removeChild(this);
		}
		shape = new Shape();
		addChild(shape);
		board.addChild(this);
	}

	void buildGraphics(Graphics g) {
		g.moveTo(size, size);
		g.lineTo(size, -size);
		g.lineTo(-size, -size);
		g.lineTo(-size, size);
		g.lineTo(size, size);
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

	static int getPointHashCode(Point point){
		return new JenkinsHasher().add(point.x).add(point.x.sign).add(point.y).add(point.y.sign).hash;
	}

	static bool pointEquals(Point k1, Point k2) {
		return Cell.getPointHashCode(k1) == Cell.getPointHashCode(k2);
	}
}
