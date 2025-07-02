package;

import flixel.FlxG;
import flixel.FlxState;

class OptionsState extends FlxState
{
	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.save.flush();
			FlxG.switchState(() -> new MenuState());
		}
	}
}
