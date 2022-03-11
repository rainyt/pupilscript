package;

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

	public function new() {
		super();
		current = this;
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
		loop.addScript(quad, new Move(2, -100, 0));
		var loop2 = new Loop();
		loop2.addScript(quad, new Move(1, 0, -100));
		loop2.addScript(quad, new Break());
		loop.addScript(quad, loop2);
		pupil.addScript(quad, loop);
		pupil.start();

		script.draw(pupil);

		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	private var _currentScriptSprite:ScriptSprite;

	private function onMouseDown(e:MouseEvent):Void {
		_currentScriptSprite = null;
		var display:DisplayObject = e.target;
		if (Std.isOfType(display, TextField)) {
			display = display.parent;
		}
		if (!Std.isOfType(display, ScriptSprite))
			return;
		_currentScriptSprite = cast display;
		_currentScriptSprite.startDrag();
	}

	private function onMouseMove(e:MouseEvent):Void {
		if (_currentScriptSprite == null)
			return;
		trace(_currentScriptSprite.x);
	}

	private function onMouseUp(e:MouseEvent):Void {
		this.stopDrag();
		_currentScriptSprite = null;
	}
}
