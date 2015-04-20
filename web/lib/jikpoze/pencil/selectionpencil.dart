part of jikpoze;

class SelectionPencil extends GridPencil {

    SelectionPencil(Board board) : super(board) {
        name = 'selection';
        type = 'selection';
        graphics.strokeColor(Color.DarkBlue, 1);
        graphics.fillColor(Color.Blue);
    }
}