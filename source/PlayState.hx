package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import objs.*;

class PlayState extends FlxState
{
	public static var mario:Mario;

	var shield:Shield;
	var canShield:Bool = true;
	var marioHitbox:FlxSprite;
	var hookerGrp:FlxTypedGroup<Hooker>;
	var bulletGrp:FlxTypedGroup<Bullet>;
	var hookerCount:Int = 1;
	var maxHookersPerWave:Int = 1;
	var curWave:Int = 1;
	var waveTxt:FlxText;
	var hookersKilled:Int = 0;
	var bg:FlxSprite;
	var curLevel:Int = 0;
	var levels:Array<String> = ['overworld', 'underground', 'underwater', 'castle'];
	var introHooker:Array<Array<Dynamic>> = [
		['hooker', FlxColor.WHITE, "TIP: Just shoot the hooker normally!"],
		[
			'buff hooker',
			FlxColor.WHITE,
			"TIP: Shoot the hooker about 3 times, there is a chance it'll spawn more tho!"
		],
		['pogo hooker', FlxColor.WHITE, "TIP: Shoot the hooker at about the right time!"],
		[
			'bomb hooker',
			FlxColor.RED,
			"TIP: DO NOT SHOOT THE HOOKER AT ALL\nINSTEAD PRESS THE SHIFT KEY ABOUT 2 SECONDS AFTER IT SPAWNS"
		]
	];
	var curIntroHooker:Int = 0;
	var marioOffsets:Array<Array<Float>> = [[21, 311], [21, 360], [21, 336], [21, 360]];
	var bulletOffsets:Array<Array<Float>> = [[152, 370], [152, 417], [152, 394], [152, 417]];
	var hookerOffsets:Array<Array<Float>> = [[575, 675, 316], [575, 675, 363], [575, 675, 339], [575, 675, 363]];
	var pPlatformOffsets:Array<Array<Float>> = [[0, 433], [0, 480], [0, 457], [0, 480]];
	var flash:Flash;
	var onceInWaves:Int = 8;
	var pogoPlatform:FlxSprite;
	var hookerMultiplier:Int = 5;
	var headsUpGrp:FlxTypedGroup<HeadsUpTxt>;
	var bombCanDamage:Bool = false;

