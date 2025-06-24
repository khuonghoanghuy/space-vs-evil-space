package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public var levelScript:Scripted;
	public var player:Player;
	public var bullets:Array<FlxSprite> = [];
	public var shootTimer:FlxTimer;

	public static var instance:PlayState = null;

	override public function create()
	{
		instance = this;

		super.create();

		player = new Player(0, 0);
		add(player);

		shootTimer = new FlxTimer();
		shootTimer.finished = true;

		levelScript = new Scripted(Paths.data('world1/level1'));
		levelScript.iris.execute(); // execute again

		levelScript.call('create', []);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		player.update(elapsed);
		levelScript.call('update', [elapsed]);

		if (FlxG.keys.pressed.Z && shootTimer.finished)
		{
			shoot();
			shootTimer.start(0.1);
		}

		for (bullet in bullets)
		{
			if (bullet.x > FlxG.width || bullet.x + bullet.width < 0 || bullet.y > FlxG.height || bullet.y + bullet.height < 0)
			{
				remove(bullet);
				bullets.remove(bullet);
				bullet.destroy();
				break;
			}
		}
	}

	function shoot()
	{
		var bullet = new FlxSprite(player.x + player.width / 2 - 4, player.y + player.height / 2 - 4);
		bullet.makeGraphic(8, 8, FlxColor.WHITE);
		bullet.velocity.x = 400;
		add(bullet);
		bullets.push(bullet);
	}
}
