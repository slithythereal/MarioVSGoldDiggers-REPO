package substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import objs.GameSprite.GameText;
import objs.HeadsUpTxt;
import substate.*;

class OptionsSubState extends FlxSubState
{
	var curOption:Int = 0;
	var optionArray:Array<String> = ['Fullscreen', 'Credits', 'Intro Cutscene', 'Exit Options', 'Exit Game'];
	var optionGrp:FlxTypedGroup<GameText>;
	var headsUpGrp:FlxTypedGroup<HeadsUpTxt>;
	var ogStateHasMouse:Bool;

	public function new(ogStateHasMouse:Bool)
	{
		super();
		this.ogStateHasMouse = ogStateHasMouse;

		if (!ogStateHasMouse)
			FlxG.mouse.visible = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.5;
		add(bg);

		optionGrp = new FlxTypedGroup<GameText>();
		add(optionGrp);

		for (i in 0...optionArray.length)
		{
			var txt:GameText = new GameText(0, 25 + (i * 100), 0, '${optionArray[i]}');
			txt.setFormat(null, 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			txt.borderSize = 3;
			txt.ID = i;
			txt.screenCenter(X);
			txt._dynamic.switchColor = function(isRed:Bool)
			{
				if (isRed)
				{
					txt.borderColor = FlxColor.RED;
					txt.borderSize = 1.5;
				}
				else
				{
					txt.borderColor = FlxColor.BLACK;
					txt.borderSize = 3;
				}
			}
			optionGrp.add(txt);
		}

		headsUpGrp = new FlxTypedGroup<HeadsUpTxt>();
		add(headsUpGrp);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		optionGrp.forEach(function(txt:GameText)
		{
			if (FlxG.mouse.overlaps(txt))
			{
				curOption = txt.ID;
				if (FlxG.mouse.justPressed)
					coolFunction('${optionArray[curOption]}');
			}
			if (txt.ID == curOption)
				txt._dynamic.switchColor(true);
			else
				txt._dynamic.switchColor(false);
		});
		if (FlxG.keys.anyJustPressed([W, UP]))
			changeOption(-1);
		if (FlxG.keys.anyJustPressed([S, DOWN]))
			changeOption(1);
		if (FlxG.keys.anyJustPressed([ENTER, SPACE]))
			coolFunction('${optionArray[curOption]}');
		if (FlxG.keys.justPressed.ESCAPE)
		{
			if (!ogStateHasMouse)
				FlxG.mouse.visible = false;
			close();
		}
	}

	function coolFunction(daFunc:String)
	{
		switch (daFunc)
		{
			case 'Fullscreen':
				FlxG.fullscreen = !FlxG.fullscreen;
				FlxG.save.data.isFullscreen = FlxG.fullscreen;
				addHeadsUpText('IsFullscreen: ${FlxG.save.data.isFullscreen}', 2);
			case 'Credits':
				openSubState(new CreditsSubState());
			case 'Exit Game':
				Sys.exit(1);
			case 'Exit Options':
				close();
			case 'Intro Cutscene':
				TitleScreen.hasIntroCutscene = !TitleScreen.hasIntroCutscene;
				FlxG.save.data.startsIntroCutscene = !FlxG.save.data.startsIntroCutscene;
				addHeadsUpText('HasIntroCutscene: ${FlxG.save.data.startsIntroCutscene}', 2);
			default:
				trace("no func here");
		}
		FlxG.save.flush();
	}

	function changeOption(cool:Int)
	{
		curOption += cool;

		if (curOption >= optionArray.length)
			curOption = 0;
		if (curOption < 0)
			curOption = optionArray.length - 1;

		optionGrp.forEach(function(txt:GameText)
		{
			txt._dynamic.switchColor(false);
			if (txt.ID == curOption)
				txt._dynamic.switchColor(true);
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
