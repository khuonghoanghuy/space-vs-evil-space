package;

import flixel.system.FlxModding;

class Paths
{
	inline public static function images(name:String)
	{
		return FlxModding.system != null ? FlxModding.system.getAsset('assets/images/' + name + '.png', IMAGE, true) : 'assets/images/' + name + '.png';
	}

	inline public static function data(name:String)
	{
		return FlxModding.system != null ? FlxModding.system.getAsset('assets/data/' + name, TEXT, false) : 'assets/data/' + name;
	}

	inline public static function sounds(name:String)
	{
		return FlxModding.system != null ? FlxModding.system.getAsset('assets/sounds/' + name + '.ogg', SOUND, true) : 'assets/sounds/' + name + '.ogg';
	}

	inline public static function music(name:String)
	{
		return FlxModding.system != null ? FlxModding.system.getAsset('assets/music/' + name + '.ogg', SOUND, true) : 'assets/music/' + name + '.ogg';
	}
}
