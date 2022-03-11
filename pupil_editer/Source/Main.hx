package;

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

	public function new() {
		super();
		this.backgroundSkin = new RectangleSkin(SolidColor(0x252525));
		this.layout = new AnchorLayout();
		leftMenu = new LeftMenu();
		this.addChild(leftMenu);
		leftMenu.layoutData = new AnchorLayoutData(0, null, 0, 0);

		var script = new ScriptSprite(PLAY);
		this.addChild(script);
		script.x = 400;
		script.y = 400;

		var obj = {x: 0, y: 0};
		var pupil = new Pupil();
		// pupil.addScript(obj,new Loop());
		pupil.addScript(obj, new Loop().addScript(obj, new Loop().addScript(obj, new OneLoop()).addScript(obj, new OneLoop()).addScript(obj, new OneLoop())))
			.addScript(obj, new If((data) -> true));
		script.draw(pupil);
	}
}
