part of jikpoze;

class HexGridPencil extends GridPencil {

    HexGridPencil(Board board) : super(board);

    void buildGraphics(Graphics g) {
        int numberOfSides = 6; // hexagon
        num a = Math.PI / 2;
        num size = board.cellSize / Math.cos(a + 2 * Math.PI / numberOfSides) / 2;
        g.moveTo(size * Math.cos(a), size * Math.sin(a));
        for (int i = 1; i <= numberOfSides; i++) {
            g.lineTo(size * Math.cos(a + i * 2 * Math.PI / numberOfSides), size * Math.sin(a + i * 2 * Math.PI / numberOfSides));
        }
    }
}