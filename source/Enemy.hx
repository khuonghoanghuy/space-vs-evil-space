package;

import flixel.FlxG;
import flixel.FlxSprite;

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
	public var startFrom:EnemyStartForm;

	public function new(x:Float = 0, y:Float = 0, type:EnemyType = EnemyType.NORMAL, startFrom:EnemyStartForm = EnemyStartForm.RIGHT)
	{
		super(x, y);

		this.type = type;
		this.startFrom = startFrom;

		applyTypeStats();

		// makeGraphic(32, 32, 0xFFFF0000);

		switch (this.type)
		{
			case NORMAL:
				loadGraphic(Paths.images("enemy/normal"), false);
			case FAST_MOVE:
				makeGraphic(32, 32, 0xFFFF0000);
			case SHOOTER:
				makeGraphic(32, 32, 0xFFFF0000);
			case LASER_SHOOTER:
				makeGraphic(32, 32, 0xFFFF0000);
		}
	}

	function applyTypeStats():Void
	{
		switch (this.type)
		{
			case NORMAL, SHOOTER:
				health = 50;
			case FAST_MOVE:
				health = 20;
			case LASER_SHOOTER:
				health = 80;
		}
	}

	public function setType(newType:EnemyType)
	{
		this.type = newType;
		applyTypeStats();
	}

	public function setStartFrom(newStart:EnemyStartForm)
	{
		this.startFrom = newStart;
	}
}