	override public function create()
	{
		super.create();

		#if debug
		CommandData.loadDebugCommands();
		#end

		FlxG.sound.playMusic('assets/music/${levels[curLevel]}.ogg', 0.7, true); // ty cakie
		FlxG.mouse.visible = false;

		hookerCount = maxHookersPerWave;

		bg = new FlxSprite().loadGraphic('assets/images/levels/${levels[curLevel]}.png');
		bg.scale.set(1.2, 1.225);
		bg.updateHitbox();
		add(bg);

		bulletGrp = new FlxTypedGroup<Bullet>();
		add(bulletGrp);

		hookerGrp = new FlxTypedGroup<Hooker>();
		add(hookerGrp);

		headsUpGrp = new FlxTypedGroup<HeadsUpTxt>();
		add(headsUpGrp);

		#if !NO_WAVES
		hookerGrp.add(new Hooker(hookerOffsets[curLevel][0], hookerOffsets[curLevel][2], '${introHooker[curLevel][0]}', true)); // hooker
		addHeadsUpText('${introHooker[curIntroHooker][2]}', 4, introHooker[curIntroHooker][1]);
		#end
		extraSpawnFuncs(); // calling it here for test purposes

		mario = new Mario(marioOffsets[curLevel][0], marioOffsets[curLevel][1]);
		mario.antialiasing = false;
		mario.canShoot = true;
		add(mario);

		shield = new Shield(mario.x - 22, mario.y - 6);
		add(shield);

		#if NO_WAVES
		CommandData.watch(mario);
		CommandData.watch(shield);
		var bullet:Bullet = new Bullet(bulletOffsets[curLevel][0], bulletOffsets[curLevel][1]);
		add(bullet);
		CommandData.watch(bullet);

		var hooker:Hooker = new Hooker(hookerOffsets[curLevel][0], hookerOffsets[curLevel][2], 'bomb hooker');
		hookerGrp.add(hooker);
		CommandData.watch(hooker);
		#end

		marioHitbox = new FlxSprite(mario.x, mario.y).makeGraphic(100, 120); // can't shrink mario's hitbox so this is the way
		marioHitbox.visible = #if NO_WAVES true #else false #end;
		#if NO_WAVES
		marioHitbox.alpha = 0.25;
		#end
		add(marioHitbox);

		flash = new Flash();
		add(flash);

		waveTxt = new FlxText(560, 10, 0, 'WAVE: $curWave');
		waveTxt.setFormat(null, 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		waveTxt.screenCenter(X);
		waveTxt.borderSize = 4;
		add(waveTxt);

		pogoPlatform = new FlxSprite(pPlatformOffsets[curLevel][0], pPlatformOffsets[curLevel][1]).makeGraphic(Std.int(FlxG.width * 2), 10);
		pogoPlatform.immovable = true;
		pogoPlatform.visible = #if NO_WAVES true #else false #end;
		add(pogoPlatform);
		#if NO_WAVES
		CommandData.watch(pogoPlatform);
		#end

		addHeadsUpText("PRESS [MOUSEBUTTON 1] TO FIRE GUN", 4);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		#if !NO_WAVES
		if (FlxG.mouse.justPressed && mario.canShoot)
		{
			FlxG.sound.play('assets/sounds/gunshot_${FlxG.random.int(1, 3)}.ogg');
			bulletGrp.add(new Bullet(bulletOffsets[curLevel][0], bulletOffsets[curLevel][1]));
		}
		hookerGrp.forEach(function(hooker:Hooker)
		{
			if (hooker.daHookerType != 'bomb hooker')
				FlxG.overlap(hookerGrp, marioHitbox, lose);
		});
		FlxG.overlap(bulletGrp, hookerGrp, killBulletAndHooker);
		#end
		if (FlxG.keys.anyJustPressed([SHIFT]) && !shield.isActive && canShield)
		{
			shield.shield();
			canShield = false;

			new FlxTimer().start(2.25, function(tmr:FlxTimer)
			{
				canShield = true;
				addHeadsUpText("SHIELD READY", 2, FlxColor.CYAN);
			});
		}
		hookerGrp.forEach(function(hooker:Hooker)
		{
			if (hooker.daHookerType == 'pogo hooker')
				FlxG.collide(hookerGrp, pogoPlatform);
		});
	}

	function spawnHooker(isConditional:Bool)
	{
		var hookerType:String = '';
		var timesTwo = onceInWaves * 2;
		var timesThree = onceInWaves * 3;

		if (curWave == onceInWaves || curWave == timesTwo || curWave == timesThree)
		{
			hookerType = '${introHooker[curIntroHooker][0]}';
			addHeadsUpText('${introHooker[curIntroHooker][2]}', 4, introHooker[curIntroHooker][1]);
		}
		else
		{
			var randomInt = FlxG.random.int(0, 100);
			if (FlxG.random.int(0, 2000) <= 1)
				hookerType = 'piggie';
			else if (isConditional && randomInt <= 20 && curWave > onceInWaves)
				hookerType = 'buff hooker';
			else if (randomInt <= 20 && curWave > timesTwo)
				hookerType = 'pogo hooker';
			else if (isConditional && randomInt <= 15 && curWave > timesThree)
				hookerType = 'bomb hooker';
			else
				hookerType = 'hooker';//lol
		}

		var hookerX1:Float = hookerOffsets[curLevel][0];
		var hookerX2:Float = hookerOffsets[curLevel][1];

		hookerGrp.add(new Hooker(FlxG.random.float(hookerX1, hookerX2), hookerOffsets[curLevel][2], hookerType, isConditional));
		extraSpawnFuncs();
	}

	function extraSpawnFuncs()
	{
		hookerGrp.forEachAlive(function(hooker:Hooker)
		{
			if (hooker.daHookerType == 'bomb hooker')
			{
				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					hookerGrp.forEachAlive(function(hooker:Hooker)
					{
						if (hooker.daHookerType == 'bomb hooker')
							bombExplode(hooker);
					});
				});
			}
		});
	}

	function bombExplode(hooker:Hooker) // for bomb hooker
	{
		if (mario.isShielding)
		{
			if (hooker.daHookerType == 'bomb hooker')
				hooker.animation.play("explosivo");
			FlxG.sound.play('assets/sounds/bomb explode.ogg');
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				hooker.die();
			});
			addHeadsUpText("Nice Shield!", 1, FlxColor.CYAN);

			hookersKilled += 1;
			if (hooker.isConditional)
			{
				hookerCount -= 1;
				if (hookerCount > 1)
					spawnHooker(true);
				else
					newWave();
			}
		}
		else
		{
			addHeadsUpText("L RIP Bozo!", 1, FlxColor.CYAN);
			lose(hooker, mario);
		}
	}

	function killBulletAndHooker(bullet:Bullet, hooker:Hooker)
	{
		if (hooker.daHealth <= 1 && hooker.daHookerType != 'bomb hooker')
		{
			hooker.die();
			hookersKilled += 1;
			if (hooker.isConditional)
			{
				hookerCount -= 1;
				if (hookerCount > 1)
					spawnHooker(true);
				else
					newWave();
			}
		}
		else
		{
			hooker.daHealth -= 1;
			hookerAggro(hooker);
		}
		bullet.kill();
	}

	function hookerAggro(hooker:Hooker)
	{
		switch (hooker.daHookerType)
		{
			case 'bomb hooker':
				if (hooker.daHealth <= 0)
				{
					trace('hooker explode');
					bombExplode(hooker);
				}
			case 'buff hooker':
				if (hooker.daHealth == 2)
					hooker.color = FlxColor.PURPLE;
				else if (hooker.daHealth == 1)
				{
					hooker.color = FlxColor.RED;
					if (FlxG.random.float(0, 100) >= 25 && curWave != onceInWaves && hookerCount > 1)
					{
						var randoNumber:Int = FlxG.random.int(1, 2);
						for (i in 0...randoNumber)
						{
							spawnHooker(false);
						}
					}
				}
			default:
				hooker.color = FlxColor.RED;
		}
	}

	function newWave()
	{
		mario.canShoot = false;
		new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			curWave += 1;
			maxHookersPerWave += hookerMultiplier;
			var timesTwo = onceInWaves * 2;
			var timesThree = onceInWaves * 3;
			if (curWave == onceInWaves || curWave == timesTwo || curWave == timesThree)
			{
				hookerCount = 1;
				curIntroHooker += 1;
			}
			else
				hookerCount = maxHookersPerWave;
			waveTxt.text = 'WAVE: $curWave';
			mario.canShoot = true;
			if (curWave % onceInWaves == 0)
			{
				curLevel += 1;
				if (curLevel > levels.length - 1)
					curLevel = 0;
				bg.loadGraphic('assets/images/levels/${levels[curLevel]}.png');
				FlxG.sound.playMusic('assets/music/${levels[curLevel]}.ogg', 0.7, true); // ty cakie
				flash.flash(1.5);
				mario.setPosition(marioOffsets[curLevel][0], marioOffsets[curLevel][1]);
				marioHitbox.setPosition(mario.x, mario.y);
				pogoPlatform.setPosition(pPlatformOffsets[curLevel][0], pPlatformOffsets[curLevel][1]);
				hookerGrp.forEachAlive(function(hooker:Hooker)
				{
					hooker.y = hookerOffsets[curLevel][2];
				});
				bulletGrp.forEachAlive(function(bullet:Bullet)
				{
					bullet.y = bulletOffsets[curLevel][1];
				});
				shield.setPosition(mario.x - 22, mario.y - 6);
			}
			spawnHooker(true);
		});
	}

	function lose(hooker:Hooker, mario:FlxSprite)
	{
		FlxG.sound.music.stop();
		FlxG.switchState(new Jumpscare(curWave, hookersKilled, hooker.daHookerType, hooker.jumpscareColor));
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
