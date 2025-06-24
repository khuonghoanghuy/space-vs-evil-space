package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.system.FlxModding;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		FlxModding.init();
		GameData.initSaveData();

		FlxG.stage.quality = LOW; // Pixel Perfect ig?
		addChild(new FlxGame(0, 0, PlayState));
	}
}
