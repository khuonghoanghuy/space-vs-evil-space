package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;

class Player extends FlxSprite
{
	/**
	 * Stop player from going out of bounds
	 */
	public var allowBound:Bool = true;

	/**
	 * Allow player to move
	 */
	public var allowMove:Bool = true;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		makeGraphic(32, 32, 0xff00ff00);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (allowMove)
		{
			if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
			{
				x += (FlxG.keys.pressed.RIGHT ? 1 : -1) * 100 * elapsed;
			}

			if (FlxG.keys.pressed.UP || FlxG.keys.pressed.DOWN)
			{
				y += (FlxG.keys.pressed.DOWN ? 1 : -1) * 100 * elapsed;
			}
		}

		if (allowBound)
		{
			x = FlxMath.bound(x, 0, FlxG.width - width);
			y = FlxMath.bound(y, 0, FlxG.height - height);
		}
	}
}
