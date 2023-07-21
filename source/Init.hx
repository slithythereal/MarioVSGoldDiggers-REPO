package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxTimer;
import haxe.Http;

class Init extends FlxState
{
	var gameVersion:String = 'BETA 1.0';

	override function create()
	{
		super.create();

		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			#if PLAYSTATE
			FlxG.switchState(new PlayState());
			#elseif CUTSCENE
			FlxG.switchState(new CutsceneState('Intro'));
			#else
			FlxG.switchState(TitleScreen());
			#end
		});
		// var http = new haxe.Http("https://raw.githubusercontent.com/TheSlithyGamer4evr/MarioVSGoldDiggers-REPO")
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
