package;

class Paths
{
	inline public static function images(name:String)
	{
		return 'assets/images/' + name + '.png';
	}

	inline public static function data(name:String)
	{
		return 'assets/data/' + name;
	}

	inline public static function sounds(name:String)
	{
		return 'assets/sounds/' + name + '.ogg';
	}

	inline public static function music(name:String)
	{
		return 'assets/music/' + name + '.ogg';
	}
}
