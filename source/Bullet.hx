package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class Bullet extends FlxSprite
{
	public var funiAngle:Float = 0;
	public var vel:FlxPoint = FlxPoint.get(0, 0);
	public var pos:Int = 0;
	public var cantKill:Bool = false;

	public function new(daX:Float = 0, daY:Float = 0, w:Int = 1, h:Int = 1, col:FlxColor = FlxColor.WHITE)
	{
		super(daX, daY);
		makeGraphic(w, h, col);
		x -= width / 2;
		y -= height / 2;
	}
}