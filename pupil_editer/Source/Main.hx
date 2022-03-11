package;

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

		var quad = new Sprite();
		this.addChild(quad);
		quad.graphics.beginFill(0xffff00);
		quad.graphics.drawRect(0, 0, 50, 50);
		quad.x = 200;
		quad.y = 200;

		var pupil = new Pupil();
		var loop = new Loop();
		loop.addScript(quad, new Move(1, 100, 0));
		loop.addScript(quad, new Move(1, -100, 0));
		pupil.addScript(quad, loop);
		pupil.start();
		
		script.draw(pupil);

		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	private function onMouseDown(e:MouseEvent):Void {
		var display:DisplayObject = e.target;
		if (Std.isOfType(display, TextField)) {
			display = display.parent;
		}
		if (!Std.isOfType(display, Sprite))
			return;
		cast(display, Sprite).startDrag();
	}

	private function onMouseUp(e:MouseEvent):Void {
		this.stopDrag();
	}
}
