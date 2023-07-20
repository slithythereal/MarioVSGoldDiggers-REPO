package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSubState;

class CommandData
{
	public static function loadDebugCommands()
	{
		FlxG.console.registerFunction("toggleHitbox", function()
		{
			FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
		});
	}

	public static function watch(obj:FlxObject)
	{
		FlxG.watch.add(obj, 'x');
		FlxG.watch.add(obj, 'y');
	}
}
