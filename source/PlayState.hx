package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public var levelScript:Scripted;
	public var player:Player;
	public var playerEmttier:FlxSprite;
	public var enemies:Array<Enemy> = [];
	public var bullets:Array<FlxSprite> = [];
	public var shootTimer:FlxTimer;
	public var starBackdrops:FlxSpriteGroup;
	public var currentTime:Float = 0;

	public static var instance:PlayState = null;

	override public function create()
	{
		instance = this;

		super.create();

		starBackdrops = new FlxSpriteGroup();
		for (i in 0...3)
		{
			var stardrop = new FlxBackdrop();
			stardrop.loadGraphic(Paths.images("stars"));
			switch (i)
			{
				case 0:
					stardrop.velocity.x = -10;
					stardrop.scale.set(0.5, 0.5);
				case 1:
					stardrop.velocity.x = -30;
					stardrop.scale.set(0.7, 0.7);
				case 2:
					stardrop.velocity.x = -60;
			}
			stardrop.updateHitbox();
			stardrop.setPosition(0, 0);
			starBackdrops.add(stardrop);
		}
		add(starBackdrops);

		player = new Player(-500, 0);
		player.allowBound = player.allowMove = false;
		player.screenCenter(Y);
		add(player);

		playerEmttier = new FlxSprite(player.x + player.width / 2, player.y + player.height / 2);
		playerEmttier.loadGraphic(Paths.images('emttier_bullet'), true, 32, 32);
		playerEmttier.animation.add("idle", [0]);
		playerEmttier.animation.add("fire", [0, 1, 2, 3], 10, false);
		playerEmttier.animation.play("idle");
		playerEmttier.alpha = 0;
		playerEmttier.screenCenter(Y);
		add(playerEmttier);

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

	public function addEnemy(x:Float, y:Float, ?doTween:Bool = false, ?tweenX:Float = 0, ?tweenY:Float = 0):Enemy
	{
		var enemy = new Enemy(x, y);
		add(enemy);
		if (doTween)
		{
			FlxTween.tween(enemy, {x: tweenX, y: tweenY}, 0.5, {ease: FlxEase.sineInOut});
		}

		enemies.push(enemy);
		return enemy;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		currentTime += elapsed * 2;

		if (currentTime % 1 == 0)
		{
			trace('Current Time: ' + currentTime);
		}

		player.update(elapsed);
		levelScript.call('update', [elapsed]);
		playerEmttier.setPosition((player.x + player.width / 2 - 4) + 20, (player.y + player.height / 2 - 4) - 12);

		if (player.allowMove && FlxG.keys.pressed.Z && shootTimer.finished)
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
				if (bullets.length == 0)
				{
					playerEmttier.animation.play("fire");
					playerEmttier.animation.onFinish.add(function(animation:String)
					{
						switch (animation)
						{
							case "fire":
								playerEmttier.alpha = 0;
								playerEmttier.animation.play("idle");
						}
					});
				}
				break;
			}
		}
	}

	function shoot()
	{
		playerEmttier.alpha = 1;
		playerEmttier.animation.play("idle", true);

		var bullet = new FlxSprite((player.x + player.width / 2 - 4) + 20, player.y + player.height / 2 - 4);
		bullet.loadGraphic(Paths.images('bullet'), true, 8, 8);
		bullet.animation.add("fire", [0, 1, 2, 3], 10, false);
		bullet.animation.play("fire");
		bullet.velocity.x = 600;
		add(bullet);

		bullets.push(bullet);
	}
}
