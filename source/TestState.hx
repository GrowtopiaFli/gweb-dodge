package;

import assets.*;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;

import flixel.system.FlxSound;

import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.FileReference;

using StringTools;

class TestState extends TempoState
{
	public var fileRef:FileReference;
	
	public var unselectedAlpha:Float = 0.4;
	public var selectedAlpha:Float = 1;
	
	public var command1:FlxText;
	public var command2:FlxText;
	public var field:FlxText;
	
	public var selected:Int = -1;
	public var isSelected:Bool = false;

	public var txt:FlxText;
	public var pause:FlxText;
	public var lines:FlxSpriteGroup;
	public var fadingBlocks:FlxTypedSpriteGroup<Block>;
	public var blocks:FlxTypedSpriteGroup<Block>;
	public var queuedBlocks:FlxTypedSpriteGroup<Block>;
	public var enemies:FlxTypedSpriteGroup<Enemy>;
	public var enemiesDead:FlxTypedSpriteGroup<FlxSprite>;
	public var songId:String = "";
	
	#if (haxe >= "4.0.0")
	public var stepEvents:Map<Int, Array<Int>> = new Map();
	public var beatEvents:Map<Int, Array<Int>> = new Map();
	#else
	public var stepEvents:Map<Int, Array<Int>> = new Map<Int, Array<Int>>();
	public var beatEvents:Map<Int, Array<Int>> = new Map<Int, Array<Int>>();
	#end
	
	public var stepsUsed:Array<Int> = [];
	public var beatsUsed:Array<Int> = [];

	public var paused:Bool = false;
	
	public var outScreen:Bool = false;

	public var enemyBullets:FlxTypedSpriteGroup<Bullet>;
	
	public var bulletSize:Int = 8;
	
	public var enemyShootChance:Float = 35;

	public var enemyBulletVelBak:Float = 6;
	public var enemyBulletVel:Float = 0;
	
	public var blockVel:Float = 22;
	
	public var enemyMaxTime:Float = 4;
	public var enemySpeed:Float = 1.8;

	/*	public var spectator:Bool = true;
		public var spectatorPause:Bool = false;
		public var prevTime:Float = 0; */
	
	// flixel-demos FlxBloom
	/*	public var _bloom:Int = 10;
		public var _fx:FlxSprite; */

	public function new(sid:String = "")
	{
		super();
		if (sid != "") songId = sid;
	}

