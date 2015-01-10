part of jikpoze;

class IsoMap extends HexMap {

	num gameToViewYFactor = IsoCell.skewFactor;
	num viewToGameYFactor = IsoCell.skewFactor;

	IsoMap(Board board) : super(board);

	Cell createCell(Layer layer, Point point, BlueBear.Pencil pencil) =>
			layer.cells[point] = new IsoCell(layer, point, pencil);

}