package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Block extends FlxSprite
{
	public var pos:Int = -1;
	public var breakable:Bool = false;
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (breakable) color = FlxColor.YELLOW;
	}
}