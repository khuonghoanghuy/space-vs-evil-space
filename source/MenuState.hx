package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxModding;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	var listGroup:FlxTypedGroup<FlxText>;
	var listArray:Array<String> = ["Play", "Mods", "Setting", "Exit"];
	var currentSelected:Int = 0;

	override function create()
	{
		super.create();

		FlxModding.reload();

		listGroup = new FlxTypedGroup<FlxText>();
		add(listGroup);

		for (i in 0...listArray.length)
		{
			var text:FlxText = new FlxText(20, FlxG.height - 300 + ((i * 44) + 20), 0, listArray[i], 24);
			text.ID = i;
			text.setBorderStyle(OUTLINE, FlxColor.BLACK, 1, 1);
			listGroup.add(text);
		}

		changeSelected();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([UP, W]) || FlxG.keys.anyJustPressed([DOWN, S]))
			changeSelected((FlxG.keys.anyJustPressed([UP, W])) ? -1 : 1);

		if (FlxG.keys.justPressed.ENTER)
		{
			switch (listArray[currentSelected].toLowerCase())
			{
				case "play":
					FlxG.switchState(() -> new PlayState());
				case "mods":
					FlxG.switchState(() -> new ModMenuState());
				case "settings":
					FlxG.switchState(() -> new OptionsState());
				case "exit":
					Sys.exit(0);
			}
		}

		if (FlxG.keys.justPressed.SEVEN)
			FlxG.switchState(() -> new CreateLevelState());
	}

	function changeSelected(change:Int = 0)
	{
		currentSelected = FlxMath.wrap(currentSelected + change, 0, listArray.length - 1);

		for (text in listGroup)
		{
			if (text.ID == currentSelected)
			{
				text.color = FlxColor.YELLOW;
			}
			else
			{
				text.color = FlxColor.WHITE;
			}
		}
	}
}