	override public function create()
	{
		lines = new FlxSpriteGroup();
		add(lines);
		
		for (i in 0...5)
		{
			var spr:FlxSprite = new FlxSprite((i / 4) * FlxG.width, 0).makeGraphic(4, Std.int(FlxG.height));
			spr.x -= spr.width / 2;
			lines.add(spr);
		}
		
		fadingBlocks = new FlxTypedSpriteGroup<Block>();
		add(fadingBlocks);
		
		queuedBlocks = new FlxTypedSpriteGroup<Block>();
		add(queuedBlocks);
		
		blocks = new FlxTypedSpriteGroup<Block>();
		add(blocks);
		
		enemyBullets = new FlxTypedSpriteGroup<Bullet>();
		add(enemyBullets);
		
		enemies = new FlxTypedSpriteGroup<Enemy>();
		add(enemies);
		
		enemiesDead = new FlxTypedSpriteGroup<FlxSprite>();
		add(enemiesDead);
		
		var daBG:FlxSprite = new FlxSprite().makeGraphic(Math.floor(FlxG.width), Math.floor(FlxG.height), FlxColor.BLACK);
		daBG.alpha = 0.5;
		add(daBG);
		
		txt = new FlxText(0, 0, 0, "Beats: \nSteps: \nSong Time: \n", 16, true);
		txt.alignment = CENTER;
		add(txt);
		
		var defFont:String = "fonts/archivoblack.ttf";

		command1 = new FlxText(0, 0, FlxG.width, "", 16, true);
		command1.font = defFont;
		command1.alignment = CENTER;
		add(command1);
		
		command2 = new FlxText(0, 0, FlxG.width, "", 16, true);
		command2.font = defFont;
		command2.alignment = CENTER;
		add(command2);

		field = new FlxText(0, 0, FlxG.width, "", 24, true);
		field.font = defFont;
		field.alignment = CENTER;
		add(field);

		/*	FlxG.game.setFilters([new ShaderFilter(new Hq2x())]);
			FlxG.game.filtersEnabled = true; */
		
		var iniDataSong = Data.iniData[songId];
		
		var stepEvtString:String = "step_evts_" + iniDataSong["event_id"];
		var beatEvtString:String = "beat_evts_" + iniDataSong["event_id"];
		
		if (Data.iniDataEvents.exists(iniDataSong["audio"]) && Data.iniDataEvents[iniDataSong["audio"]].exists(stepEvtString))
		{
			var iniDataEvents = Data.iniDataEvents[iniDataSong["audio"]][stepEvtString];

			for (shit in iniDataEvents.keys())
			{
				var parsed:Int = Std.parseInt(shit);
				if (!stepsUsed.contains(parsed)) stepsUsed.push(parsed);
			}
			
			for (shit in stepsUsed)
			{
				var toPush:String = iniDataEvents[Std.string(shit)];
				var toPushArr:Array<String> = toPush.split("_");
				var toPushFinal:Array<Int> = [];
				for (shitto in toPushArr)
					toPushFinal.push(Std.parseInt(shitto));
				stepEvents[shit] = toPushFinal;
			}
		}
		
		if (Data.iniDataEvents.exists(iniDataSong["audio"]) && Data.iniDataEvents[iniDataSong["audio"]].exists(beatEvtString))
		{
			var iniDataEvents = Data.iniDataEvents[iniDataSong["audio"]][beatEvtString];
			
			for (shit in iniDataEvents.keys())
			{
				var parsed:Int = Std.parseInt(shit);
				if (!beatsUsed.contains(parsed)) beatsUsed.push(parsed);
			}
			
			for (shit in beatsUsed)
			{
				var toPush:String = iniDataEvents[Std.string(shit)];
				var toPushArr:Array<String> = toPush.split("_");
				var toPushFinal:Array<Int> = [];
				for (shitto in toPushArr)
					toPushFinal.push(Std.parseInt(shitto));
				beatEvents[shit] = toPushFinal;
			}
		}
		
		/*trace(stepsUsed);
		trace(stepEvents);*/
		
		Tempo.bpm = Std.parseInt(iniDataSong["bpm"]);

		#if sys
		sys.thread.Thread.create(() -> {
		#end
		// FlxG.sound.cache("assets/music/" + iniDataSong["audio"] + ".ogg");
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			// FlxG.sound.playMusic("assets/music/" + iniDataSong["audio"] + ".ogg", 1, false);
			// FlxG.sound.playMusic(MusicManager.get("music/" + iniDataSong["audio"] + ".ogg"), 1, false);
			FlxG.sound.music = MusicManager.get("music/" + iniDataSong["audio"] + ".ogg");
			FlxG.sound.music.play();
			FlxG.sound.music.onComplete = songDone;
			stepChange();
			beatChange();
		}, 1);
		#if sys
		});
		#end
		
		/*	_fx = new FlxSprite();
			_fx.makeGraphic(Math.floor(FlxG.width), Math.floor(FlxG.height), 0, true);
			// _fx.makeGraphic(Math.floor(FlxG.width / _bloom), Math.floor(FlxG.height / _bloom), 0, true);
			// _fx.origin.set();
			// _fx.scale.set(_bloom, _bloom);
			_fx.antialiasing = true;
			// _fx.blend = BlendMode.SCREEN;
			// add(_fx);
			
			// FlxG.camera.screen.scale.set(1 / _bloom, 1 / _bloom); */

		super.create();
	}
	
	/*	override public function draw()
		{
			super.draw();
			_fx.stamp(FlxG.camera.screen);
			_fx.draw();
		} */
	
	public function songDone():Void
	{
		var iniDataSong = Data.iniData[songId];
		// FlxG.sound.cache("assets/music/" + iniDataSong["audio"] + ".ogg");
		#if sys
		sys.thread.Thread.create(() -> {
		#end
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			// FlxG.sound.playMusic("assets/music/" + iniDataSong["audio"] + ".ogg", 1, false);
			FlxG.sound.music = MusicManager.get("music/" + iniDataSong["audio"] + ".ogg");
			FlxG.sound.music.play();
			FlxG.sound.music.onComplete = songDone;
			stepChange();
			beatChange();
		}, 1);
		#if sys
		});
		#end
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (!paused)
		{
			var velPos:Float = velFromFps(0.5);
			
			var alphaVel:Float = velFromFps(0.86);
			var targetAlpha:Float = 1;
			
			enemyBulletVel = velFromFps(enemyBulletVelBak);

			enemyBullets.forEachAlive(function(bullet:Bullet)
			{
				var daVel:FlxPoint = GWebUtils.getVelocityFromAngle(enemyBulletVel, enemyBulletVel, bullet.funiAngle);
				bullet.vel.set(velFromFps(daVel.x), velFromFps(daVel.y));
			});
			
			fadingBlocks.forEachAlive(function(block:Block)
			{
				if (block.alpha <= 0)
				{
					block.kill();
					fadingBlocks.remove(block, true);
					block.destroy();
				}
				else
					block.velocity.y = 0;
				block.alpha -= velFromFps(0.08);
			});

			queuedBlocks.forEachAlive(function(block:Block)
			{
				block.alpha = FlxMath.lerp(targetAlpha, block.alpha, alphaVel - velFromFps(0.24));
				block.x = (FlxG.width / 4) * block.pos;
			});
			
			var daVel:Float = blockVel * FlxG.updateFramerate;

			blocks.forEachAlive(function(block:Block)
			{
				var ded:Bool = false;
				block.alpha = FlxMath.lerp(targetAlpha, block.alpha, alphaVel - velFromFps(0.24));
				block.x = (FlxG.width / 4) * block.pos;
				if (block.y > FlxG.height)
					ded = true;
				if (ded)
				{
					block.kill();
					blocks.remove(block, true);
					block.destroy();
				}
				else
					block.velocity.y = daVel;
			});

			enemies.forEachAlive(function(enemy:Enemy)
			{
				var movementVelocity:Float = velFromFps(enemySpeed);
				if (enemy.x < FlxG.width / 2) enemy.x += movementVelocity;
				if (enemy.x > FlxG.width / 2) enemy.x -= movementVelocity;
				if (enemy.y < FlxG.height) enemy.y += movementVelocity;
				if (enemy.y > FlxG.height) enemy.y -= movementVelocity;
				enemy.angle = FlxMath.lerp((GWebUtils.angleBetweenObj(enemy.midpointX, enemy.midpointY, FlxG.width / 2, FlxG.height)) + 90, enemy.angle, velFromFps(0.8));
				enemy.dead = enemy.timeLived >= enemyMaxTime;
				if (enemy.dead)
				{
					spawnParticle(enemy.x, enemy.y, 0);
					Sfx.hurt2();
					enemy.kill();
					enemies.remove(enemy, true);
					enemy.destroy();	
				}
				else
					enemy.timeLived += 1 / FlxG.updateFramerate;
			});
			
			enemiesDead.forEachAlive(function(enemy:FlxSprite)
			{
				if (enemy.animation.finished)
				{
					enemy.kill();
					enemiesDead.remove(enemy, true);
					enemy.destroy();
				}
			});
			
			enemyBullets.forEachAlive(function(bullet:Bullet)
			{
				var ded:Bool = (bullet.x > FlxG.width ||
								bullet.x < -bullet.width ||
								bullet.y > FlxG.height ||
								bullet.y < -bullet.height);
				var playSfx:Bool = false;
				if (bullet.cantKill)
					bullet.alpha = 0.6;
				if (ded)
				{
					if (playSfx)
						Sfx.hit();
					bullet.kill();
					enemyBullets.remove(bullet, true);
					bullet.destroy();
				}
				else
				{
					bullet.x += bullet.vel.x;
					bullet.y += bullet.vel.y;
				}
			});

			if (FlxG.sound.music != null && FlxG.sound.music.playing)
			{
				if (FlxG.sound.music.time > songTime + 120)
					FlxG.sound.music.time = songTime;
				songTime = FlxG.sound.music.time;
			}
		}

		if (paused && FlxG.sound.music != null)
		{
			blocks.forEachAlive(function(block:Block)
			{
				block.kill();
				blocks.remove(block, true);
				block.destroy();
			});
			
			enemies.forEachAlive(function(enemy:Enemy)
			{
				enemy.kill();
				enemies.remove(enemy, true);
				enemy.destroy();
			});
			
			queuedBlocks.forEachAlive(function(block:Block)
			{
				block.kill();
				queuedBlocks.remove(block, true);
				block.destroy();
			});
			
			if (FlxG.sound.music != null)
				FlxG.sound.music.pause();
		}
		else
		{
			if (FlxG.sound.music != null)
				FlxG.sound.music.resume();
			if (paused) Sfx.select();
		}
		
		txt.text = "Beats: " + beats + "\nSteps: " + steps + "\nSong Time: " + Math.floor(songTime) + "\n";
		txt.screenCenter(X);
		
		var nonText:String = "NONE";
		
		command1.text = "Beat Events: " + (beatsUsed.contains(beats) ? "[" + beatEvents[beats].join(",") + "]" : nonText) + "\n";
		command2.text = "\nStep Events: " + (stepsUsed.contains(steps) ? "[" + stepEvents[steps].join(",") + "]" : nonText) + "\n";
		command1.screenCenter();
		command2.screenCenter();
		command1.y -= command1.height / 2;
		command2.y += command2.height / 2;
		
		field.screenCenter(X);
		field.y = FlxG.height - field.height;
		
		if (FlxG.keys.justPressed.P) paused = !paused;
		
		if (!isSelected)
		{
			if (FlxG.keys.justPressed.UP) selected--;
			if (FlxG.keys.justPressed.DOWN) selected++;

			if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)
			{
				if (selected < 0) selected = 1;
				if (selected > 1) selected = 0;
			}
		}
		
		if (selected >= 0)
		{
			if (!isSelected)
			{
				command1.color = FlxColor.WHITE;
				command2.color = FlxColor.WHITE;
				field.text = "";
				if (FlxG.keys.justPressed.ENTER)
					isSelected = true;
			}
			else
			{
				switch (selected)
				{
					case 0:
						command1.color = FlxColor.YELLOW;
					case 1:
						command2.color = FlxColor.YELLOW;
					default:
						openfl.system.System.exit(0);
				}
				if (FlxG.keys.anyJustPressed([ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, ZERO]))
				{
					var justPressed:Int = FlxG.keys.firstJustPressed();
					if (justPressed >= 48 && justPressed <= 57)
					{
						justPressed -= 48;
						field.text += Std.string(justPressed);
						field.text = Std.string(Std.parseInt(field.text));
					}
				}
				if (FlxG.keys.justPressed.BACKSPACE)
					if (field.text.length > 0)
						field.text = field.text.substring(0, field.text.length - 1);
				if (FlxG.keys.justPressed.R)
					switch (selected)
					{
						case 0:
							if (beatsUsed.contains(beats) && beatEvents[beats].length > 0) beatEvents[beats].pop();
						case 1:
							if (stepsUsed.contains(steps) && stepEvents[steps].length > 0) stepEvents[steps].pop();
						default:
							openfl.system.System.exit(0);
					}
				if (FlxG.keys.justPressed.ENTER && field.text.length > 0)
				{
					switch (selected)
					{
						case 0:
							if (!beatsUsed.contains(beats)) beatsUsed.push(beats);
							if (!beatEvents.exists(beats)) beatEvents.set(beats, []);
							beatEvents[beats].push(Std.parseInt(field.text));
						case 1:
							if (!stepsUsed.contains(steps)) stepsUsed.push(steps);
							if (!stepEvents.exists(steps)) stepEvents.set(steps, []);
							stepEvents[steps].push(Std.parseInt(field.text));
						default:
							openfl.system.System.exit(0);
					}
					field.text = "";
				}
				if (FlxG.keys.justPressed.B) isSelected = false;
			}
		}
		
		if (FlxG.keys.justPressed.F)
		{
			fileRef = new FileReference();
			fileRef.addEventListener(Event.COMPLETE, onSaveComplete);
			fileRef.addEventListener(Event.CANCEL, onSaveCancel);
			fileRef.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			fileRef.save(formatData(), Data.iniData[songId]["audio"] + ".ini");
		}
		
		var alphaVel:Float = velFromFps(0.9);
		
		command1.alpha = FlxMath.lerp(((selected == 0) ? selectedAlpha : unselectedAlpha), command1.alpha, alphaVel);
		command2.alpha = FlxMath.lerp(((selected == 1) ? selectedAlpha : unselectedAlpha), command2.alpha, alphaVel);
		
		if (FlxG.sound.music != null)
		{
			if (FlxG.keys.justPressed.Q)
			{
				quantize();
				quantize();
				quantize();
				quantize();
				FlxG.sound.music.time = songTime;
			}
		
			if (paused)
			{
				FlxG.sound.music.pause();
				var timeToAdd:Float = (60 / (Tempo.bpm * 4)) * 1000;
				if (FlxG.keys.justPressed.LEFT) songTime -= timeToAdd;
				if (FlxG.keys.justPressed.RIGHT) songTime += timeToAdd;
				if (FlxG.keys.justPressed.A) songTime -= timeToAdd * 4;
				if (FlxG.keys.justPressed.D) songTime += timeToAdd * 4;
				if (songTime <= 0) songTime = 0;
				FlxG.sound.music.time = songTime;
			}
			else
				FlxG.sound.music.resume();
			if (FlxG.sound.music.playing)
			{
				if (FlxG.sound.music.time > songTime + 120)
					FlxG.sound.music.time = songTime;
				songTime = FlxG.sound.music.time;
			}
		}
		
		if ((FlxG.keys.justPressed.BACKSPACE && !isSelected) || FlxG.keys.justPressed.ESCAPE) Switch.switchState(new MenuSelection(true));
	}
	
	public function velFromFps(vel:Float):Float
	{
		return (vel / FlxG.updateFramerate) * 60;
	}
	
	public function spawnBlock(id:Int)
	{
		if ((id >= 1 && id <= 4) || (id >= 9 && id <= 12))
		{
			var daBlock:Block = new Block();
			daBlock.makeGraphic(Math.floor(FlxG.width / 4), 10);
			if ((id >= 9 && id <= 12))
			{
				id -= 8;
				daBlock.breakable = true;
			}
			daBlock.pos = id - 1;
			daBlock.alpha = 0;
			queuedBlocks.add(daBlock);
		}
		else if (id >= 5 && id <= 8)
			spawnEnemy(id);
		else if (id <= 0)
			procCurrentQueue();
	}
	
	public function spawnEnemy(id:Int)
	{
		if (id >= 5 && id <= 8)
		{
			var daEnemy:Enemy = new Enemy();
			daEnemy.x = (((FlxG.width / 4) * (id - 5)) + (((FlxG.width / 4) - daEnemy.width) / 2));
			enemies.add(daEnemy);
			Sfx.hurt1();
		}
	}
	
	public function procCurrentQueue()
	{
		if (queuedBlocks.countLiving() > 0)
		{
			var daAlive:Block = queuedBlocks.getFirstAlive();
			daAlive.immovable = true;
			blocks.add(daAlive);
			queuedBlocks.remove(daAlive, true);
		}
	}
	
	public function spawnParticle(x:Float = 0, y:Float = 0, id:Int = -1)
	{
		switch (id)
		{
			case 0:
				var daEnemyDead:FlxSprite = new FlxSprite(x, y);
				daEnemyDead.frames = FlxAtlasFrames.fromSpriteSheetPacker("assets/images/Enemy_Death.png", "assets/images/Enemy_Death.txt");
				daEnemyDead.animation.addByPrefix("explode", "Explode_", 50, false);
				daEnemyDead.animation.play("explode", true);
				enemiesDead.add(daEnemyDead);
		}
	}
	
	public function enemyShoot(daX:Float = 0, daY:Float = 0, daAngle:Float = 0)
	{
		var daBullet:Bullet = new Bullet(daX, daY, bulletSize, bulletSize, 0xFFFF9A9A);
		daBullet.funiAngle = daAngle;
		daBullet.immovable = true;
		enemyBullets.add(daBullet);
	}
	
	public function checkCollision(obj:FlxSprite, obj2:FlxSprite, xVel:Float, yVel:Float):Bool
	{
		if 	( FlxG.collide(obj, obj2) ||
			( ( yVel >= 0 ) && ( ( obj2.y + yVel >= obj.y && obj2.y <= obj.y + obj.height ) ) ||
			( ( yVel <= 0 ) && ( ( obj2.y + yVel <= obj.y + obj.height && obj2.y + obj2.height >= obj.y ) ) ) ) &&
			( ( xVel >= 0 ) && ( ( obj2.x + xVel >= obj.x && obj2.x <= obj.x + obj.width  ) ) ||
			( ( xVel <= 0 ) && ( ( obj2.x + xVel <= obj.x + obj.width && obj2.x + obj2.width >= obj.x ) ) ) ) ||
			( obj2.y <= obj.y + obj.height && obj2.y + obj2.height >= obj.y && obj2.x + obj2.width >= obj.x && obj2.x <= obj.x + obj.width ) ||
			( FlxG.overlap(obj, obj2) ) )
			return true;
		else
			return false;
	}
	
	public function onSaveComplete(_):Void
	{
		fileRef.removeEventListener(Event.COMPLETE, onSaveComplete);
		fileRef.removeEventListener(Event.CANCEL, onSaveCancel);
		fileRef.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		fileRef = null;
		FlxG.log.notice("Saved ini..");
	}

	public function onSaveCancel(_):Void
	{
		fileRef.removeEventListener(Event.COMPLETE, onSaveComplete);
		fileRef.removeEventListener(Event.CANCEL, onSaveCancel);
		fileRef.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		fileRef = null;
	}

	public function onSaveError(_):Void
	{
		fileRef.removeEventListener(Event.COMPLETE, onSaveComplete);
		fileRef.removeEventListener(Event.CANCEL, onSaveCancel);
		fileRef.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		fileRef = null;
		FlxG.log.error("Error saving ini");
	}
	
	public function formatData():String
	{
		var lineBreak:String = "";
		#if windows
		lineBreak += "\r";
		#end
		lineBreak += "\n";
		var evtId:String = Data.iniData[songId]["event_id"];
		beatsUsed.sort((a, b) -> a - b);
		stepsUsed.sort((a, b) -> a - b);
		var toReturn:String = "[beat_evts_" + evtId + "]" + lineBreak;
		for (i in 0...beatsUsed.length)
			if (beatEvents.exists(beatsUsed[i]))
				toReturn += beatsUsed[i] + "=" + beatEvents[beatsUsed[i]].join("_") + lineBreak;
		toReturn += lineBreak + "[step_evts_" + evtId + "]" + lineBreak;
		for (i in 0...stepsUsed.length)
			if (stepEvents.exists(stepsUsed[i]))
				toReturn += stepsUsed[i] + "=" + stepEvents[stepsUsed[i]].join("_") + lineBreak;
		return toReturn;
	}
	
	public function quantize():Void
	{
		songTime = (steps / ((Tempo.bpm / 60) * 4)) * 1000;
	}
	
	override public function stepChange()
	{
		if (stepsUsed.contains(steps))
			for (i in 0...stepEvents[steps].length)
				spawnBlock(stepEvents[steps][i]);
	}
	
	override public function beatChange()
	{
		if (beats % 4 == 0)
			enemies.forEachAlive(function(enemy:Enemy)
			{
				if (FlxG.random.bool(enemyShootChance))
					enemyShoot(enemy.midpointX, enemy.midpointY, enemy.angle - 90);
			});
		if (beatsUsed.contains(beats))
			for (i in 0...beatEvents[beats].length)
				spawnBlock(beatEvents[beats][i]);
	}
}