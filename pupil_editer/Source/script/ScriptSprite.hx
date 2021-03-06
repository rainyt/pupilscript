package script;

import game.world.World;
import game.world.IDisplay;
import script.core.Desc.ParamClass;
import script.core.Script;
import feathers.controls.Check;
import feathers.text.TextFormat;
import openfl.display.DisplayObject;
import feathers.data.ArrayCollection;
import feathers.controls.PopUpListView;
import openfl.events.MouseEvent;
import feathers.controls.Button;
import feathers.controls.TextInput;
import openfl.events.Event;
import feathers.layout.VerticalAlign;
import feathers.controls.Label;
import feathers.layout.HorizontalLayout;
import feathers.controls.LayoutGroup;
import openfl.geom.Point;
import openfl.text.TextField;
import script.core.IScript;

/**
 * 脚本精灵
 */
class ScriptSprite extends LayoutGroup {
	public static var line:ScriptLine = new ScriptLine();

	public static var point:Point = new Point();

	public var layoutGroup:LayoutGroup;

	public var label:TextField;

	public var type:ScriptType;

	public var script:IScript;

	public var inputs:Map<String, TextInput> = [];

	public function new(type:ScriptType) {
		super();

		this.type = type;

		label = new TextField();
		label.selectable = false;
		label.x = 5;
		label.height = 20;

		layoutGroup = new LayoutGroup();
		this.addChild(layoutGroup);
		layoutGroup.layout = new HorizontalLayout();
		cast(layoutGroup.layout, HorizontalLayout).verticalAlign = VerticalAlign.MIDDLE;
		// layoutGroup.width = 200;
		layoutGroup.height = 36;
		cast(layoutGroup.layout, HorizontalLayout).paddingLeft = 5;
		cast(layoutGroup.layout, HorizontalLayout).paddingRight = 5;
		layoutGroup.addEventListener(Event.RESIZE, function(e) {
			draw(script, false);
		});
	}

	public var scriptHeight:Float = 0;

	public function resetDraw():Void {
		if (script != null) {
			draw(script);
			if (parent != null && Std.isOfType(this.parent, ScriptSprite)) {
				cast(this.parent, ScriptSprite).resetDraw();
			}
		}
	}

	private function bindTextInputChange(textInput:TextInput, key:String, type:ParamClass):Void {
		textInput.addEventListener(Event.CHANGE, function(e) {
			var setValue = textInput.text;
			if (setValue.indexOf("${") != -1 && setValue.indexOf("}") != -1) {
				// 覆盖绑定
				setValue = StringTools.replace(setValue, "${", "");
				setValue = StringTools.replace(setValue, "}", "");
				cast(script, Script).paramsBind.set(key, setValue);
			} else {
				cast(script, Script).paramsBind.remove(key);
				if (type == AUTO) {
					Reflect.setProperty(script, key, setValue);
				} else if (type == STRING)
					Reflect.setProperty(script, key, setValue);
				else
					Reflect.setProperty(script, key, Std.parseFloat(setValue));
			}
		});
		if (cast(script, Script).paramsBind.exists(key))
			textInput.text = "${" + cast(script, Script).paramsBind.get(key) + "}";
		else
			textInput.text = Std.string(Reflect.getProperty(script, key));
		inputs.set(key, textInput);
	}

	private function bindButtonClick(button:Button, cb:Void->Void):Void {
		button.addEventListener(MouseEvent.CLICK, function(e) {
			cb();
			// 刷新数据
			updateData();
		});
	}

	private function bindCheckButton(check:Check, key:String):Void {
		check.selected = Reflect.getProperty(script, key) == true;
		check.addEventListener(Event.CHANGE, function(e) {
			Reflect.setProperty(script, key, check.selected);
		});
	}

	public function updateData():Void {
		for (key => textInput in inputs) {
			textInput.text = Std.string(Reflect.getProperty(script, key));
		}
	}

	private function bindPopUpListView(drop:TextInput):Void {
		// drop.itemToText = (data:DisplayObject) -> data.name;
		drop.addEventListener(Event.CHANGE, function(e) {
			script.display = null;
			for (display in World.currentWorld.displays) {
				if (display.name == drop.text || (display.displayData != null && display.displayData.assets == drop.text)) {
					script.display = display;
					break;
				}
			};
			trace("发生变化", script.display);
		});
	}

