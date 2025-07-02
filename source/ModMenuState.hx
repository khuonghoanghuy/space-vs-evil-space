package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxModding;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Json;
import sys.io.File;

class ModMenuState extends FlxState
{
	var listModsGroup:FlxTypedGroup<FlxText>;
	var listModsArray:Array<String> = [];
	var currentSelected:Int = 0;

	var createNewModsButton:FlxButton;
	var reloadModsButton:FlxButton;
	var hudUI:FlxSprite;

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
		setupUI();

		FlxModding.reload();
	}

	function setupUI()
	{
		hudUI = new FlxSprite(0, FlxG.height - 55);
		hudUI.makeGraphic(FlxG.width, 200, FlxColor.WHITE);
		hudUI.alpha = 0.6;
		add(hudUI);

		createNewModsButton = new FlxButton(20, FlxG.height - 35, "Create mods", function()
		{
			openSubState(new CreateNewModSubState());
		});
		add(createNewModsButton);

		reloadModsButton = new FlxButton(createNewModsButton.width + 40, createNewModsButton.y, "Reload mods", function()
		{
			FlxG.switchState(() -> new ModMenuState()); // since when loading this state, is actually reload the mods
		});
		add(reloadModsButton);
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
					changeSelectedText(FlxModding.mods[text.ID], text);
				}
			}
		}

		if (FlxG.keys.justPressed.F1)
			openSubState(new TextSubState("Press Up/Down to nagative\nPress ENTER to disable/enable mods", FlxColor.WHITE));
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
		File.saveContent(metaPath, Json.stringify(meta, "\t"));
	}

	function changeSelected(change:Int = 0)
	{
		currentSelected = FlxMath.wrap(currentSelected + change, 0, listModsArray.length - 1);

		var maxVisible = Math.floor((FlxG.height - 100) / 88);
		var start = GameMath.clamp(currentSelected - Std.int(maxVisible / 2), 0, FlxMath.maxInt(0, listModsArray.length - maxVisible));

		var i = 0;
		for (text in listModsGroup)
		{
			var modIndex = start + i;
			if (modIndex < FlxModding.mods.length)
			{
				text.y = 20 + (i * 44);
				text.x = 20;
				var mod = FlxModding.mods[modIndex];
				text = changeSelectedText(mod, text);
				text.ID = modIndex;

				if (modIndex == currentSelected)
					changeSelectedExtract(text);
				else
					text.color = FlxColor.WHITE;

				text.visible = true;
			}
			else
			{
				text.visible = false;
			}
			i++;
		}
	}

	function changeSelectedText(mod:flixel.system.FlxModpack, text:Null<Null<FlxText>>):Null<Null<FlxText>>
	{
		var status = mod.active ? "ENABLE" : "DISABLE";
		text.text = '${mod.name} : $status';
		return text;
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
