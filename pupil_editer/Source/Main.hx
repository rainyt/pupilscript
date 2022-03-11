package;

import script.core.Script;
import editer.ScriptStage;
import script.core.Break;
import pupil.Move;
import openfl.text.TextField;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import script.core.OneLoop;
import script.core.If;
import script.core.Loop;
import script.ScriptSprite;
import feathers.skins.RectangleSkin;
import feathers.layout.AnchorLayoutData;
import feathers.layout.AnchorLayout;
import editer.LeftMenu;
import feathers.controls.Application;

/**
 * PupilScript可视化编辑器
 */
class Main extends Application {
	public static var leftMenu:LeftMenu;

	public static var current:Main;

	public static var scriptStage:ScriptStage;

	public function new() {
		super();
		current = this;
		this.backgroundSkin = new RectangleSkin(SolidColor(0x252525));
		this.layout = new AnchorLayout();
		leftMenu = new LeftMenu();
		this.addChild(leftMenu);
		leftMenu.layoutData = new AnchorLayoutData(0, null, 0, 0);

		scriptStage = new ScriptStage();
		this.addChild(scriptStage);
		scriptStage.layoutData = new AnchorLayoutData(0, 0, 0, 60);
	}
}
