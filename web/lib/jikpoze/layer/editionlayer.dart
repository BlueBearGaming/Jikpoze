part of jikpoze;

class EditionLayer extends Layer {

	BlueBear.Pencil pencil;

	EditionLayer(Map map, int index) : super (map, index) {
		map.addChildAt(this, index);
		void mouseClickEvent(MouseEvent e){
			if(map.board.dragging == null){
				print(e);
				return;
			}
		}
		onMouseClick.listen(mouseClickEvent);
	}

	void renderCells() {
		Point topLeft = map.getTopLeftViewPoint();
		Point bottomRight = map.getBottomRightViewPoint();
		Point point;
		for (int cx = topLeft.x.floor(); cx <= bottomRight.x.floor() + 1; cx++) {
			for (int cy = topLeft.y.floor(); cy <= bottomRight.y.floor() + 1; cy++) {
				point = new Point(cx, cy);
				if(!cells.containsKey(point)){
					map.createCell(this, point, pencil);
				} else {
					cells[point].updateCell();
					cells[point].draw();
				}
			}
		}
	}
}
