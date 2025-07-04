package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PauseSubState extends FlxSubState
{
	var listGroup:FlxTypedGroup<FlxText>;
	var listArray:Array<String> = ["Resume", "Restart", "Return"];
	var currentSelected:Int = 0;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		bg.alpha = 0.6;
		add(bg);

		super.create();

		var title = new FlxText(20, 20, 0, "Game Paused", 32);
		title.scrollFactor.set();
		title.setBorderStyle(OUTLINE, FlxColor.BLACK, 1, 1);
		add(title);

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
				case "resume":
					persistentUpdate = true;
					this.close();
				case "restart":
					this.close();
					FlxG.resetState();
				case "return":
					this.close();
					FlxG.switchState(() -> new MenuState());
			}
		}
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
