package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import sys.FileSystem;
import sys.io.File;

using StringTools;

typedef CreditEntry =
{
	var role:String;
	var name:String;
	var desc:String;
	var url:String;
}

class CreditsState extends FlxState
{
	var creditsList:Array<CreditEntry> = [];
	var creditsTextGroup:Array<FlxText> = [];
	var currentSelected:Int = 0;
	var infoPanel:FlxSprite;
	var infoText:FlxText;
	var infoVisible:Bool = false;

	override function create()
	{
		super.create();
		joinCredits();
		setupUI();
	}

	function setupUI()
	{
		// Clear previous
		for (t in creditsTextGroup)
			remove(t);
		creditsTextGroup = [];

		// List credits
		for (i in 0...creditsList.length)
		{
			var entry = creditsList[i];
			var t = new FlxText(20, (i * 44) + 20, 0, '${entry.role}: ${entry.name}', 24);
			t.ID = i;
			t.setBorderStyle(OUTLINE, FlxColor.BLACK, 1, 1);
			add(t);
			creditsTextGroup.push(t);
		}

		infoPanel = new FlxSprite(FlxG.width, 0);
		infoPanel.makeGraphic(300, FlxG.height, FlxColor.WHITE);
		infoPanel.alpha = 0.85;
		add(infoPanel);

		infoText = new FlxText(infoPanel.x + 20, 40, 260, "", 18);
		infoText.setBorderStyle(OUTLINE, FlxColor.BLACK);
		infoText.color = FlxColor.WHITE;
		add(infoText);

		updateSelection();
	}

	function updateSelection(change:Int = 0)
	{
		currentSelected = FlxMath.wrap(currentSelected + change, 0, creditsList.length - 1);
		var maxVisible = Math.floor((FlxG.height - 100) / 88);
		var start = GameMath.clamp(currentSelected - Std.int(maxVisible / 2), 0, FlxMath.maxInt(0, creditsList.length - maxVisible));

		var i = 0;
		for (txt in creditsTextGroup)
		{
			var optIndex = start + i;
			if (optIndex < creditsList.length)
			{
				txt.y = 20 + (i * 50);
				txt.x = 20;
				txt.ID = optIndex;

				if (optIndex == currentSelected)
				{
					FlxTween.cancelTweensOf(txt);
					FlxTween.color(txt, 0.2, txt.color, FlxColor.YELLOW, {ease: FlxEase.sineInOut});
					txt.alpha = 1;
				}
				else
				{
					FlxTween.cancelTweensOf(txt);
					FlxTween.color(txt, 0.2, txt.color, FlxColor.WHITE, {ease: FlxEase.sineInOut});
					txt.alpha = 0.6;
				}
				txt.visible = true;
			}
			else
			{
				txt.visible = false;
			}
			i++;
		}
		showInfo();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([UP, W, DOWN, S]))
		{
			updateSelection((FlxG.keys.anyJustPressed([UP, W])) ? -1 : 1);
		}

		if (FlxG.keys.justPressed.Q)
		{
			infoVisible = !infoVisible;
			var targetX = infoVisible ? FlxG.width - 300 : FlxG.width;
			FlxTween.tween(infoPanel, {x: targetX}, 0.3, {ease: FlxEase.sineInOut});
			FlxTween.tween(infoText, {x: targetX + 20}, 0.3, {ease: FlxEase.sineInOut});
			if (infoVisible)
				showInfo();
		}

		if (infoVisible)
			showInfo();

		if (FlxG.keys.justPressed.ENTER)
		{
			var entry = creditsList[currentSelected];
			if (entry.url != null && entry.url.trim() != "")
			{
				FlxG.openURL(entry.url);
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(() -> new MenuState());
	}

	function showInfo()
	{
		var entry = creditsList[currentSelected];
		infoText.text = 'Role: ${entry.role}\n' + 'Name: ${entry.name}\n' + 'Desc: ${entry.desc}';
	}

	function joinCredits()
	{
		creditsList = [];
		// Load main credits
		parseCreditsFile("assets/data/credits.txt");

		// Load mod credits
		if (FileSystem.exists("mods"))
		{
			for (mod in FileSystem.readDirectory("mods"))
			{
				var modCredits = 'mods/$mod/credits.txt';
				if (FileSystem.exists(modCredits))
				{
					parseCreditsFile(modCredits);
				}
			}
		}
	}

	function parseCreditsFile(path:String)
	{
		var lines = File.getContent(path).split("\n");
		for (line in lines)
		{
			if (line.trim() == "" || line.startsWith("role,"))
				continue; // skip header/empty
			var parts = line.split(",");
			var entry:CreditEntry = {
				role: parts[0] != "" ? parts[0] : "Contributor",
				name: parts[1],
				desc: parts[2],
				url: parts[3]
			};
			creditsList.push(entry);
		}
	}
}
