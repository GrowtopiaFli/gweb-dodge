package;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxAngle;

class GWebUtils
{
	public static function getYOfCanvasFromPlayer(midX:Float, midY:Float, x2:Float, y2:Float):Float
	{
		return ( ( y2 - midY ) / ( x2 - midX ) ) * ( FlxG.width - x2 ) + ( y2 );
	}
	
	public static function angleBetweenObj(midX:Float, midY:Float, x2:Float, y2:Float):Float
	{
		var toRet:Float = Math.atan2( ( getYOfCanvasFromPlayer(midX, midY, x2, y2) - FlxG.height ) - ( midY - FlxG.height ), FlxG.width - midX ) * ( 180 / Math.PI );
		var secondIsDiff_X:Bool = x2 < midX;
		var secondIsDiff_ADD_Y:Bool = midY > y2;
		var secondIsDiff_SUB_Y:Bool = y2 > midY;
		var second_sub:Bool = secondIsDiff_X && secondIsDiff_SUB_Y && toRet > -90;
		var second_add:Bool = secondIsDiff_X && secondIsDiff_ADD_Y && toRet < 90;
		if (second_sub)
			toRet += 180;
		if (second_add)
			toRet -= 180;
		var angleSign:Int = (toRet < 0) ? -1 : 1;
		if (angleSign == -1)
			toRet += 360;
		if (toRet >= 360)
			toRet -= 360;
		if (toRet <= -360)
			toRet += 360;
		return toRet;
	}
	
	public static function getVelocityFromAngleBetweenSecond(midX:Float, midY:Float, x2:Float, y2:Float, velX:Float, velY:Float):FlxPoint
	{
		return getVelocityFromAngle(velX, velY, angleBetweenObj(midX, midY, x2, y2));
	}
	
	public static function getVelocityFromAngle(velX:Float, velY:Float, angle:Float)
	{
		return velocityFromDeg(velX, velY, angle);
	}
	
	public static function velocityFromDeg(x:Float, y:Float, deg:Float):FlxPoint
	{
		var rad:Float = FlxAngle.asRadians(deg);
		x *= Math.cos(rad);
		y *= Math.sin(rad);
		return FlxPoint.get(x, y);
	}

	public static function round2(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}
}