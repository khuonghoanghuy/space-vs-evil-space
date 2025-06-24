package;

import flixel.FlxSprite;

class Enemy extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		makeGraphic(32, 32, 0xFFFF0000);
	}
}
