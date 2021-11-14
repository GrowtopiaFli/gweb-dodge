package;

import flixel.FlxG;
import flixel.FlxState;

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
		Sfx.load();
		if (!Data.initialized) Data.init();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		#if !web
		FlxG.mouse.visible = false;
		#end
		
		var daThing:Float = (songTime / 1000 / 60);
		beats = Math.floor(Tempo.bpm * daThing);
		steps = Math.floor((Tempo.bpm * 4) * daThing);
		
		if (steps != prevSteps) stepChange();
		if (beats != prevBeats) beatChange();
		
		prevBeats = Reflect.getProperty(this, "beats");
		prevSteps = Reflect.getProperty(this, "steps");
	}
	
	public function stepChange()
	{
	}
	
	public function beatChange()
	{
	}
}