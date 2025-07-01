package;

import flixel.FlxG;
import flixel.system.FlxModding;
import flixel.system.frontEnds.AssetFrontEnd.FlxAssetType;

class Paths
{
	/**
	 * Use for CreateLevelState, that state cannot using anything related to FlxModding :sob:
	 */
	public static var isCreateLevelState:Bool = false;

	inline public static function file(name:String, type:FlxAssetType, useCache:Bool = true)
	{
		return '$name';
	}

	inline public static function images(name:String)
	{
		return file('images/$name.png', IMAGE, true);
	}

	inline public static function data(name:String)
	{
		// return FlxG.assets.getText(file('data/$name', TEXT, true), true);
		return file('assets/data/$name', TEXT, true);
	}

	inline public static function sounds(name:String)
	{
		return file('sounds/$name.ogg', SOUND, true);
	}

	inline public static function music(name:String)
	{
		return file('music/$name.ogg', SOUND, true);
	}
}
