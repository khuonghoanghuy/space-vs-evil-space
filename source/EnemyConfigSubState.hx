package;

import Enemy.EnemyStartForm;
import Enemy.EnemyType;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class EnemyConfigSubState extends FlxSubState
{
	var enemy:Enemy;

	public function new(enemy:Enemy)
	{
		super();
		this.enemy = enemy;
	}

	var infoText:FlxText;
	var typeSelect:String = "";

	override public function create()
	{
		super.create();

		var types = [
			EnemyType.NORMAL,
			EnemyType.SHOOTER,
			EnemyType.FAST_MOVE,
			EnemyType.LASER_SHOOTER
		];
		var forms = [
			EnemyStartForm.LEFT,
			EnemyStartForm.RIGHT,
			EnemyStartForm.TOP,
			EnemyStartForm.BOTTOM,
		];

		var currentType = types.indexOf(enemy.type);
		if (currentType == -1)
			currentType = 0;
		var currentForm = forms.indexOf(enemy.startFrom);
		if (currentForm == -1)
			currentForm = 0;

		typeSelect = Std.string(types[currentType]);

		infoText = new FlxText(10, 10, 0, getInfoText(types, currentType, forms, currentForm));
		add(infoText);

		add(new FlxButton(10, 40, "Close", function() close()));

		add(new FlxButton(10, 70, "Set Type", function()
		{
			currentType = (currentType + 1) % types.length;
			enemy.setType(types[currentType]);
			typeSelect = Std.string(types[currentType]);
			infoText.text = getInfoText(types, currentType, forms, currentForm);
		}));

		add(new FlxButton(10, 110, "Set Place Move", function()
		{
			currentForm = (currentForm + 1) % forms.length;
			enemy.setStartFrom(forms[currentForm]);
			infoText.text = getInfoText(types, currentType, forms, currentForm);
		}));
	}

	function getInfoText(types:Array<Dynamic>, currentType:Int, forms:Array<Dynamic>, currentForm:Int):String
	{
		return 'Config Enemy at ('
			+ enemy.x
			+ ', '
			+ enemy.y
			+ ')\nType Enemy: ${types[currentType]}\nStart Form: ${forms[currentForm]}';
	}
}
