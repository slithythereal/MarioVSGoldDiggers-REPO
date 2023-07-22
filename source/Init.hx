package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxTimer;
import haxe.Http;

class Init extends FlxState
{
	public static var gameVersion:String = 'balls'; // 1.0.0
	public static var updateVersion:String = '';

	override function create()
	{
		super.create();

		#if debug
		CommandData.loadDebugCommands();
		#end

		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			/*
				#if UPDATE_CHECKER
				var http = new haxe.Http("https://raw.githubusercontent.com/TheSlithyGamer4evr/MarioVSGoldDiggers-REPO/main/version.txt");
				http.onData = function(data:String)
				{
					updateVersion = data.split('\n')[0].trim();
					if (updateVersion != gameVersion)
					{
						trace("you needa update lol");
						FlxG.switchState(new YouNeedaUpdateLOL());
					}
					else
						loadState();
				}
				#else
				loadState();
				#end
			 */
			loadState();
		});
	}

	function loadState()
	{
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
