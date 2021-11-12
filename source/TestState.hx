package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.math.FlxMath;

class TestState extends TempoState
{
	public var unselectedAlpha:Float = 0.4;
	public var selectedAlpha:Float = 1;

	public var txt:FlxText;
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

	public var command1:FlxText;
	public var command2:FlxText;
	
	public var paused:Bool = false;

	public var selected:Int = -1;
	public var isSelected:Bool = false;
	
	public var field:FlxText;

	public function new(sid:String = "")
	{
		super();
		if (sid != "") songId = sid;
	}

	override public function create()
	{
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
		
		Tempo.bpm = Std.parseInt(iniDataSong["bpm"]);

		FlxG.sound.cache("assets/music/" + iniDataSong["audio"] + ".ogg");
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			FlxG.sound.playMusic("assets/music/" + iniDataSong["audio"] + ".ogg", 1, false);
			FlxG.sound.music.onComplete = songDone;
			stepChange();
			beatChange();
		}, 1);

		super.create();
	}
	
	public function songDone():Void
	{
		FlxG.sound.playMusic("assets/music/" + Data.iniData[songId]["audio"] + ".ogg", 1, false);
		paused = true;
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
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
				if (FlxG.keys.anyJustPressed(ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, ZERO))
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
				if (FlxG.keys.justPressed.ENTER)
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
				if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.C) isSelected = false;
			}
		}
		
		var alphaVel:Float = velFromFps(0.9);
		
		command1.alpha = FlxMath.lerp(((selected == 0) ? selectedAlpha : unselectedAlpha), command1.alpha, alphaVel);
		command2.alpha = FlxMath.lerp(((selected == 1) ? selectedAlpha : unselectedAlpha), command2.alpha, alphaVel);
		
		if (FlxG.sound.music != null)
		{
			if (paused)
			{
				FlxG.sound.music.pause();
				if (FlxG.keys.justPressed.F)
				{
					quantize();
					quantize();
					quantize();
					quantize();
					FlxG.sound.music.time = songTime;
				}
				else
				{
					var timeToAdd:Float = (Tempo.bpm / 60 / 4) * 1000;
					if (FlxG.keys.justPressed.LEFT) songTime -= timeToAdd / 4;
					if (FlxG.keys.justPressed.RIGHT) songTime += timeToAdd / 4;
					if (FlxG.keys.justPressed.A) songTime -= timeToAdd;
					if (FlxG.keys.justPressed.D) songTime += timeToAdd;
					FlxG.sound.music.time = songTime;
				}
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
		
		if ((FlxG.keys.justPressed.BACKSPACE && !isSelected) || FlxG.keys.justPressed.ESCAPE) Switch.switchState(new MenuSelection());
	}
	
	public function quantize():Void
	{
		songTime = (steps / ((Tempo.bpm / 60) * 4)) * 1000;
	}
	
	public function velFromFps(vel:Float):Float
	{
		return (vel / FlxG.updateFramerate) * 60;
	}
}