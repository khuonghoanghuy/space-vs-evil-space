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

	public function new(x:Float = 0, y:Float = 0, ?type:Dynamic = NORMAL, ?startFrom:Dynamic = RIGHT)
	{
		super(x, y);

		changeType(type);
		changeStartFrom(startFrom);

		makeGraphic(32, 32, 0xFFFF0000);
	}

	function changeType(type:Dynamic):Void
	{
		if (Std.isOfType(type, String))
		{
			var typeStr = (type : String).toUpperCase();
			switch (typeStr)
			{
				case "NORMAL":
					this.type = EnemyType.NORMAL;
				case "SHOOTER":
					this.type = EnemyType.SHOOTER;
				case "FAST_MOVE":
					this.type = EnemyType.FAST_MOVE;
				case "LASER_SHOOTER":
					this.type = EnemyType.LASER_SHOOTER;
				default:
					this.type = EnemyType.NORMAL;
			}
		}
		else if (Std.isOfType(type, EnemyType))
		{
			this.type = type;
		}
		else
		{
			this.type = EnemyType.NORMAL;
		}

		switch (this.type)
		{
			case NORMAL, SHOOTER:
				health = 25;
			case FAST_MOVE:
				health = 10;
			case LASER_SHOOTER:
				health = 40;
		}
	}

	function changeStartFrom(startFrom:Dynamic):Void
	{
		if (Std.isOfType(startFrom, String))
		{
			var startStr = (startFrom : String).toUpperCase();
			switch (startStr)
			{
				case "LEFT":
					this.startFrom = EnemyStartForm.LEFT;
				case "RIGHT":
					this.startFrom = EnemyStartForm.RIGHT;
				case "TOP":
					this.startFrom = EnemyStartForm.TOP;
				case "BOTTOM":
					this.startFrom = EnemyStartForm.BOTTOM;
				default:
					this.startFrom = EnemyStartForm.LEFT;
			}
		}
		else if (Std.isOfType(startFrom, EnemyStartForm))
		{
			this.startFrom = startFrom;
		}
		else
		{
			this.startFrom = EnemyStartForm.LEFT;
		}
	}

	public function setType(newType:EnemyType)
	{
		this.type = newType;

		switch (this.type)
		{
			case NORMAL, SHOOTER:
				health = 25;
			case FAST_MOVE:
				health = 10;
			case LASER_SHOOTER:
				health = 40;
		}
	}

	public function setStartFrom(newType:EnemyStartForm)
	{
		this.startFrom = newType;
	}
}
