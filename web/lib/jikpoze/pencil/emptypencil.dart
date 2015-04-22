part of jikpoze;

class EmptyPencil extends GridPencil {

    EmptyPencil(Board board, {String name: 'empty', String type: 'events'}) : super(board, name: name, type: type){
        graphics.strokeColor(Color.Transparent, 1);
        graphics.fillColor(Color.Transparent);
    }

    DisplayObject getDisplayObject(Point point) {
        Sprite sprite = super.getDisplayObject(point);
        sprite.alpha = 0.4;
        return sprite;
    }
}