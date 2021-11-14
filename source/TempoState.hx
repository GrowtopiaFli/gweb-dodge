package;

import flixel.FlxG;
import flixel.FlxState;

import openfl.utils.Assets;

class TempoState extends FlxState
{
	public var beats:Int = 0;
	public var steps:Int = 0;
	public var prevBeats:Int = 0;
	public var prevSteps:Int = 0;
	public var songTime:Float = 0;

	public function new()
	{
		super();
		if (Assets.cache.enabled)
			Assets.cache.clear();
		if (!Data.initialized) Data.init();
		Menu.menuAudio.pause();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		#if !web
		FlxG.mouse.visible = false;
		#end
		
		var daThing:Float = songTime / 1000 / 60;
		beats = Math.floor(Tempo.bpm * daThing);
		steps = Math.floor((Tempo.bpm * 4) * daThing);
		
		if (steps != prevSteps) stepChange();
		if (beats != prevBeats) beatChange();
		
		prevBeats = Reflect.getProperty(this, "beats");
		prevSteps = Reflect.getProperty(this, "steps");
		
		if (FlxG.keys.justPressed.F4)
			FlxG.fullscreen = !FlxG.fullscreen;
	}
	
	public function stepChange()
	{
	}
	
	public function beatChange()
	{
	}
}