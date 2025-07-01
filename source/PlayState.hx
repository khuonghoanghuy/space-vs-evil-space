package;

import Enemy.EnemyStartForm;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxModding;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import sys.io.File;
import tjson.TJSON;

using StringTools;

/**
 * Contains Game Data, Gameplay and such, an important class for the game
 */
class PlayState extends FlxState
{
	/**
	 * Instance of PlayState, used for global access
	 */
	public static var instance:PlayState = null;

	public function new()
	{
		super();

		instance = this;
	}

	/**
	 * Backdrop of the star for the BG objects
	 */
	public var starBackdrops:FlxSpriteGroup;

	/**
	 * Player object
	 */
	public var player:Player;

	/**
	 * Bullet objects when player shoot
	 */
	public var bullets:Array<FlxSprite> = [];

	/**
	 * Handle shot time
	 */
	public var shootTimer:FlxTimer;

	/**
	 * Enemy objects, by Array
	 */
	public var enemies:Array<Enemy> = [];

	/**
	 * JSON wave file path
	 */
	public var jsonPath:String = "world1/level1/waves/wave1.json";

	/**
	 * Default should 1, as a wave number
	 */
	public var waveNum:Int = 1;

	/**
	 * Default should 1, as a level number
	 */
	public var levelNum:Int = 1;

	/**
	 * World number, as default is should 1
	 */
	public var worldNum:Int = 1;

	/**
	 * Scripted object for scripted events
	 */
	public var scriptedArray:Array<Scripted>;

	override function create()
	{
		super.create();

		setupStarBackdrop();

		setupPlayer();

		// how enemy goes will by the json
		setupEnemy();

		// load scripts as same as the wave name, for default scripts loading
		// setupScripts(Paths.data('world${worldNum}/level${levelNum}/waves/wave${waveNum}'));

		shootTimer = new FlxTimer();
		shootTimer.finished = true;

		setupUI();
	}

	/**
	 * Special camera for UI
	 */
	public var cameraHUD:FlxCamera;

	/**
	 * Display score text
	 */
	public var scoreText:FlxText;

	/**
	 * Current score you get
	 * 
	 * Default is 0
	 */
	public var currentScore:Int = 0;

	/**
	 * Create a various UI such as score text, health bar and stuff
	 */
	function setupUI()
	{
		cameraHUD = new FlxCamera();
		cameraHUD.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(cameraHUD, false);

		scoreText = new FlxText(10, 10, 0, "Score: " + getScore(), 20, false);
		scoreText.setBorderStyle(OUTLINE, FlxColor.BLACK);
		scoreText.camera = cameraHUD;
		add(scoreText);
	}

	/**
	 * Get current score
	 * @return Return to string, no matter is that, muahhehehhehe
	 */
	public function getScore():String
	{
		return Std.string(currentScore);
	}

	/**
	 * Update the current score
	 * @param num Amount of score want to updated
	 * @return Return to `getScore()` function
	 */
	public function updateScore(num:Int):String
	{
		currentScore += num;
		scoreText.text = "Score: " + getScore();
		return getScore();
	}

	/**
	 * Create 3 star for the BG
	 */
	function setupStarBackdrop()
	{
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
	}

	/**
	 * Tween all of the enemies from the JSON file
	 */
	function setupEnemy(file:String = "world1/level1/waves/wave1.json")
	{
		try
		{
			var jsonData:Dynamic = Json.parse(FlxModding.system.getAsset(Paths.data(file), TEXT, true));
			jsonPath = file;

			var enemiesArray:Array<Dynamic> = cast jsonData.enemies;
			for (enemyData in enemiesArray)
			{
				var startFrom:EnemyStartForm = LEFT;
				var x:Float = enemyData.x != null ? enemyData.x : 0;
				var y:Float = enemyData.y != null ? enemyData.y : 0;

				addEnemy(startFrom, x, y);
			}
		}
		catch (e:Dynamic)
		{
			trace("Error loading enemy data: " + Std.string(e));
			FlxG.log.error("Error loading enemy data: " + Std.string(e));
		}
	}

