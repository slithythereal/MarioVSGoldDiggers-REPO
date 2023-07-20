package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	var screenSize:Array<Int> = [640, 480];
	var initialState:Null<Class<flixel.FlxState>> = #if PLAYSTATE PlayState #elseif CUTSCENE CutsceneState #else TitleScreen #end;
	var zoom:Float = 1;
	var frameRate:Int = 60;
	var updateframerate:Int = 60;
	var skipSplash:Bool = true;
	var fullscreen:Bool = #if hl false #else true #end;

	public function new()
	{
		super();
		addChild(new FlxGame(screenSize[0], screenSize[1], initialState, zoom, updateframerate, frameRate, skipSplash, fullscreen));
	}
}
