package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Block extends FlxSprite
{
	public var pos:Int = -1;
	public var breakable:Bool = false;
	public var vel:Float = 0;
	public var paused:Bool = false;
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (breakable) color = 0xFFFF9A9A;
		if (!paused) velocity.y = vel * FlxG.updateFramerate else velocity.y = 0;
	}
}