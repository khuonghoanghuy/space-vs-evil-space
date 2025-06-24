package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public var levelScript:Scripted;
	public var player:Player;
	public var bullets:Array<FlxSprite> = [];
	public var shootTimer:FlxTimer;
	public var starBackdrop:FlxBackdrop;

	public static var instance:PlayState = null;

	override public function create()
	{
		instance = this;

		super.create();

		starBackdrop = new FlxBackdrop();
		starBackdrop.loadGraphic(Paths.images("stars"));
		starBackdrop.velocity.x = -10;
		starBackdrop.scale.set(0.6, 0.6);
		starBackdrop.updateHitbox();
		starBackdrop.setPosition(0, 0);
		add(starBackdrop);

		player = new Player(-500, 0);
		player.allowBound = player.allowMove = false;
		player.screenCenter(Y);
		add(player);

		FlxTween.tween(player, {x: 50}, 0.5, {
			ease: FlxEase.sineInOut,
			onComplete: function(tween:FlxTween)
			{
				player.allowBound = player.allowMove = true;
			}
		});

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

		if (player.allowMove || FlxG.keys.pressed.Z && shootTimer.finished)
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
		var bullet = new FlxSprite((player.x + player.width / 2 - 4) + 20, player.y + player.height / 2 - 4);
		bullet.loadGraphic(Paths.images('bullet'), true, 8, 8);
		bullet.animation.add("fire", [0, 1, 2, 3], 10, false);
		bullet.animation.play("fire");
		bullet.velocity.x = 600;
		add(bullet);
		bullets.push(bullet);
	}
}
