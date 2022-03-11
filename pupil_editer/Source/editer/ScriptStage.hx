package editer;

import script.core.IScript;
import openfl.text.TextField;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import script.core.Break;
import pupil.Move;
import script.core.Loop;
import openfl.display.Sprite;
import script.ScriptSprite;
import openfl.events.Event;
import feathers.controls.LayoutGroup;

/**
 * 脚本可视化编辑区域
 */
class ScriptStage extends LayoutGroup {
	/**
	 * 脚本管理
	 */
	public var scripts:Array<IScript> = [];

	public function new() {
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, function(e) {
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
			// pupil.start();

			scripts.push(pupil);

			script.draw(pupil);

			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		});
	}

	private var _currentScriptSprite:ScriptSprite;

	private var _readyAddScriptSprite:ScriptSprite;

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
		if (!Std.isOfType(_currentScriptSprite.script, Pupil)) {
			if (Math.abs(_currentScriptSprite.x) > 10 && _currentScriptSprite.script.parent != null) {
				// 拆解逻辑
				_currentScriptSprite.script.parent.removeScript(_currentScriptSprite.script);
				cast(_currentScriptSprite.parent, ScriptSprite).resetDraw();
				Main.scriptStage.addChild(_currentScriptSprite);
				scripts.push(_currentScriptSprite.script);
			} else {
				// 组装逻辑
				_readyAddScriptSprite = null;
				for (script in scripts) {
					var spriteScript:ScriptSprite = script.customData;
					if (spriteScript != _currentScriptSprite && Math.abs(spriteScript.x - _currentScriptSprite.x) < 10) {
						_readyAddScriptSprite = spriteScript;
						break;
					}
				}
			}
		}
	}

	private function onMouseUp(e:MouseEvent):Void {
		this.stopDrag();
		if (_currentScriptSprite != null && _readyAddScriptSprite != null) {
			_readyAddScriptSprite.script.addScript(_currentScriptSprite.script.display, _currentScriptSprite.script);
			_readyAddScriptSprite.resetDraw();
			scripts.remove(_currentScriptSprite.script);
		}
		_readyAddScriptSprite = null;
		_currentScriptSprite = null;
	}
}
