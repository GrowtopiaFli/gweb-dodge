package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;

class Menu extends TempoState
{
	public var selectedMenuItem:Int = 0;
	public var unselectedAlpha:Float = 0.2;
	public var selectedAlpha:Float = 1;

	public var menuItems:FlxTypedSpriteGroup<TextItem>;
	public var itemList:Array<String> = ["Play", "About", "Exit"];

	override public function create()
	{
		if (FlxG.sound.music == null || (FlxG.sound.music != null && !FlxG.sound.music.playing))
		{
			playMenuMusic();
		}
		
		var daFont:String = "fonts/archivoblack.ttf";
		
		var title:FlxText = new FlxText(0, 20, 0, "GWeb Dodge", 40, true);
		title.font = daFont;
		title.screenCenter(X);
		add(title);
		
		menuItems = new FlxTypedSpriteGroup<TextItem>();
		add(menuItems);

		var daSize:Int = 40;
		var daAdd:Int = 160;

		for (i in 0...itemList.length)
			switch (i)
			{
				case 0:
					var daText:TextItem = new TextItem(0, Std.parseFloat(Std.string(daAdd)), 0, itemList[i], daSize, true);
					daText.alignment = CENTER;
					daText.font = daFont;
					daText.itemName = daText.text;
					daText.alpha = unselectedAlpha;
					daText.screenCenter(X);
					menuItems.add(daText);
				case 1:
					var daText:TextItem = new TextItem(0, 0, 0, itemList[i], daSize, true);
					daText.alignment = CENTER;
					daText.font = daFont;
					daText.itemName = daText.text;
					daText.alpha = unselectedAlpha;
					daText.screenCenter();
					menuItems.add(daText);
				case 2:
					var daText:TextItem = new TextItem(0, 0, 0, itemList[i], daSize, true);
					daText.alignment = CENTER;
					daText.font = daFont;
					daText.itemName = daText.text;
					daText.alpha = unselectedAlpha;
					daText.y = FlxG.height - daSize - daAdd;
					daText.screenCenter(X);
					menuItems.add(daText);
			}
	
		super.create();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (itemList.length > 0)
		{
			if (FlxG.keys.justPressed.UP)
			{
				selectedMenuItem--;
				Sfx.scroll();
			}
			if (FlxG.keys.justPressed.DOWN)
			{
				selectedMenuItem++;
				Sfx.scroll();
			}

			if (selectedMenuItem < 0) selectedMenuItem = itemList.length - 1;
			if (selectedMenuItem > itemList.length - 1) selectedMenuItem = 0;
			
			var alphaVel:Float = velFromFps(0.85);
				
			menuItems.forEachAlive(function(item:TextItem)
			{
				var itemIndex:Int = itemList.indexOf(item.itemName);
				if (selectedMenuItem == itemIndex)
				{
					item.alpha = FlxMath.lerp(selectedAlpha, item.alpha, alphaVel);
					if (FlxG.keys.justPressed.ENTER)
					{
						Sfx.select();
						switch (item.itemName.toLowerCase())
						{
							case "play":
								Switch.switchState(new MenuSelection(), false);
							case "about":
								Switch.switchState(new About(), false);
							case "exit":
								openfl.system.System.exit(0);
						}
					}
				}
				else item.alpha = FlxMath.lerp(unselectedAlpha, item.alpha, alphaVel);
			});
		}
	}
	
	public function velFromFps(vel:Float):Float
	{
		return (vel / FlxG.updateFramerate) * 60;
	}
	
	public function playMenuMusic()
	{
		FlxG.sound.playMusic("assets/menu/menu_music.ogg");
	}
}