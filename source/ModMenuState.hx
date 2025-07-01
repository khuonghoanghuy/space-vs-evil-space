package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxModding;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Json;
import sys.io.File;

class ModMenuState extends FlxState
{
	var listModsGroup:FlxTypedGroup<FlxText>;
	var listModsArray:Array<String> = [];
	var currentSelected:Int = 0;

	override function create()
	{
		FlxModding.reload();
		listModsArray = FlxModding.mods.map(function(mod) return mod.name);

		super.create();

		listModsGroup = new FlxTypedGroup<FlxText>();
		add(listModsGroup);

		for (i in 0...listModsArray.length)
		{
			var text:FlxText = new FlxText(20, (i * 44) + 20, 0, listModsArray[i], 24);
			text.ID = i;
			text.setBorderStyle(OUTLINE, FlxColor.BLACK, 1, 1);
			listModsGroup.add(text);
		}

		changeSelected();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxModding.reload();
			FlxG.switchState(() -> new MenuState());
		}

		if (FlxG.keys.anyJustPressed([UP, W]) || FlxG.keys.anyJustPressed([DOWN, S]))
			changeSelected((FlxG.keys.anyJustPressed([UP, W])) ? -1 : 1);

		if (FlxG.keys.justPressed.ENTER)
		{
			for (text in listModsGroup)
			{
				if (text.ID == currentSelected)
				{
					FlxModding.mods[text.ID].active = !FlxModding.mods[text.ID].active;
					saveModMeta(FlxModding.mods[text.ID]);
					changeSelectedExtract(text); // to change green or red
				}
			}
		}
	}

	function saveModMeta(mod:Dynamic):Void
	{
		@:privateAccess
		var metaPath = FlxModding.modsDirectory + "/" + mod.file + "/" + ".mod_meta";
		var meta = {
			name: mod.name,
			author: mod.author,
			description: mod.description,
			active: mod.active,
			priority: mod.priority
		};
		File.saveContent(metaPath, Json.stringify(meta, null, "    "));
	}

	function changeSelected(change:Int = 0)
	{
		currentSelected = FlxMath.wrap(currentSelected + change, 0, listModsArray.length - 1);

		for (text in listModsGroup)
		{
			if (text.ID == currentSelected)
			{
				changeSelectedExtract(text);
			}
			else
			{
				text.color = FlxColor.WHITE;
			}
		}
	}

	function changeSelectedExtract(text:FlxText):Void
	{
		if (FlxModding.mods[text.ID].active)
		{
			text.color = FlxColor.LIME;
		}
		else
		{
			text.color = FlxColor.RED;
		}
	}
}
