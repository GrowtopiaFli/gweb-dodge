package;

import flixel.FlxG;

class Controller
{
	public static var enter(get, null):Bool;
	public static var back(get, null):Bool;
	public static var up(get, null):Bool;
	public static var down(get, null):Bool;
	public static var left(get, null):Bool;
	public static var right(get, null):Bool;
	
	public static function get_enter():Bool
		return FlxG.keys.justPressed.ENTER || (Touch.currentGesture == "NONE" && Touch.released);
	public static function get_back():Bool
		return FlxG.keys.anyJustPressed([BACKSPACE, ESCAPE]);
	public static function get_up():Bool
		return FlxG.keys.justPressed.UP || (Touch.currentGesture == "UP");
	public static function get_down():Bool
		return FlxG.keys.justPressed.DOWN || (Touch.currentGesture == "DOWN");
	public static function get_left():Bool
		return FlxG.keys.justPressed.LEFT || (Touch.currentGesture == "LEFT");
	public static function get_right():Bool
		return FlxG.keys.justPressed.RIGHT || (Touch.currentGesture == "RIGHT");
}