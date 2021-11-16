package;

import flixel.math.FlxPoint;
import openfl.events.TouchEvent;
import openfl.events.MouseEvent;

class Touch
{
	public static var touched:Bool = false;
	public static var held:Bool = false;
	public static var released:Bool = false;
	
	public static var beginCoords:FlxPoint = new FlxPoint();
	public static var endCoords:FlxPoint = new FlxPoint();
	public static var moveCoords:FlxPoint = new FlxPoint();

	public static var currentGesture:String = "NONE";
	
	public static var threshold:Float = 40;

	public static function begin(coords:FlxPoint)
	{
		if (!held) touched = true;
		if (!held) beginCoords = coords;
		held = true;
		released = false;
	}
	
	public static function end(coords:FlxPoint)
	{
		held = false;
		released = true;
		if (coords.x - beginCoords.x >= threshold)
			currentGesture = "RIGHT";
		else if (beginCoords.x - coords.x >= threshold)
			currentGesture = "LEFT";
		else if (coords.y - beginCoords.y >= threshold)
			currentGesture = "DOWN";
		else if (beginCoords.y - coords.y >= threshold)
			currentGesture = "UP";
		else
			currentGesture = "NONE";
		endCoords = coords;
	}
	
	public static function move(coords:FlxPoint)
	{
		moveCoords = coords;
	}
	
	public static function touchBegin(evt:TouchEvent)
	{
		begin(FlxPoint.get(evt.stageX, evt.stageY));
	}
	public static function touchEnd(evt:TouchEvent)
	{
		end(FlxPoint.get(evt.stageX, evt.stageY));
	}
	public static function touchMove(evt:TouchEvent)
	{
		move(FlxPoint.get(evt.stageX, evt.stageY));
	}
	
	public static function mouseBegin(evt:MouseEvent)
	{
		begin(FlxPoint.get(evt.stageX, evt.stageY));
	}
	public static function mouseEnd(evt:MouseEvent)
	{
		end(FlxPoint.get(evt.stageX, evt.stageY));
	}
	public static function mouseMove(evt:MouseEvent)
	{
		move(FlxPoint.get(evt.stageX, evt.stageY));
	}
	
	public static function update(_)
	{
		// trace("touched: " + touched + " | released: " + released + " | held: " + held);
		currentGesture = "NONE";
		released = false;
		touched = false;
	}
}