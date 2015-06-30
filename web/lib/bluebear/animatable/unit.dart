part of bluebear;

class Unit extends Sprite implements Animatable {

    num _animationTime = 0.0;
    TextureAtlas textureAtlas;
    int currentFrame = 0;

    Unit(this.textureAtlas) {
        setCurrentFrame('down-0');
    }

    bool advanceTime(num time) {
        _animationTime += time;
        if (_animationTime < 1.1) {
            int frame = ((_animationTime * 8) % 4).floor();
            setCurrentFrame('down-' + frame.toString());
            y = _animationTime * 40;
        }

        return true;
    }

    setCurrentFrame(String name) {
        BitmapData bitmapData = textureAtlas.getBitmapData(name);
        removeChildren();
        Bitmap bitmap = new Bitmap(bitmapData);
        bitmap.width *= 3;
        bitmap.height *= 3;
        addChild(bitmap);
    }
}