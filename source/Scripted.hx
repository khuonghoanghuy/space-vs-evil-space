package;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig.RawIrisConfig;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import haxe.PosInfos;
import sys.io.File;

class Scripted
{
	public var iris:Iris;
	public final irisConfig:RawIrisConfig;

	public function new(file:String)
	{
		irisConfig = {autoPreset: true, name: file, autoRun: false};
		iris = new Iris(File.getContent(file + '.hxc'), irisConfig);

		iris.set('trace', function(text:Dynamic, ?posInfo:PosInfos)
		{
			Iris.print(Std.string(text), posInfo);
		});
		iris.set('FlxSprite', FlxSprite);
		iris.set('FlxG', FlxG);
		iris.set('FlxText', FlxText);
		iris.set('FlxCamera', FlxCamera);
		iris.set('Paths', Paths);

		iris.set('game', PlayState.instance);

		iris.execute();
	}

	public function call(fun:String, args:Array<Dynamic>):Dynamic
	{
		if (iris.exists(fun))
		{
			return iris.call(fun, args);
		}
		return null;
	}
}
