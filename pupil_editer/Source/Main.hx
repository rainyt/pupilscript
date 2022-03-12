package;

import pupil.SetPoint;
import script.core.Trace;
import script.core.Aync;
import editer.ActionMenu;
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
import editer.ActionMenu;
import feathers.controls.Application;

/**
 * PupilScript可视化编辑器
 */
class Main extends Application {
	public static var leftMenu:ActionMenu;

	public static var current:Main;

	public static var scriptStage:ScriptStage;

	public function new() {
		super();
		current = this;
		this.backgroundSkin = new RectangleSkin(SolidColor(0x252525));
		this.layout = new AnchorLayout();
		leftMenu = new ActionMenu();
		this.addChild(leftMenu);
		leftMenu.layoutData = new AnchorLayoutData(0, null, 0, 0);

		scriptStage = new ScriptStage();
		this.addChild(scriptStage);
		scriptStage.layoutData = new AnchorLayoutData(0, 0, 0, 60);

		// 注册脚本
		leftMenu.addScript(new Loop());
		leftMenu.addScript(new Aync());
		leftMenu.addScript(new Move());
		leftMenu.addScript(new OneLoop());
		leftMenu.addScript(new Trace());
		leftMenu.addScript(new Pupil());
		leftMenu.addScript(new Break());
		leftMenu.addScript(new SetPoint());
	}
}
