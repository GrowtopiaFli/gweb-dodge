package;

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

/*
#if (openfl >= "8.0.0")
import openfl8.*;
#else
import openfl3.*;
#end
import openfl.filters.ShaderFilter;
*/

using StringTools;

class PlayState extends TempoState
{
	public var txt:FlxText;
	public var pause:FlxText;
	public var lines:FlxSpriteGroup;
	public var fadingBlocks:FlxTypedSpriteGroup<Block>;
	public var blocks:FlxTypedSpriteGroup<Block>;
	public var queuedBlocks:FlxTypedSpriteGroup<Block>;
	public var enemies:FlxTypedSpriteGroup<Enemy>;
	public var enemiesDead:FlxTypedSpriteGroup<FlxSprite>;
	public var player:FlxSprite;
	public var curPos:Int = 0;
	public var prevPos:Int = 0;
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
	
	public var pauseBG:FlxSprite;
	public var pauseText:FlxText;
	public var pauseItems:FlxTypedSpriteGroup<TextItem>;
	public var pauseItemList:Array<String> = ["Resume", "Restart", "Go To Menu"];

	public var paused:Bool = false;
	
	public var selectedPauseItem:Int = 0;
	public var unselectedAlpha:Float = 0.5;
	public var selectedAlpha:Float = 1;
	
	public var health:Int = 3;
	public var immune:Bool = false;
	public var immuneTime:Float = 0;
	public var immuneAlpha:Float = 0.3;
	public var curImmuneAlpha:Float = 1;
	
	public var dead:Bool = false;
	public var deadTimer:Float = 0;

	public var playerDeath:FlxSprite;
	
	public var outScreen:Bool = false;
	
	public var playerBullets:FlxTypedSpriteGroup<Bullet>;
	public var enemyBullets:FlxTypedSpriteGroup<Bullet>;
	
	public var bulletSize:Int = 8;
	
	public var enemyShootChance:Float = 40;

	public var enemyBulletVelBak:Float = 10;
	public var playerBulletVelBak:Float = 18;
	public var enemyBulletVel:Float = 0;
	public var playerBulletVel:Float = 0;
	
	public var blockVel:Float = 22;
	
	public var enemyMaxTime:Float = 3;
	
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
		
