package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import options.Option;

class OptionsState extends FlxState
{
	var options:Array<Option> = [
		new Option("Allow slow move", "Move slower when hold shift", OptionType.Toggle, GameData.saveData.allowSlowMove)
	];
	var grpOptions:FlxTypedGroup<FlxText>;
	var curSelected:Int = 0;
	var description:FlxText;

	override function create()
	{
		super.create();

		options.push(new Option('Return', "Return to main menu", OptionType.Function, function():Void
		{
			FlxG.switchState(() -> new MenuState());
			GameData.saveDataSettings();
		}));

		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionTxt:FlxText = new FlxText(20, 20 + (i * 50), 0, options[i].toString(), 18);
			optionTxt.setFormat(null, 24, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			optionTxt.ID = i;
			grpOptions.add(optionTxt);
		}

		description = new FlxText(0, FlxG.height * 0.9, FlxG.width * 0.9, '', 20);
		description.setFormat(null, 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		description.screenCenter(X);
		description.scrollFactor.set();
		add(description);

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)
			changeSelection(FlxG.keys.justPressed.UP ? -1 : 1);

		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.LEFT)
		{
			if (options[curSelected].type != OptionType.Function)
				changeValue(FlxG.keys.justPressed.RIGHT ? 1 : -1);
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			final option:Option = options[curSelected];
			if (option != null)
				option.execute();
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(() -> new MenuState());
			GameData.saveDataSettings();
		}
	}

	private function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);

		// Calculate visible range (center selected, like ModMenuState)
		var maxVisible = Math.floor((FlxG.height - 100) / 50); // 50 is the height step per option
		var start = GameMath.clamp(curSelected - Std.int(maxVisible / 2), 0, FlxMath.maxInt(0, options.length - maxVisible));

		var i = 0;
		for (txt in grpOptions)
		{
			var optIndex = start + i;
			if (optIndex < options.length)
			{
				txt.y = 20 + (i * 50);
				txt.x = 20;
				txt.text = options[optIndex].toString();
				txt.ID = optIndex;

				if (optIndex == curSelected)
				{
					// Smooth color transition for selected
					FlxTween.cancelTweensOf(txt);
					FlxTween.color(txt, 0.2, txt.color, FlxColor.YELLOW, {ease: FlxEase.sineInOut});
					txt.alpha = 1;
				}
				else
				{
					FlxTween.cancelTweensOf(txt);
					FlxTween.color(txt, 0.2, txt.color, FlxColor.WHITE, {ease: FlxEase.sineInOut});
					txt.alpha = 0.6;
				}
				txt.visible = true;
			}
			else
			{
				txt.visible = false;
			}
			i++;
		}

		var option = options[curSelected];
		if (option.desc != null)
		{
			description.text = option.desc;
			description.screenCenter(X);
		}
	}

	private function changeValue(direction:Int = 0):Void
	{
		final option:Option = options[curSelected];

		if (option != null)
		{
			option.changeValue(direction);

			grpOptions.forEach(function(txt:FlxText):Void
			{
				if (txt.ID == curSelected)
					txt.text = option.toString();
			});
		}
	}
}
