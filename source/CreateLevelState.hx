package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxInputText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import sys.io.File;

class CreateLevelState extends FlxState
{
	var player:Player;
	var enemies:Array<Enemy> = [];

	var gridLine:FlxSprite;
	var nameLevelInput:FlxInputText;
	var allowType:Bool = false;
	var saveButton:FlxButton;
	var openButton:FlxButton;

	public function new()
	{
		super();
		Paths.isCreateLevelState = true;
	}

	override public function create()
	{
		super.create();

		gridLine = new FlxSprite();
		var gfx = gridLine.makeGraphic(FlxG.width, FlxG.height, 0x00000000, true);
		for (x in 0...Std.int(FlxG.width / 32) + 1)
		{
			gfx.pixels.fillRect(new openfl.geom.Rectangle(x * 32, 0, 1, FlxG.height), 0x55FFFFFF);
		}
		for (y in 0...Std.int(FlxG.height / 32) + 1)
		{
			gfx.pixels.fillRect(new openfl.geom.Rectangle(0, y * 32, FlxG.width, 1), 0x55FFFFFF);
		}
		gridLine.pixels = gfx.pixels;
		gridLine.dirty = true;
		add(gridLine);

		player = new Player(50, 0);
		player.allowMove = false;
		player.screenCenter(Y);
		add(player);

		nameLevelInput = new FlxInputText(FlxG.width / 2 - 100, FlxG.height - 50, 200, "wave1");
		nameLevelInput.setFormat(null, 16, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		nameLevelInput.scrollFactor.set(0, 0);
		add(nameLevelInput);
		nameLevelInput.visible = false;

		saveButton = new FlxButton(FlxG.width - 100, FlxG.height - 50, "Save", saveFunction);
		saveButton.loadGraphic(Paths.images("button"), true, 80, 20);
		saveButton.animation.add("idle", [0]);
		saveButton.animation.add("hover", [1]);
		saveButton.animation.add("pressed", [2, 3, 0]);
		saveButton.animation.play("idle");
		saveButton.scrollFactor.set(0, 0);
		add(saveButton);
		saveButton.visible = false;

		saveButton = new FlxButton(FlxG.width - 180, FlxG.height - 50, "Save", saveFunction);
		saveButton.loadGraphic(Paths.images("button"), true, 80, 20);
		saveButton.animation.add("idle", [0]);
		saveButton.animation.add("hover", [1]);
		saveButton.animation.add("pressed", [2, 3, 0]);
		saveButton.animation.play("idle");
		saveButton.scrollFactor.set(0, 0);
		add(saveButton);
		saveButton.visible = false;

		openButton = new FlxButton(FlxG.width - 90, FlxG.height - 50, "Open", openFunction);
		openButton.loadGraphic(Paths.images("button"), true, 80, 20);
		openButton.animation.add("idle", [0]);
		openButton.animation.add("hover", [1]);
		openButton.animation.add("pressed", [2, 3, 0]);
		openButton.animation.play("idle");
		openButton.scrollFactor.set(0, 0);
		add(openButton);
		openButton.visible = false;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed && !allowType)
		{
			addEnemy(FlxG.mouse.viewX, FlxG.mouse.viewY);
		}
		if (FlxG.mouse.justPressedRight && !allowType)
		{
			removeEnemy(FlxG.mouse.viewX, FlxG.mouse.viewY);
		}

		if (FlxG.keys.justPressed.TAB)
			allowType = !allowType;
		nameLevelInput.visible = saveButton.visible = openButton.visible = allowType;
		if (FlxG.mouse.overlaps(saveButton))
		{
			saveButton.animation.play("hover");
			if (FlxG.mouse.justPressed)
			{
				saveButton.animation.play("pressed");
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			Paths.isCreateLevelState = false;
			FlxG.switchState(() -> new PlayState());
		}

		if (FlxG.keys.justPressed.CONTROL && FlxG.keys.justPressed.S)
		{
			saveFunction();
		}
	}

	// Save the level
	function saveFunction():Void
	{
		var levelData = {
			enemies: enemies.map(e ->
			{
				var gridX = Std.int(e.x / 32);
				var gridY = Std.int(e.y / 32);
				return {
					id: 'enemy_${gridX}_${gridY}',
					x: e.x,
					y: e.y
				};
			})
		};
		var json = haxe.Json.stringify(levelData, '\t');
		var dir = "saveContent";
		if (!sys.FileSystem.exists(dir))
		{
			sys.FileSystem.createDirectory(dir);
		}
		var fileName = dir + "/" + Std.string(nameLevelInput.text) + ".json";
		File.saveContent(fileName, json);
		FlxG.log.add("Level saved to " + fileName);
	}

	// Open the level
	function openFunction():Void
	{
		if (!sys.FileSystem.exists("saveContent/" + nameLevelInput.text + ".json"))
		{
			trace('Level file not found: ${"saveContent/" + nameLevelInput.text + ".json"}');
			return;
		}

		try
		{
			for (enemy in enemies)
			{
				remove(enemy);
				enemy.destroy();
			}
			enemies = [];

			var levelData = haxe.Json.parse(File.getContent("saveContent/" + nameLevelInput.text + ".json"));
			var enemiesArray:Array<Dynamic> = cast levelData.enemies;
			for (enemyData in enemiesArray)
			{
				addEnemy(enemyData.x, enemyData.y);
			}
		}
		catch (e:Dynamic)
		{
			trace('Have some trouble while loading ${"saveContent/" + nameLevelInput.text + ".json"}: ${Std.string(e)}');
			return;
		}
	}

	function addEnemy(x:Float, y:Float)
	{
		var gridX = Math.floor(x / 32) * 32;
		var gridY = Math.floor(y / 32) * 32;
		var enemy = new Enemy(gridX, gridY);
		add(enemy);
		enemies.push(enemy);
	}

	function removeEnemy(x:Float, y:Float)
	{
		if (enemies.length == 0)
			return;
		var gridX = Math.floor(x / 32) * 32;
		var gridY = Math.floor(y / 32) * 32;
		for (i in 0...enemies.length)
		{
			var enemy = enemies[i];
			if (enemy.x == gridX && enemy.y == gridY)
			{
				remove(enemy);
				enemies.splice(i, 1);
				enemy.destroy();
				return;
			}
		}
	}
}