	public function draw(script:IScript, clean:Bool = true):Void {
		if (script == null)
			return;

		this.script = script;

		if (clean)
			this.removeChildren();

		if (layoutGroup.numChildren == 0) {
			if (script.needDisplay) {
				var drop = new TextInput(script.display != null ? cast(script.display, IDisplay).name : "");
				// var drop = new PopUpListView(PupilscriptMain.scriptStage.array);
				// drop.selectedItem = script.display;
				layoutGroup.addChild(drop);
				bindPopUpListView(drop);
			}
			if (script.desc != null) {
				for (index => value in script.desc) {
					switch (value) {
						case TEXT(text):
							var label = new Label(text);
							layoutGroup.addChild(label);
							label.textFormat = new TextFormat(null, 16, 0xffffff);
						case INPUT(key, width, type):
							var input = new TextInput();
							if (width != 0)
								input.width = width;
							else {
								input.autoSizeWidth = true;
							}
							layoutGroup.addChild(input);
							bindTextInputChange(input, key, type);
						case DEBUG(text, cb):
							var button = new Button(text);
							layoutGroup.addChild(button);
							bindButtonClick(button, cb);
						case BOOL(key, text):
							var check = new Check(text);
							layoutGroup.addChild(check);
							bindCheckButton(check, key);
					}
				}
			} else {
				var pname = script.name == null ? Type.getClassName(Type.getClass(script)) : script.name;
				var label = new Label(pname);
				label.textFormat = new TextFormat(null, 16, 0xffffff);
				layoutGroup.addChild(label);
			}
		}
		if (clean)
			this.addChild(layoutGroup);
		script.customData = this;
		var itemHeight = 36;
		var itemWidth = layoutGroup.width + 10;
		var bottomHeight = 16;
		var offestX:Float = bottomHeight;
		var offestY:Float = itemHeight;
		this.graphics.clear();
		this.graphics.beginFill(cast script.color, 1);
		this.graphics.lineStyle(1, 0x0);
		this.graphics.drawRoundRectComplex(0, 0, itemWidth, itemHeight, 0, itemHeight / 2, 0, itemHeight / 2);
		scriptHeight = 36;

		if (script.supportChildScript) {
			if (script.scripts.length == 0) {
				scriptHeight += itemHeight / 2;
				offestY += itemHeight / 2;
			} else
				for (s in script.scripts) {
					var newSprite:ScriptSprite = s.customData == null ? new ScriptSprite(NONE) : s.customData;
					if (clean) {
						this.addChild(newSprite);
						newSprite.draw(s);
					}
					newSprite.x = offestX;
					newSprite.y = offestY;
					offestY += newSprite.scriptHeight;
					scriptHeight += newSprite.scriptHeight;
				}
			this.graphics.drawRect(0, 36, bottomHeight, offestY - itemHeight);
			this.graphics.drawRoundRectComplex(0, offestY, itemWidth * 3 / 4, bottomHeight, 0, bottomHeight / 2, 0, bottomHeight / 2);
			scriptHeight += bottomHeight;
		}
		this.height = scriptHeight + 15;
	}

	/**
	 * 获取添加的索引位置
	 * @return Int
	 */
	public function getAddScriptIndex(sprite:ScriptSprite):Int {
		point.x = this.x;
		point.y = this.y;
		point = this.parent.localToGlobal(point);
		point = PupilscriptMain.scriptStage.globalToLocal(point);
		var index = 0;
		var lineY:Float = 36;
		for (i => s in script.scripts) {
			var display = cast(s.customData, ScriptSprite);
			if (sprite.y > point.y + display.y + display.scriptHeight / 2) {
				index = i + 1;
				lineY = display.y + display.scriptHeight;
			}
		}
		line.y = point.y + lineY;
		line.x = 16 + point.x;
		PupilscriptMain.scriptStage.addChild(line);
		return index;
	}

	public function test(sprite:ScriptSprite):Bool {
		point.x = this.x;
		point.y = this.y;
		point = this.parent.localToGlobal(point);
		point = PupilscriptMain.scriptStage.globalToLocal(point);
		if (Math.abs(point.x - sprite.x) < 32 && sprite.y > point.y && sprite.y < point.y + this.scriptHeight) {
			return true;
		}
		return false;
	}
}

enum ScriptType {
	NONE;
	PLAY;
	SELECT;
}
