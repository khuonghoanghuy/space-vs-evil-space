package;

import flixel.FlxSprite;

class Bullet extends FlxSprite
{
	public var power:Int = 15;

	public function setSpeed_Flip(flip:Bool = false, speed:Float = 800)
	{
		flipX = flip;
		velocity.x = (flipX ? -speed : speed);
	}

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic(Paths.images('bullet'), true, 8, 8);
		animation.add("fire", [0, 1, 2, 3], 10, false);
		animation.play("fire");
		velocity.x = 800;
	}
}
