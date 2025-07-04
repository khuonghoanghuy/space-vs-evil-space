package;

import flixel.FlxSprite;

class Bullet extends FlxSprite
{
	public var power:Int = 15;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic(Paths.images('bullet'), true, 8, 8);
		animation.add("fire", [0, 1, 2, 3], 10, false);
		animation.play("fire");
		velocity.x = 800;
	}
}
