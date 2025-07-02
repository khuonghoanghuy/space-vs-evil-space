package;

class Paths
{
	inline public static function file(name:String)
	{
		return '$name';
	}

	inline public static function images(name:String)
	{
		return file('images/$name.png');
	}

	inline public static function data(name:String)
	{
		return file('assets/data/$name');
	}

	inline public static function sounds(name:String)
	{
		return file('sounds/$name.ogg');
	}

	inline public static function music(name:String)
	{
		return file('music/$name.ogg');
	}
}
