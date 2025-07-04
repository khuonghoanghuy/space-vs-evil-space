package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * This class help display lot of text
 */
class TextSubState extends FlxSubState
{
	var daText:FlxText;

	public function new(text:String, bgColor:FlxColor, ?doSomething:Void->Void)
	{
		super();

		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, bgColor);
		bg.alpha = 0.6;
		add(bg);

		daText = new FlxText(0, 0, 0, text, 24);
		daText.autoSize = true;
		daText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1, 1);
		daText.screenCenter();
		daText.alignment = CENTER;
		add(daText);

		if (doSomething != null)
		{
			doSomething();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			this.close();
		}
	}
}
