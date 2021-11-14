package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;

class MenuSelection extends TempoState
{
	public var selectedItem:Int = 0;
	public var unselectedAlpha:Float = 0.2;
	public var selectedAlpha:Float = 1;

	public var levelList:FlxTypedSpriteGroup<TextItem>;
	public var goBack:FlxText;
	public var songCount:FlxText;
	public var completedIndicator:FlxText;

	public var daItemSize:Int = 28;
	public var itemOffset:Int = 8;

	override public function create()
	{
		var defFont:String = "fonts/archivoblack.ttf";

		levelList = new FlxTypedSpriteGroup<TextItem>();
		add(levelList);

		var posOffset:Int = 10;

		var songCountSize:Int = 24;

		songCount = new FlxText(0, posOffset, 0, "Songs: 0", songCountSize, true);
		songCount.font = defFont;
		songCount.screenCenter(X);
		songCount.alignment = CENTER;
		add(songCount);
		
		completedIndicator = new FlxText(0, songCountSize + (posOffset * 2), "NOT COMPLETED", 18, true);
		completedIndicator.font = defFont;
		completedIndicator.screenCenter(X);
		completedIndicator.alignment = CENTER;
		add(completedIndicator);

		var goBackSize:Int = 14;

		goBack = new FlxText(0, 0, 0, "Press Enter To Select\nAnd Press Backspace/ESC To Go Back To Menu\n", goBackSize, true);
		goBack.font = defFont;
		goBack.screenCenter(X);
		goBack.y = FlxG.height - ((goBackSize + posOffset) * 2);
		goBack.alignment = CENTER;
		add(goBack);

		for (i in 0...Data.songNames.length)
		{
			var daSong:TextItem = new TextItem(0, 0, 0, Data.songNames[i], daItemSize, true);
			daSong.alignment = CENTER;
			daSong.screenCenter();
			daSong.y += (daItemSize + itemOffset) * i;
			daSong.alpha = unselectedAlpha;
			daSong.font = defFont;
			daSong.itemName = Data.songNames[i];
			levelList.add(daSong);
		}

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Data.songNames.length > 0)
		{
			if (FlxG.keys.justPressed.UP)
			{
				selectedItem--;
				Sfx.scroll();
			}
			if (FlxG.keys.justPressed.DOWN)
			{
				selectedItem++;
				Sfx.scroll();
			}

			if (selectedItem < 0) selectedItem = levelList.length - 1;
			if (selectedItem > levelList.length - 1) selectedItem = 0;
			
			// trace("selct: " + selectedItem);

			levelList.y = FlxMath.lerp(0 - ((daItemSize + itemOffset) * selectedItem), levelList.y, velFromFps(0.8));

			levelList.forEachAlive(function(item:TextItem)
			{
				var itemIndex:Int = Data.songNames.indexOf(item.itemName);
				// trace("itm: " + itemIndex);
				if (checkNearestInt(selectedItem, itemIndex))
				{
					var alphaVel:Float = velFromFps(0.85);
					if (itemIndex == selectedItem)
					{
						item.alpha = FlxMath.lerp(selectedAlpha, item.alpha, alphaVel);
						if (FlxG.keys.justPressed.ENTER)
						{
							Sfx.select();
							Switch.switchState(new PlayState(Data.songData[item.itemName]));
						}
					}
					else
						item.alpha = FlxMath.lerp(unselectedAlpha, item.alpha, alphaVel);
				}
				else
					item.alpha = 0;
			});
			
			songCount.text = "Songs: " + Data.songNames.length;
		}
		
		if (FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ESCAPE)
		{
			Sfx.select();
			Switch.switchState(new Menu(), false);
		}
	}

	public function velFromFps(vel:Float):Float
	{
		return (vel / FlxG.updateFramerate) * 60;
	}

	public function checkNearestInt(int1:Int, int2:Int, nearestPixel:Int = 1):Bool
	{
		return int2 >= int1 - nearestPixel && int2 <= int1 + nearestPixel;
	}
}