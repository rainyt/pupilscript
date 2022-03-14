package editer;

import script.core.Script;
import haxe.Json;
import script.core.Trace;
import feathers.data.ArrayCollection;
import feathers.controls.PopUpListView;
import feathers.controls.TextInput;
import script.core.IScript;
import openfl.text.TextField;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import script.core.Break;
import script.core.Aync;
import pupil.Move;
import pupil.SetPoint;
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

	public var array:ArrayCollection<DisplayObject> = new ArrayCollection();

	public function new() {
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, function(e) {
			#if !pupilediter
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

			var quad2 = new Sprite();
			this.addChild(quad2);
			quad2.graphics.beginFill(0xff0000);
			quad2.graphics.drawRect(0, 0, 50, 50);
			quad2.x = 400;
			quad2.y = 200;

			quad.name = "quad";
			quad2.name = "quad2";

			array.add(quad);
			array.add(quad2);

			var pupil = new Pupil();
			pupil.addScript(new SetPoint(200, 200), quad);
			var loop = new Aync();
			loop.addScript(new Move(1, 100, 0), quad);
			loop.addScript(new Move(2, -100, 0), quad);
			var loop2 = new Loop();
			loop2.addScript(new Move(1, 0, -100), quad);
			loop2.addScript(new Break());
			loop.addScript(loop2);
			loop.addScript(new Trace("大家好，我是输出！"));
			pupil.addScript(loop);
			// pupil.start();

			parserScript(pupil);

			script.draw(pupil);

			var json = Json.stringify(pupil.toScriptData());
			trace(json);

			var scriptRecovery = Script.fromText(json);
			trace("还原", scriptRecovery);
			#end

			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		});
	}

	public function parserScript(script:IScript):Void {
		if (scripts.indexOf(script) == -1) {
			scripts.push(script);
		}
		for (s in script.scripts) {
			parserScript(s);
		}
	}

	private var _currentScriptSprite:ScriptSprite;

	private var _readyAddScriptSprite:ScriptSprite;

	private function onMouseDown(e:MouseEvent):Void {
		_currentScriptSprite = null;
		var display:DisplayObject = e.target;
		if (display == null)
			return;
		if (!Std.isOfType(display, ScriptSprite)) {
			display = display.parent;
		}
		// 如果是输入组件，则忽略
		if (Std.isOfType(display, TextInput)) {
			return;
		}
		// 如果是下拉组件，则忽略
		if (Std.isOfType(display, PopUpListView)) {
			return;
		}
		if (display == null)
			return;
		if (!Std.isOfType(display, ScriptSprite)) {
			display = display.parent;
		}
		if (display == null)
			return;
		if (!Std.isOfType(display, ScriptSprite)) {
			display = display.parent;
		}
		if (display == null)
			return;
		if (!Std.isOfType(display, ScriptSprite))
			return;
		if (cast(display, ScriptSprite).type == SELECT) {
			// 添加到舞台
			var sprite = new ScriptSprite(NONE);
			this.addChild(sprite);
			var classObj = Type.getClass(cast(display, ScriptSprite).script);
			var script = Type.createInstance(classObj, []);
			sprite.draw(script);
			parserScript(script);
			return;
		}
		_currentScriptSprite = cast display;
		_currentScriptSprite.startDrag();
		_currentScriptSprite.parent.setChildIndex(_currentScriptSprite, _currentScriptSprite.parent.numChildren);
	}

	private function onMouseMove(e:MouseEvent):Void {
		if (_currentScriptSprite == null)
			return;
		if (!Std.isOfType(_currentScriptSprite.script, Pupil)) {
			if (Std.isOfType(_currentScriptSprite.parent, ScriptSprite)
				&& !cast(_currentScriptSprite.parent, ScriptSprite).test(_currentScriptSprite)
					&& _currentScriptSprite.script.parent != null) {
				// 拆解逻辑
				_currentScriptSprite.script.parent.removeScript(_currentScriptSprite.script, false);
				if (Std.isOfType(_currentScriptSprite.parent, ScriptSprite))
					cast(_currentScriptSprite.parent, ScriptSprite).resetDraw();
				PupilscriptMain.scriptStage.addChild(_currentScriptSprite);
			} else {
				// 组装逻辑
				_readyAddScriptSprite = null;
				if (ScriptSprite.line.parent != null) {
					ScriptSprite.line.parent.removeChild(ScriptSprite.line);
				}
				for (script in scripts) {
					var spriteScript:ScriptSprite = script.customData;
					if (spriteScript.script.supportChildScript
						&& spriteScript != _currentScriptSprite
						&& spriteScript.test(_currentScriptSprite)) {
						_readyAddScriptSprite = spriteScript;
						_readyAddScriptSprite.getAddScriptIndex(_currentScriptSprite);
						break;
					}
				}
			}
		}
	}

	private function onMouseUp(e:MouseEvent):Void {
		this.stopDrag();
		if (_currentScriptSprite != null && _readyAddScriptSprite != null) {
			var hitIndex = _readyAddScriptSprite.getAddScriptIndex(_currentScriptSprite);
			_readyAddScriptSprite.script.addScriptAt(_currentScriptSprite.script, hitIndex, _currentScriptSprite.script.display);
			_readyAddScriptSprite.resetDraw();
		} else if (_currentScriptSprite != null) {
			_currentScriptSprite.resetDraw();
		}
		if (ScriptSprite.line.parent != null) {
			ScriptSprite.line.parent.removeChild(ScriptSprite.line);
		}
		_readyAddScriptSprite = null;
		_currentScriptSprite = null;
	}
}
