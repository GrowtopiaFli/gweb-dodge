package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Enemy extends FlxSprite
{
	public var timeLived:Float = 0;
	public var dead:Bool = false;

	public function new(daX:Float = 0, daY:Float = 0)
	{
		super(daX, daY);
		frames = FlxAtlasFrames.fromSpriteSheetPacker("assets/images/Enemy.png", "assets/images/Enemy.txt");
		animation.addByPrefix("anim", "Enemy_", 8);
		animation.play("anim", true);
	}
	
	public var midpointX(get, null):Float;
	public var midpointY(get, null):Float;
	
	public function get_midpointX():Float
	{
		return getMidpoint().x;
	}
	
	public function get_midpointY():Float
	{
		return getMidpoint().y;
	}
}