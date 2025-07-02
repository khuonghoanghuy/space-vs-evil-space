package;

import flixel.FlxG;

@:structInit class SaveData
{
	public var howScoreGet:String = "Normal";
	public var framerate:Int = 60;
	public var allowSlowMove:Bool = true;
}

class GameData
{
	public static var saveData:SaveData = {};

	public static function initSaveData()
	{
		for (key in Reflect.fields(saveData))
			if (Reflect.field(FlxG.save.data, key) != null)
				Reflect.setField(saveData, key, Reflect.field(FlxG.save.data, key));
	}

	public static function saveDataSettings()
	{
		for (key in Reflect.fields(saveData))
			Reflect.setField(FlxG.save.data, key, Reflect.field(saveData, key));

		FlxG.save.flush();
	}
}
