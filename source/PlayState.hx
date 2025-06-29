package;

import Enemy.EnemyStartForm;
import flixel.FlxG;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import haxe.Json;
import sys.io.File;

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
	 * Player object
	 */
	public var player:Player;

	/**
	 * Enemy objects, by Array
	 */
	public var enemies:Array<Enemy> = [];

	/**
	 * JSON wave file path
	 */
	public var jsonPath:String = "waves/wave1.json";

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

		setupPlayer();

		// how enemy goes will by the json
		setupEnemy(jsonPath);

		// load scripts as same as the wave name, for default scripts loading
		setupScripts(Paths.data('world${worldNum}/level${levelNum}/wave${waveNum}'));
	}

	/**
	 * Tween all of the enemies from the JSON file
	 */
	function setupEnemy(file:String = "waves/wave1.json")
	{
		trace("Loading enemies from: " + Paths.data(file));
		var jsonData = Json.parse(File.getContent(Paths.data(file)));
		if (jsonData == null)
		{
			trace("Error: Could not parse JSON data from " + file);
			return;
		}
		var enemiesArray:Array<Dynamic> = cast jsonData.enemies;
		for (enemyData in enemiesArray)
		{
			// Default to LEFT since CreateLevelState doesn't save startFrom
			var startFrom:EnemyStartForm = LEFT;
			var x:Float = enemyData.x != null ? enemyData.x : 0;
			var y:Float = enemyData.y != null ? enemyData.y : 0;

			addEnemy(startFrom, x, y);
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
	 * Setup a scripts file, this will be used for scripted events
	 * @param file File path of the script file, should be a Haxe-like script with `.hxc` at the end
	 */
	public function setupScripts(file:String)
	{
		if (!sys.FileSystem.exists(file))
		{
			trace('Script file not found: $file');
			return;
		}
		var newScripted = new Scripted(file);
		newScripted.call("create", []);
		scriptedArray.push(newScripted);
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
	}
}
