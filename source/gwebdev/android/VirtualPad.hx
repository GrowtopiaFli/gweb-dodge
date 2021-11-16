package gwebdev.android;

import assets.*;

import flixel.FlxG;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import flixel.util.FlxDestroyUtil;
import flixel.ui.FlxButton;
import flixel.graphics.frames.FlxAtlasFrames;
import flash.display.BitmapData;
import flixel.graphics.FlxGraphic;
import openfl.utils.ByteArray;

@:keep @:bitmap("assets/images/android-pad.png")
class GraphicVirtualInput extends BitmapData {}
 
@:file("assets/images/android-pad.txt")
class VirtualInputData extends #if (lime_legacy || nme) ByteArray #else ByteArrayData #end {}

class VirtualPad extends FlxSpriteGroup
{
	// Thanks luckydog7
	public var buttonA:FlxButton;
	public var buttonB:FlxButton;
	public var buttonC:FlxButton;
	public var buttonY:FlxButton;
	public var buttonX:FlxButton;
	public var buttonLeft:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;
	public var buttonDown:FlxButton;
	
	public var dPad:FlxSpriteGroup;
	
	public var actions:FlxSpriteGroup;
	
	public function new(?DPad:FlxDPadMode, ?Action:FlxActionMode, ?customData1:Array<Array<Float>>, ?customData2:Array<Array<Float>>)
	{
		super();
		scrollFactor.set();

		if (DPad == null)
			DPad = FULL;
		if (Action == null)
			Action = A_B_C;

		dPad = new FlxSpriteGroup();
		dPad.scrollFactor.set();

		actions = new FlxSpriteGroup();
		actions.scrollFactor.set();
		
		if (customData1 != null && customData1.length == 4)
		{
			for (i in 0...customData1.length)
			{
				if (customData1[i].length == 4)
				{
					switch (i)
					{
						case 0:
							dPad.add(add(buttonUp = createButton(customData1[i][0], customData1[i][1], Math.floor(customData1[i][2]), Math.floor(customData1[i][3]), "up")));
						case 1:
							dPad.add(add(buttonDown = createButton(customData1[i][0], customData1[i][1], Math.floor(customData1[i][2]), Math.floor(customData1[i][3]), "down")));
						case 2:
							dPad.add(add(buttonLeft = createButton(customData1[i][0], customData1[i][1], Math.floor(customData1[i][2]), Math.floor(customData1[i][3]), "left")));
						case 3:
							dPad.add(add(buttonRight = createButton(customData1[i][0], customData1[i][1], Math.floor(customData1[i][2]), Math.floor(customData1[i][3]), "right")));
						default:
							openfl.system.System.exit(0);
					}
				}
			}
		}
		else
		{
			switch (DPad)
			{
				case UP_DOWN:
					dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3, 44 * 3, 45 * 3, "up")));
					dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "down")));
				case LEFT_RIGHT:
					dPad.add(add(buttonLeft = createButton(0, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "left")));
					dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "right")));
				case UP_LEFT_RIGHT:
					dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 81 * 3, 44 * 3, 45 * 3, "up")));
					dPad.add(add(buttonLeft = createButton(0, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "left")));
					dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "right")));
				case FULL:
					dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, "up")));
					dPad.add(add(buttonLeft = createButton(0, FlxG.height - 81 * 3, 44 * 3, 45 * 3, "left")));
					dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 81 * 3, 44 * 3, 45 * 3, "right")));
					dPad.add(add(buttonDown = createButton(35 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "down")));
				case RIGHT_FULL:
					dPad.add(add(buttonUp = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 116 * 3, 44 * 3, 45 * 3, "up")));
					dPad.add(add(buttonLeft = createButton(FlxG.width - 130 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 45 * 3, "left")));
					dPad.add(add(buttonRight = createButton(FlxG.width - 44 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 45 * 3, "right")));
					dPad.add(add(buttonDown = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 45 * 3, 44 * 3, 45 * 3, "down")));
				case NONE:
			}
		}

		if (customData2 != null && customData2.length == 4)
		{
			for (i in 0...customData2.length)
			{
				if (customData2[i].length == 4)
				{
					switch (i)
					{
						case 0:
							actions.add(add(buttonA = createButton(customData2[i][0], customData2[i][1], Math.floor(customData2[i][2]), Math.floor(customData2[i][3]), "a")));
						case 1:
							actions.add(add(buttonB = createButton(customData2[i][0], customData2[i][1], Math.floor(customData2[i][2]), Math.floor(customData2[i][3]), "b")));
						case 2:
							actions.add(add(buttonX = createButton(customData2[i][0], customData2[i][1], Math.floor(customData2[i][2]), Math.floor(customData2[i][3]), "x")));
						case 3:
							actions.add(add(buttonY = createButton(customData2[i][0], customData2[i][1], Math.floor(customData2[i][2]), Math.floor(customData2[i][3]), "y")));
						default:
							openfl.system.System.exit(0);
					}
				}
			}
		}
		else
		{
			switch (Action)
			{
				case A:
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "a")));
				case A_B:
					actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "a")));
					actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "b")));
				case A_B_C:
					actions.add(add(buttonA = createButton(FlxG.width - 128, FlxG.height - 45, 44, 45, "a")));
					actions.add(add(buttonB = createButton(FlxG.width - 86, FlxG.height - 45, 44, 45, "b")));
					actions.add(add(buttonC = createButton(FlxG.width - 44, FlxG.height - 45, 44, 45, "c")));
				case A_B_X_Y:
					actions.add(add(buttonY = createButton(FlxG.width - 86, FlxG.height - 85, 44, 45, "y")));
					actions.add(add(buttonX = createButton(FlxG.width - 44, FlxG.height - 85, 44, 45, "x")));
					actions.add(add(buttonB = createButton(FlxG.width - 86, FlxG.height - 45, 44, 45, "b")));
					actions.add(add(buttonA = createButton(FlxG.width - 44, FlxG.height - 45, 44, 45, "a")));
				case NONE:
			}
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		dPad = FlxDestroyUtil.destroy(dPad);
		actions = FlxDestroyUtil.destroy(actions);

		dPad = null;
		actions = null;
		buttonA = null;
		buttonB = null;
		buttonC = null;
		buttonY = null;
		buttonX = null;
		buttonLeft = null;
		buttonUp = null;
		buttonDown = null;
		buttonRight = null;
	}

	public function createButton(X:Float, Y:Float, Width:Int, Height:Int, Graphic:String, ?OnClick:Void->Void):FlxButton
	{
		var button = new FlxButton(X, Y);
		var frame = getVirtualInputFrames().getByName(Graphic);
		button.frames = FlxTileFrames.fromFrame(frame, FlxPoint.get(Width, Height));
		button.resetSizeFromFrame();
		button.solid = false;
		button.immovable = true;
		button.scrollFactor.set();

		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end

		if (OnClick != null)
			button.onDown.callback = OnClick;

		return button;
	}

	public static function getVirtualInputFrames():FlxAtlasFrames
	{
		#if !web
		var bitmapData = new GraphicVirtualInput(0, 0);
		var graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmapData);
		return FlxAtlasFrames.fromSpriteSheetPacker(graphic, Std.string(new VirtualInputData()));
		#else
		var graphic:FlxGraphic = FlxGraphic.fromAssetKey('assets/images/android-pad.png');
		return FlxAtlasFrames.fromSpriteSheetPacker(graphic, Std.string(new VirtualInputData()));
		#end
	}
}

enum FlxDPadMode
{
	NONE;
	UP_DOWN;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	RIGHT_FULL;
	FULL;
}

enum FlxActionMode
{
	NONE;
	A;
	A_B;
	A_B_C;
	A_B_X_Y;
}