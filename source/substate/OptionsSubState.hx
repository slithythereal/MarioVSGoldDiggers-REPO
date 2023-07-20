package substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import substate.*;
import objs.HeadsUpTxt;

class OptionsSubState extends FlxSubState
{
	var curOption:Int = 0;
	var optionArray:Array<String> = ['Fullscreen', 'Credits', 'Intro Cutscene', 'Exit Options', 'Exit Game'];
	var optionGrp:FlxTypedGroup<FlxText>;
	var headsUpGrp:FlxTypedGroup<HeadsUpTxt>;

	public function new()
	{
		super();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.5;
		add(bg);

		optionGrp = new FlxTypedGroup<FlxText>();
		add(optionGrp);

		for (i in 0...optionArray.length)
		{
			var txt:FlxText = new FlxText(0, 25 + (i * 100), 0, '${optionArray[i]}');
			txt.setFormat(null, 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			txt.borderSize = 3;
			txt.ID = i;
			txt.screenCenter(X);
			optionGrp.add(txt);
		}
		
		headsUpGrp = new FlxTypedGroup<HeadsUpTxt>();
		add(headsUpGrp);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		optionGrp.forEach(function(txt:FlxText)
		{
			if (FlxG.mouse.overlaps(txt))
			{
				curOption = txt.ID;
				if (FlxG.mouse.justPressed)
					coolFunction('${optionArray[curOption]}');
			}
			if (txt.ID == curOption)
			{
				txt.borderColor = FlxColor.RED;
				txt.borderSize = 1.5;
			}
			else
			{
				txt.borderColor = FlxColor.BLACK;
				txt.borderSize = 3;
			}
		});
		if (FlxG.keys.anyJustPressed([W, UP]))
			changeOption(-1);
		if (FlxG.keys.anyJustPressed([S, DOWN]))
			changeOption(1);
		if (FlxG.keys.anyJustPressed([ENTER, SPACE]))
			coolFunction('${optionArray[curOption]}');
		if (FlxG.keys.justPressed.ESCAPE)
			close();
	}

	function coolFunction(daFunc:String)
	{
		switch (daFunc)
		{
			case 'Fullscreen':
				FlxG.fullscreen = !FlxG.fullscreen;
				addHeadsUpText('IsFullscreen: ${FlxG.fullscreen}', 2);
			case 'Credits':
				openSubState(new CreditsSubState());
			case 'Exit Game':
				Sys.exit(1);
			case 'Exit Options':
				close();
			case 'Intro Cutscene':
				TitleScreen.hasIntroCutscene = !TitleScreen.hasIntroCutscene;
				addHeadsUpText('HasIntroCutscene: ${TitleScreen.hasIntroCutscene}', 2);
				FlxG.save.data.startsIntroCutscene = TitleScreen.hasIntroCutscene;
			default:
				trace("no func here");
		}
	}

	function changeOption(cool:Int)
	{
		curOption += cool;

		if (curOption >= optionArray.length)
			curOption = 0;
		if (curOption < 0)
			curOption = optionArray.length - 1;

		optionGrp.forEach(function(txt:FlxText)
		{
			txt.borderColor = FlxColor.BLACK;
			txt.borderSize = 3;
			if (txt.ID == curOption)
			{
				txt.borderColor = FlxColor.RED;
				txt.borderSize = 1.5;
			}
		});
	}

	function addHeadsUpText(text:String, seconds:Float, ?color:FlxColor = FlxColor.WHITE) // doom popup text lol
	{
		if (headsUpGrp.members.length > 4)
		{
			var sieggy = headsUpGrp.members[4]; // sieggy variable
			sieggy.destroy();
			headsUpGrp.remove(sieggy);
		}
		headsUpGrp.forEachAlive(function(spr:HeadsUpTxt)
		{
			spr.y += 35;
		});
		headsUpGrp.insert(0, new HeadsUpTxt(text, headsUpGrp, seconds, color));
	}
}
