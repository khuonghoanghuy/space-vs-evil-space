package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.system.FlxModding;
import flixel.text.FlxInputText;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Json;
import sys.io.File;

class CreateNewModSubState extends FlxSubState
{
	var title:FlxText;
	var hint:FlxText;
	var inputText:FlxInputText;

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		bg.alpha = 0.6;
		add(bg);

		title = new FlxText(20, 20, 0, "Create New Mods", 32);
		title.scrollFactor.set();
		title.setBorderStyle(OUTLINE, FlxColor.BLACK, 1, 1);
		add(title);

		hint = new FlxText(20, title.height + 20, "Press ENTER to create\nPress ESCAPE to cancel", 18);
		hint.scrollFactor.set();
		hint.setBorderStyle(OUTLINE, FlxColor.BLACK, 1, 1);
		add(hint);

		inputText = new FlxInputText(0, 0, 200, "example");
		inputText.setFormat(null, 16, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		inputText.screenCenter();
		inputText.scrollFactor.set(0, 0);
		add(inputText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ENTER)
		{
			createMods();
			close();
			FlxG.switchState(() -> new ModMenuState());
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			close();
			FlxModding.reload();
		}
	}

	function createMods()
	{
		FlxModding.create(Std.string(inputText.text));
		@:privateAccess
		var metaPath = FlxModding.modsDirectory + "/" + Std.string(inputText.text) + "/" + ".mod_meta";
		var meta = {
			name: inputText.text,
			author: "Unknow",
			description: "",
			active: false,
			priority: 1
		};
		File.saveContent(metaPath, Json.stringify(meta, "\t"));
	}
}
