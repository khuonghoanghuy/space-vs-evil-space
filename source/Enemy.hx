package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

enum EnemyStartForm
{
	LEFT;
	RIGHT;
	TOP;
	BOTTOM;
}

enum EnemyType
{
	NORMAL;
	SHOOTER;
	FAST_MOVE;
	LASER_SHOOTER;
}

class Enemy extends FlxSprite
{
	public var type:EnemyType;

	public function new(x:Float = 0, y:Float = 0, ?type:EnemyType = NORMAL)
	{
		super(x, y);

		switch (type)
		{
			case NORMAL, SHOOTER:
				health = 100;
			case FAST_MOVE:
				health = 50;
			case LASER_SHOOTER:
				health = 150;
		}

		makeGraphic(32, 32, 0xFFFF0000);
	}
}
