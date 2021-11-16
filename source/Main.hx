package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.TouchEvent;
import openfl.events.MouseEvent;

#if android
import extension.androidorientation.AndroidOrientation;
#end

class Main extends Sprite
{
	var gameWidth:Int = 480;
	var gameHeight:Int = 640;
	var initialState:Class<FlxState> = PreMenu;
	var zoom:Float = 1;
	var framerate:Int = 60;
	var skipSplash:Bool = true;
	var startFullscreen:Bool = false;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		#if android
		Sys.setCwd(lime.system.System.applicationStorageDirectory);
		#end

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		#if android
		AndroidOrientation.setScreenOrientation(AndroidOrientation.SENSOR_PORTRAIT);
		#end
	
		#if android
		addEventListener(TouchEvent.TOUCH_BEGIN, Touch.touchBegin);
		addEventListener(TouchEvent.TOUCH_END, Touch.touchEnd);
		addEventListener(TouchEvent.TOUCH_MOVE, Touch.touchMove);
		#end
		
		addEventListener(MouseEvent.MOUSE_DOWN, Touch.mouseBegin);
		addEventListener(MouseEvent.MOUSE_UP, Touch.mouseEnd);
		addEventListener(MouseEvent.MOUSE_MOVE, Touch.mouseMove);
	
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
		addEventListener(Event.ENTER_FRAME, Touch.update);
	}
}