		for (i in 1...4)
		{
			var spr:FlxSprite = new FlxSprite(((i / 4) * FlxG.width) - 2, 0).makeGraphic(4, Std.int(FlxG.height));
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
		
		playerBullets = new FlxTypedSpriteGroup<Bullet>();
		add(playerBullets);
		
		enemies = new FlxTypedSpriteGroup<Enemy>();
		add(enemies);
		
		enemiesDead = new FlxTypedSpriteGroup<FlxSprite>();
		add(enemiesDead);
		
		player = new FlxSprite();
		player.frames = FlxAtlasFrames.fromSpriteSheetPacker("assets/images/Player.png", "assets/images/Player.txt");
		player.animation.addByPrefix("idle", "Idle_", 8);
		player.animation.addByPrefix("damaged", "Damaged_", 8);
		player.animation.addByPrefix("weak", "Weak_", 8);
		player.animation.play("idle", true);
		player.y = FlxG.height - player.height - 5;
		player.immovable = true;
		add(player);
		
		playerDeath = new FlxSprite();
		playerDeath.frames = FlxAtlasFrames.fromSpriteSheetPacker("assets/images/Player_Death.png", "assets/images/Player_Death.txt");
		playerDeath.animation.addByPrefix("explode", "Explode_", 50, false);
		playerDeath.visible = false;
		add(playerDeath);
		
		txt = new FlxText(0, 0, 0, "Beats: \nSteps: \nSong Time: \n", 16, true);
		add(txt);
		
		pauseBG = new FlxSprite().makeGraphic(Std.int(FlxG.width), Std.int(FlxG.height), FlxColor.BLACK);
		pauseBG.alpha = 0.75;
		pauseBG.visible = false;
		add(pauseBG);
		
		var pauseTextSize:Int = 40;
		
		pauseText = new FlxText(0, 0, 0, "Paused!", pauseTextSize, true);
		pauseText.screenCenter();
		pauseText.alignment = CENTER;
		pauseText.font = "fonts/archivoblack.ttf";
		pauseText.visible = false;
		add(pauseText);
		
		pauseItems = new FlxTypedSpriteGroup<TextItem>();
		pauseItems.visible = false;
		add(pauseItems);

		/*	FlxG.game.setFilters([new ShaderFilter(new Hq2x())]);
			FlxG.game.filtersEnabled = true; */
		
		for (i in 0...pauseItemList.length)
		{
			var daSize:Int = 20;
			var daItem:TextItem = new TextItem(0, 0, 0, pauseItemList[i], daSize, true);
			daItem.screenCenter();
			daItem.alignment = CENTER;
			daItem.y += pauseTextSize + ((daSize + 4) * i);
			daItem.itemName = pauseItemList[i];
			daItem.alpha = unselectedAlpha;
			daItem.font = "fonts/archivoblack.ttf";
			pauseItems.add(daItem);
		}
		
		var iniDataSong = Data.iniData[songId];
		
		var stepEvtString:String = "step_evts_" + iniDataSong["event_id"];
		var beatEvtString:String = "beat_evts_" + iniDataSong["event_id"];
		
		if (Data.iniData.exists(stepEvtString))
		{
			var iniDataEvents = Data.iniData[stepEvtString];

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
		
		if (Data.iniData.exists(beatEvtString))
		{
			var iniDataEvents = Data.iniData[beatEvtString];
			
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

		FlxG.sound.cache("assets/music/" + iniDataSong["audio"] + ".ogg");
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			FlxG.sound.playMusic("assets/music/" + iniDataSong["audio"] + ".ogg", 1, false);
			FlxG.sound.music.onComplete = songDone;
			stepChange();
			beatChange();
		}, 1);
		
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
	
	public function songDone()
	{
		/* if (FlxG.sound.music != null)
				FlxG.sound.music.stop(); */
		SaveManager.levelComplete(songId);
		Switch.switchState(new CompleteState());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		switch (health)
		{
			case 3:
				if (player.animation.name != "idle") player.animation.play("idle", true);
			case 2:
				if (player.animation.name != "damaged") player.animation.play("damaged", true);
			case 1:
				if (player.animation.name != "weak") player.animation.play("weak", true);
			case 0:
				dead = true;
			default:
				openfl.system.System.exit(0);
		}
		
		if (!paused)
		{
			if (curPos < 0) curPos = 3;
			if (curPos > 3) curPos = 0;
			
			if ((prevPos == 0 && curPos == 3) || (curPos == 0 && prevPos == 3)) outScreen = true;
		
			var velPos:Float = velFromFps(0.5);
			
			if (enemies.length > 0)
			{
				var playerUpDownVel:Float = velFromFps(8);
				if (FlxG.keys.pressed.UP && !dead) player.y -= playerUpDownVel;
				if (FlxG.keys.pressed.DOWN && !dead) player.y += playerUpDownVel;
				if (player.y > FlxG.height - player.height - 5) player.y = FlxG.height - player.height - 5;
				if (player.y < (FlxG.height / 2.5) - (player.height / 2)) player.y = (FlxG.height / 2.5) - (player.height / 2);
			}
			else
				player.y = FlxMath.lerp(FlxG.height - player.height - 5, player.y, velFromFps(0.85));
			
			var targetX:Float = (((FlxG.width / 4) * curPos) + (((FlxG.width / 4) - player.width) / 2));

			player.x = FlxMath.lerp(targetX, player.x, velFromFps(velPos));
			
			var alphaVel:Float = velFromFps(0.86);
			var targetAlpha:Float = 1;
			
			var daOffset:Float = 1;
			var xIsOkay:Bool = (player.x >= targetX - daOffset && player.x <= targetX + daOffset);
			if (!immune) player.alpha = xIsOkay ? FlxMath.lerp(1, player.alpha, alphaVel) : FlxMath.lerp(0.5, player.alpha, alphaVel);
			if (xIsOkay)
			{
				player.x = targetX;
				outScreen = false;
			}
			
			enemyBulletVel = velFromFps(enemyBulletVelBak);
			playerBulletVel = velFromFps(playerBulletVelBak);
			
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
				block.alpha -= velFromFps(0.08);
			});

			queuedBlocks.forEachAlive(function(block:Block)
			{
				block.alpha = FlxMath.lerp(targetAlpha, block.alpha, alphaVel);
				block.x = (FlxG.width / 4) * block.pos;
				/*	enemyBullets.forEachAlive(function(bullet:Bullet)
					{
						if (checkCollision(block, bullet, bullet.vel.x, bullet.vel.y))
						{
							Sfx.hit();
							bullet.kill();
							enemyBullets.remove(bullet, true);
							bullet.destroy();
						}
					}); */
				playerBullets.forEachAlive(function(bullet:Bullet)
				{
					if (checkCollision(block, bullet, 0, playerBulletVel))
					{
						Sfx.hit();
						bullet.kill();
						playerBullets.remove(bullet, true);
						bullet.destroy();
						if (block.breakable)
						{
							fadingBlocks.add(block);
							queuedBlocks.remove(block, true);
						}
					}
				});
			});

			blocks.forEachAlive(function(block:Block)
			{
				var ded:Bool = false;
				block.alpha = FlxMath.lerp(targetAlpha, block.alpha, alphaVel);
				block.x = (FlxG.width / 4) * block.pos;
				if (block.y + block.height > player.y + 6 && block.pos == curPos)
					damagePlayer();
				if (block.y > FlxG.height)
					ded = true;
				/*	enemyBullets.forEachAlive(function(bullet:Bullet)
					{
						if (checkCollision(block, bullet, bullet.vel.x, bullet.vel.y))
						{
							Sfx.hit();
							bullet.kill();
							enemyBullets.remove(bullet, true);
							bullet.destroy();
						}
					}); */
				playerBullets.forEachAlive(function(bullet:Bullet)
				{
					if (checkCollision(block, bullet, 0, playerBulletVel))
					{
						Sfx.hit();
						bullet.kill();
						playerBullets.remove(bullet, true);
						bullet.destroy();
						if (block.breakable)
						{
							ded = false;
							fadingBlocks.add(block);
							blocks.remove(block, true);
						}
					}
				});
				if (ded)
				{
					block.kill();
					blocks.remove(block, true);
					block.destroy();
				}
				else
				{
					block.velocity.y = blockVel * FlxG.updateFramerate;
				}
			});

			enemies.forEachAlive(function(enemy:Enemy)
			{
				var movementVelocity:Float = velFromFps(1.5);
				if (enemy.x < player.x) enemy.x += movementVelocity;
				if (enemy.x > player.x) enemy.x -= movementVelocity;
				if (enemy.y < player.y) enemy.y += movementVelocity;
				if (enemy.y > player.y) enemy.y -= movementVelocity;
				enemy.angle = FlxMath.lerp((GWebUtils.angleBetweenObj(enemy.midpointX, enemy.midpointY, player.getMidpoint().x, player.getMidpoint().y)) + 90, enemy.angle, velFromFps(0.8));
				enemy.dead = enemy.timeLived >= enemyMaxTime;
				if (!outScreen && (FlxG.collide(player, enemy) || (enemy.x >= player.x && enemy.x <= player.x + player.width && enemy.y >= player.y && enemy.y <= player.y + player.height)) && health > 0 && !immune)
				{
					damagePlayer();
					enemy.dead = true;
				}
				if (enemy.dead)
				{
					spawnParticle(enemy.x, enemy.y, 0);
					Sfx.enemy_die();
					enemy.kill();
					enemies.remove(enemy, true);
					enemy.destroy();	
				}
				else
				{
					/* playerBullets.forEachAlive(function(bullet:Bullet)
					{
						if (checkCollision(enemy, bullet, playerBulletVel, playerBulletVel))
						{
							Sfx.hit();
							bullet.kill();
							playerBullets.remove(bullet, true);
							bullet.destroy();
						}
					}); */
					enemy.timeLived += 1 / FlxG.updateFramerate;
				}
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
				if (!outScreen && (FlxG.collide(player, bullet) || (bullet.x >= player.x && bullet.x <= player.x + player.width && bullet.y >= player.y && bullet.y <= player.y + player.height)) && health > 0 && !immune)
				{
					damagePlayer();
					ded = true;
				}
				if (ded)
				{
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
			
			playerBullets.forEachAlive(function(bullet:Bullet)
			{
				var ded:Bool = (bullet.x > FlxG.width ||
								bullet.x < -bullet.width ||
								bullet.y > FlxG.height ||
								bullet.y < -bullet.height);
				if (ded)
				{
					Sfx.hit();
					bullet.kill();
					playerBullets.remove(bullet, true);
					bullet.destroy();
				}
				else
					bullet.y -= playerBulletVel;
			});
			
			txt.text = "Beats: " + beats + "\nSteps: " + steps + "\nSong Time: " + songTime + "\n";
			
			if (FlxG.sound.music != null && FlxG.sound.music.playing)
			{
				if (FlxG.sound.music.time > songTime + 120)
					FlxG.sound.music.time = songTime;
				songTime = FlxG.sound.music.time;
			}
			
			if (FlxG.keys.justPressed.SPACE) playerShoot();
			
			prevPos = Reflect.getProperty(this, "curPos");

			if (FlxG.keys.justPressed.RIGHT && !dead) curPos++;
			if (FlxG.keys.justPressed.LEFT && !dead) curPos--;
			
			if (immune)
			{
				immuneTime += 1 / FlxG.updateFramerate;
				if (immuneTime >= 2)
				{
					player.alpha = 1;
					immune = false;
				}
			}
			else immuneTime = 0;
			
			if (dead)
			{
				if (FlxG.sound.music != null) FlxG.sound.music.pause();
				player.visible = false;
				playerDeath.x = player.x;
				playerDeath.y = player.y;
				if (playerDeath.animation.name != "explode")
				{
					playerDeath.animation.play("explode", true);
					playerDeath.visible = true;
					Sfx.hurt3();
				}
				if (playerDeath.animation.finished)
					if (deadTimer >= 0.5)
						Switch.switchState(new LostState(songId));
					else
						deadTimer += 1 / FlxG.updateFramerate;
			}
			else
				deadTimer = 0;

			selectedPauseItem = 0;
		}

		if (paused && FlxG.sound.music != null)
		{
			pauseItems.visible = true;
			pauseBG.visible = true;
			pauseText.visible = true;

			blocks.forEachAlive(function(block:Block)
			{
				block.velocity.y = 0;
			});
			
			if (FlxG.sound.music != null)
				FlxG.sound.music.pause();
			
			if (pauseItemList.length > 0)
			{
				if (FlxG.keys.justPressed.UP) selectedPauseItem--;
				if (FlxG.keys.justPressed.DOWN) selectedPauseItem++;
				
				if (selectedPauseItem < 0) selectedPauseItem = pauseItemList.length - 1;
				if (selectedPauseItem > pauseItemList.length - 1) selectedPauseItem = 0;
				
				var alphaVel:Float = velFromFps(0.85);
				
				pauseItems.forEachAlive(function(item:TextItem)
				{
					var itemIndex:Int = pauseItemList.indexOf(item.itemName);
					if (selectedPauseItem == itemIndex)
					{
						item.alpha = FlxMath.lerp(selectedAlpha, item.alpha, alphaVel);
						if (FlxG.keys.justPressed.ENTER)
						{
							switch (item.itemName.toLowerCase())
							{
								case "resume":
									paused = false;
								case "restart":
									Switch.switchState(new PlayState(songId));
								case "go to menu":
									Switch.switchState(new Menu());
							}
						}
					}
					else item.alpha = FlxMath.lerp(unselectedAlpha, item.alpha, alphaVel);
				});
			}
			else if (FlxG.keys.justPressed.ENTER)
			{
				paused = false;
			}
			
			if (FlxG.keys.justPressed.R) FlxG.resetState();
		}
		else
		{
			pauseItems.visible = false;
			pauseBG.visible = false;
			pauseText.visible = false;
			if (FlxG.sound.music != null && !dead)
				FlxG.sound.music.resume();
			if (FlxG.keys.justPressed.ENTER) paused = true;
		}
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
			Sfx.enemy_spawn();
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
	
	public function damagePlayer()
	{
		if (health > 0 && !immune)
		{
			switch (health)
			{
				case 3:
					Sfx.hurt1();
				case 2:
					Sfx.hurt2();
				case 1:
				case 0:
				default:
					openfl.system.System.exit(0);
			}
			health--;
			immune = true;
		}
	}
	
	public function playerShoot()
	{
		var daBullet:Bullet = new Bullet(player.getMidpoint().x, player.getMidpoint().y, bulletSize, bulletSize, 0xFF009AFF);
		playerBullets.add(daBullet);
	}
	
	public function enemyShoot(daX:Float = 0, daY:Float = 0, daAngle:Float = 0)
	{
		var daBullet:Bullet = new Bullet(daX, daY, bulletSize, bulletSize, 0xFFFF9A9A);
		daBullet.funiAngle = daAngle;
		enemyBullets.add(daBullet);
	}
	
	public function checkCollision(obj:FlxSprite, obj2:FlxSprite, xVel:Float, yVel:Float):Bool
	{
		if (FlxG.collide(obj, obj2) || ( ( obj2.y - yVel >= obj.y && obj2.y <= obj.y + obj.height ) || ( obj2.y - yVel <= obj.y + obj.height && obj2.y >= obj.y ) ) && ( ( obj2.x <= obj.x + obj.width && obj2.x + xVel >= obj.x ) || ( obj2.x + xVel <= obj.x + obj.width && obj2.x >= obj.x ) ) )
			return true;
		else
			return false;
	}
	
	override public function stepChange()
	{
		if (immune)
		{
			if (immuneTime < 2)
			{
				player.alpha = curImmuneAlpha;
				if (curImmuneAlpha == 1) curImmuneAlpha = immuneAlpha else if (curImmuneAlpha == immuneAlpha) curImmuneAlpha = 1;
			}
		}
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