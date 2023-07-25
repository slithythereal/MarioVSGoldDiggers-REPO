package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objs.*;
import objs.GameSprite.GameText;
import substate.OptionsSubState;

class PlayState extends FlxState
{
	// public static vars
	public static var mario:Mario;

	// public vars
	public var paused:Bool = false;

	// objects
	var shield:Shield;
	var flash:Flash;
	var bg:FlxSprite;
	var waveTxt:FlxText;
	var marioHitbox:FlxSprite;
	var pogoPlatform:FlxSprite;
	// groups
	var hookerGrp:FlxTypedGroup<Hooker>;
	var bulletGrp:FlxTypedGroup<Bullet>;
	var headsUpGrp:FlxTypedGroup<HeadsUpTxt>;
	// bools
	var canShield:Bool = true;
	var bombCanDamage:Bool = false;
	var canPause:Bool = false;
	// ints and floats
	var hookerCount:Int = 1;
	var maxHookersPerWave:Int = 1;
	var hookersKilled:Int = 0;
	var curWave:Int = 1;
	var curLevel:Int = 0;
	var onceInWaves:Int = 8; // once in 8 waves it switches to the next world
	var hookerMultiplier:Int = 5;
	// arrays
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
	var marioOffsets:Array<Array<Float>> = [[21, 311], [21, 360], [21, 336], [21, 360]];
	var bulletOffsets:Array<Array<Float>> = [[152, 370], [152, 417], [152, 394], [152, 417]];
	var hookerOffsets:Array<Array<Float>> = [[575, 675, 316], [575, 675, 363], [575, 675, 339], [575, 675, 363]];
	var pPlatformOffsets:Array<Array<Float>> = [[0, 433], [0, 480], [0, 457], [0, 480]];

	// timers and tweens
	var shieldTimer:FlxTimer;
	var bombTimer:FlxTimer;
	var bombExplodeTimer:FlxTimer;
	var newWaveTimer:FlxTimer;