	/**
	 * Setup the player to start the funni game
	 */
	function setupPlayer()
	{
		player = new Player(-500, 0);
		player.allowBound = player.allowMove = false;
		player.screenCenter(Y);
		add(player);

		FlxTween.tween(player, {x: 50}, 1, {
			ease: FlxEase.quadOut,
			onComplete: function(tween:FlxTween)
			{
				player.allowMove = true;
				player.allowBound = true;
			}
		});
	}

	/**
	 * Add an enemy to a game, is will also passed into the enemies Array
	 * @param startFrom The position will on what side of the screen the enemy will start
	 * @param x The tween X position
	 * @param y The tween Y position
	 * @param id Um, idk?
	 * @return Enemy object, or null if the enemy already exists
	 */
	public function addEnemy(startFrom:EnemyStartForm, x:Float = 0, y:Float = 0, ?id:Int = 0)
	{
		var enemy:Enemy = new Enemy(700, 0);
		switch (startFrom)
		{
			case LEFT: // left side
				enemy.setPosition(700, 0);
			case RIGHT: // right side
				enemy.setPosition(-100, 0);
			case TOP: // top side
				enemy.setPosition(0, 700);
			case BOTTOM: // bottom side
				enemy.setPosition(0, -100);
		}
		add(enemy);
		enemies.push(enemy);

		FlxTween.tween(enemy, {
			x: x,
			y: y
		}, 1, {
			ease: FlxEase.linear
		});
		return enemy;
	}

	/**
	 * Get an enemy by index number of Array
	 * @param num number index of enemy, is should be exists
	 * @return Enemy
	 */
	public function getEnemy(num:Int):Enemy
	{
		if (num < 0 || num >= enemies.length)
		{
			return null;
		}
		return enemies[num];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(() -> new CreateLevelState());
		}

		if (player.allowMove && FlxG.keys.pressed.Z && shootTimer.finished)
		{
			shoot();
			shootTimer.start(0.1);
		}

		/**
		 * Handle shot functions
		 * 
		 * Include the overlaps of the enemies and when bullet passing out of the screen
		 */
		for (bullet in bullets)
		{
			if (bullet.x > FlxG.width || bullet.x + bullet.width < 0 || bullet.y > FlxG.height || bullet.y + bullet.height < 0)
			{
				remove(bullet);
				bullets.remove(bullet);
				bullet.destroy();
				break;
			}

			for (enemy in enemies)
			{
				if (bullet.overlaps(enemy))
				{
					enemy.health -= 15; // first bullet is so weak
					if (enemy.health <= 0)
					{
						FlxTween.tween(enemy, {x: enemy.x + 20, alpha: 0}, 0.15, {
							ease: FlxEase.linear,
							onComplete: function(tween:FlxTween)
							{
								remove(enemy);
								enemies.remove(enemy);
								enemy.destroy();
							}
						});
					}
					else
					{
						FlxTween.tween(enemy, {x: enemy.x + 5}, 0.05, {
							ease: FlxEase.linear,
							onComplete: function(tween:FlxTween)
							{
								FlxTween.tween(enemy, {x: enemy.x - 5}, 0.05, {ease: FlxEase.linear});
							}
						});
					}

					remove(bullet);
					bullets.remove(bullet);
					bullet.destroy();

					switch (GameData.saveData.howScoreGet.toLowerCase())
					{
						case "normal":
							updateScore(15);
						case "random":
							updateScore(FlxG.random.int(1, 15));
					}

					break;
				}
			}
		}
	}

	/**
	 * Create a bullet and then let it shoot into front of the player ship
	 * @return After create bullet, is will push that bullet into `bullets` Array
	 */
	public function shoot()
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
