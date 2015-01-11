part of jikpoze;

class IsoMap extends HexMap {

	IsoMap(Board board) : super(board) {
		skewFactor = 0.3;
	}

	Pencil getGridPencil() {
		if (null == gridPencil) {
			gridPencil = new IsoGridPencil(board);
		}
		return gridPencil;
	}
}