	override public function create()
	{
		super.create();

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
		addHeadsUpText('${introHooker[curLevel][2]}', 4, introHooker[curLevel][1]);
		extraSpawnFuncs();
		#else
		var hooker:Hooker = new Hooker(hookerOffsets[curLevel][0], hookerOffsets[curLevel][2], 'hooker');
		hookerGrp.add(hooker);
		CommandData.watch(hooker);
		#end

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

			shieldTimer = new FlxTimer().start(2.25, function(tmr:FlxTimer)
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

		if (#if !NO_WAVES canPause && #end FlxG.keys.justPressed.ESCAPE)
		{
			paused = true;
			openSubState(new substate.OptionsSubState(false));
		}
	}

	// overlap funcs
	function killBulletAndHooker(bullet:Bullet, hooker:Hooker)
	{
		if (!hooker.isDead)
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
	}

	function lose(hooker:Hooker, marioHitbox:FlxSprite)
	{
		FlxG.sound.music.stop();
		FlxG.switchState(new Jumpscare(curWave, hookersKilled, hooker.daHookerType, hooker.jumpscareColor));
	}

	// hooker related funcs
	function newWave()
	{
		mario.canShoot = false;
		canPause = true;
		newWaveTimer = new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			curWave += 1;
			maxHookersPerWave += hookerMultiplier;
			var timesTwo = onceInWaves * 2;
			var timesThree = onceInWaves * 3;
			if (curWave == onceInWaves || curWave == timesTwo || curWave == timesThree)
			{
				hookerCount = 1;
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
			canPause = false;
		});
	}

	function spawnHooker(isConditional:Bool)
	{
		var hookerType:String = '';
		var timesTwo = onceInWaves * 2;
		var timesThree = onceInWaves * 3;

		if (curWave == onceInWaves || curWave == timesTwo || curWave == timesThree)
		{
			hookerType = '${introHooker[curLevel][0]}';
			addHeadsUpText('${introHooker[curLevel][2]}', 4, introHooker[curLevel][1]);
		}
		else
		{
			var randomInt = FlxG.random.int(0, 100);
			if (FlxG.random.int(0, 2000) <= 1)
				hookerType = 'piggie';
			else if (isConditional && randomInt <= 35 && curWave > onceInWaves)
				hookerType = 'buff hooker';
			else if (randomInt <= 30 && curWave > timesTwo)
				hookerType = 'pogo hooker';
			else if (isConditional && randomInt <= 20 && curWave > timesThree)
				hookerType = 'bomb hooker';
			else
				hookerType = 'hooker';
		}

		var hookerX1:Float = hookerOffsets[curLevel][0];
		var hookerX2:Float = hookerOffsets[curLevel][1];

		hookerGrp.add(new Hooker(FlxG.random.float(hookerX1, hookerX2), hookerOffsets[curLevel][2], hookerType, isConditional));
		extraSpawnFuncs();
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

	function extraSpawnFuncs()
	{
		hookerGrp.forEachAlive(function(hooker:Hooker)
		{
			if (hooker.daHookerType == 'bomb hooker')
			{
				bombTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
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
			hooker.isDead = true;
			if (hooker.daHookerType == 'bomb hooker')
				hooker.animation.play("explosivo");
			FlxG.sound.play('assets/sounds/bomb explode.ogg');
			bombExplodeTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				hooker.die();
			});
			addHeadsUpText("Nice Shield!", 1, FlxColor.CYAN);

			hookersKilled += 1;
			FlxG.camera.shake(0.05, 0.5);
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

	function addHeadsUpText(text:String, seconds:Float, ?color:FlxColor = FlxColor.WHITE) // doom popup text lol
	{
		if (headsUpGrp.members.length > 4)
		{
			var sieggy = headsUpGrp.members[4]; // sieggy variable LOL
			sieggy.destroy();
			headsUpGrp.remove(sieggy);
		}
		headsUpGrp.forEachAlive(function(spr:HeadsUpTxt)
		{
			spr.y += 35;
		});
		headsUpGrp.insert(0, new HeadsUpTxt(text, headsUpGrp, seconds, color));
	}

	// overrides
	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
				FlxG.sound.music.pause();
			if (newWaveTimer != null && !newWaveTimer.finished)
				newWaveTimer.active = false;
			if (shieldTimer != null && !shieldTimer.finished)
				shieldTimer.active = false;

			hookerGrp.forEachAlive(function(hooker:Hooker)
			{
				if (hooker.hookerTween != null && !hooker.hookerTween.finished)
					hooker.hookerTween.active = false;
				if (hooker.daHookerType == 'bomb hooker')
				{
					if (bombTimer != null && !bombTimer.finished)
						bombTimer.active = false;
					if (bombExplodeTimer != null && !bombTimer.finished)
						bombExplodeTimer.active = false;
				}
			});

			bulletGrp.forEachAlive(function(bullet:Bullet)
			{
				if (bullet.bulletTween != null && !bullet.bulletTween.finished)
					bullet.bulletTween.active = false;
			});
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			paused = false;
			if (FlxG.sound.music != null)
				FlxG.sound.music.play();
			if (newWaveTimer != null && !newWaveTimer.finished)
				newWaveTimer.active = true;
			if (shieldTimer != null && !shieldTimer.finished)
				shieldTimer.active = true;

			hookerGrp.forEachAlive(function(hooker:Hooker)
			{
				if (hooker.hookerTween != null && !hooker.hookerTween.finished)
					hooker.hookerTween.active = true;
				if (hooker.daHookerType == 'bomb hooker')
				{
					if (bombTimer != null && !bombTimer.finished)
						bombTimer.active = true;
					if (bombExplodeTimer != null && !bombTimer.finished)
						bombExplodeTimer.active = true;
				}
			});

			bulletGrp.forEachAlive(function(bullet:Bullet)
			{
				if (bullet.bulletTween != null && !bullet.bulletTween.finished)
					bullet.bulletTween.active = true;
			});
		}

		super.closeSubState();
	}
}
