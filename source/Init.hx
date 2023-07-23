package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxTimer;
import haxe.Http;

using StringTools;

class Init extends FlxState
{
	public static var gameVersion:String = '1';

	var marioMouse:FlxSprite;

	override function create()
	{
		super.create();

		#if debug
		CommandData.loadDebugCommands();
		#end

		marioMouse = new FlxSprite("assets/images/marioMouse.png");
		FlxG.mouse.load(marioMouse.pixels);

		// fullscreen save code
		if (FlxG.save.data.isFullscreen == null)
			FlxG.save.data.isFullscreen = FlxG.fullscreen;
		else if (FlxG.save.data.isFullscreen)
			FlxG.fullscreen = true;

		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			#if UPDATE_CHECKER
			var http = new Http("https://raw.githubusercontent.com/TheSlithyGamer4evr/MarioVSGoldDiggers-REPO/main/version.txt");
			var theData:Array<String> = [];
			http.onData = function(data:String)
			{
				theData.push('${data.split('\n')[0].trim()}');
				if (!gameVersion.contains(theData[0].trim()))
				{
					trace("OUTDATED LMAO");
					FlxG.switchState(new YouNeedaUpdateLOL());
				}
				else
				{
					trace("game is fine");
					loadState();
				}
			}
			http.onError = function(error)
			{
				trace('error: $error');
				loadState();
			}
			http.request();
			#else
			loadState();
			#end
		});
	}

	function loadState()
	{ // make these first state you open by simply typing `lime test (WHATEVER YOURE COMPILING ON) -D(name here, ex: PLAYSTATE, CUTSCENE, ETC)`
		#if PLAYSTATE
		FlxG.switchState(new PlayState());
		#elseif CUTSCENE
		FlxG.switchState(new CutsceneState('Intro'));
		#elseif UPDATELMAO
		FlxG.switchState(new YouNeedaUpdateLOL());
		#else
		FlxG.switchState(new TitleScreen());
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
