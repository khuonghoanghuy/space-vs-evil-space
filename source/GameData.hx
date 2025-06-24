package;

import flixel.FlxG;

@:structInit class SaveData
{
	public var name:String = "";
	public var totalScore:Int = 0;
	public var totalCash:Int = 0;
}

class GameData
{
	public static var saveData:SaveData = {};

	public static function getSaveData(fieldName:String):Dynamic
	{
		return Reflect.getProperty(saveData, fieldName);
	}

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
