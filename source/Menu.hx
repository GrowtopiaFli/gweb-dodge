package;

import assets.*;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;

import flixel.system.FlxSound;

class Menu extends TempoState
{
	public var selectedMenuItem:Int = 0;
	public var unselectedAlpha:Float = 0.2;
	public var selectedAlpha:Float = 1;

	public var menuItems:FlxTypedSpriteGroup<TextItem>;
	public var itemList:Array<String> = ["Play", "About", "Instructions", "Exit"];
	
	public static var menuAudio:FlxSound;
	
	public function new(play:Bool = false)
	{
		super();
		if (play) menuAudio.play(true);
	}

	override public function create()
	{
		var daFont:String = "fonts/archivoblack.ttf";
		
		var title:FlxText = new FlxText(0, 20, 0, "GWeb Dodge", 40, true);
		title.font = daFont;
		title.screenCenter(X);
		add(title);
		
		menuItems = new FlxTypedSpriteGroup<TextItem>();
		add(menuItems);

		var daSize:Int = 40;
		var daAdd:Int = 140;

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
					daText.y -= daSize + 10;
					menuItems.add(daText);
				case 2:
					var daText:TextItem = new TextItem(0, 0, 0, itemList[i], daSize, true);
					daText.alignment = CENTER;
					daText.font = daFont;
					daText.itemName = daText.text;
					daText.alpha = unselectedAlpha;
					daText.screenCenter();
					daText.y += daSize + 10;
					menuItems.add(daText);
				case 3:
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
		
		if (menuAudio.volume <= 0) menuAudio.volume = 1;
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!menuAudio.playing)
			playMenuMusic();
		
		if (itemList.length > 0)
		{
			if (Controller.up)
			{
				selectedMenuItem--;
				Sfx.scroll();
			}
			if (Controller.down)
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
					if (Controller.enter)
					{
						Sfx.select();
						switch (item.itemName.toLowerCase())
						{
							case "play":
								Switch.switchState(new MenuSelection(), false);
							case "about":
								Switch.switchState(new About(), false);
							case "instructions":
								Switch.switchState(new Instructions(), false);
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
	
	public static function playMenuMusic()
	{
		// FlxG.sound.playMusic("assets/menu/menu_music.ogg");
		Menu.menuAudio.resume();
	}
}