part of jikpoze;

class HitboxBitmap extends Bitmap {
	HitboxBitmap(BitmapData bitmapData) : super(bitmapData);

	DisplayObject hitTestInput(num localX, num localY) {
		if (bitmapData == null) {
			return null;
		}
		int x = localX.toInt();
        int y = localY.toInt();
        if (x >= 0 && y >= 0 && x < bitmapData.width && y < bitmapData.height) {
          var pixel = bitmapData.getPixel32(x, y);
          var alpha = pixel >> 24;
          if (alpha >= 128) return this;
        }
        return null;
	}
}
