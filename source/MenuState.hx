package;

import flixel.FlxG;
import flixel.FlxState;

class MenuState extends FlxState
{
	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ONE)
		{
			FlxG.switchState(() -> new ModMenuState());
		}

		if (FlxG.keys.justPressed.TWO)
		{
			FlxG.switchState(() -> new PlayState());
		}
	}
}
