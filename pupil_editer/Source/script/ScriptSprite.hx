package script;

import script.core.Desc;
import feathers.controls.TextInput;
import feathers.controls.TextArea;
import openfl.events.Event;
import feathers.layout.VerticalAlign;
import feathers.controls.Label;
import feathers.layout.HorizontalLayout;
import feathers.controls.LayoutGroup;
import openfl.geom.Point;
import openfl.text.TextFormat;
import openfl.text.TextField;
import script.core.IScript;
import openfl.display.Sprite;

/**
 * 脚本精灵
 */
class ScriptSprite extends LayoutGroup {
	public static var point:Point = new Point();

	public var layoutGroup:LayoutGroup;

	public var label:TextField;

	public var type:ScriptType;

	public var script:IScript;

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
		layoutGroup.width = 200;
		layoutGroup.height = 36;
		cast(layoutGroup.layout, HorizontalLayout).paddingLeft = 5;
		cast(layoutGroup.layout, HorizontalLayout).paddingRight = 5;
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

	private function bindTextInputChange(textInput:TextInput, key:String):Void {
		textInput.addEventListener(Event.CHANGE, function(e) {
			Reflect.setProperty(script, key, Std.parseFloat(textInput.text));
		});
		textInput.text = Std.string(Reflect.getProperty(script, key));
	}

	public function draw(script:IScript):Void {
		this.script = script;

		this.removeChildren();

		if (layoutGroup.numChildren == 0) {
			if (script.desc != null) {
				for (index => value in script.desc) {
					switch (value) {
						case TEXT(text):
							layoutGroup.addChild(new Label(text));
						case INPUT(key):
							var input = new TextInput();
							input.width = 50;
							layoutGroup.addChild(input);
							layoutGroup.width = 280;
							bindTextInputChange(input, key);
					}
				}
			} else {
				var pname = script.name == null ? Type.getClassName(Type.getClass(script)) : script.name;
				layoutGroup.addChild(new Label(pname));
			}
		}
		this.addChild(layoutGroup);

		trace(layoutGroup.getBounds(null));

		script.customData = this;
		// label.text =
		// label.setTextFormat(new TextFormat(null, 14));
		// label.y = (32 - label.textHeight) / 2;
		// this.addChild(label);
		var itemHeight = 36;
		var itemWidth = layoutGroup.width + 20;
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
					this.addChild(newSprite);
					newSprite.draw(s);
					newSprite.x = offestX;
					newSprite.y = offestY;
					offestY += newSprite.scriptHeight;
					scriptHeight += newSprite.scriptHeight;
				}
			this.graphics.drawRect(0, 36, bottomHeight, offestY - itemHeight);
			this.graphics.drawRoundRectComplex(0, offestY, itemWidth * 3 / 4, bottomHeight, 0, bottomHeight / 2, 0, bottomHeight / 2);
			scriptHeight += bottomHeight;
		}
	}

	/**
	 * 获取添加的索引位置
	 * @return Int
	 */
	public function getAddScriptIndex(sprite:ScriptSprite):Int {
		point.x = this.x;
		point.y = this.y;
		point = this.parent.localToGlobal(point);
		point = Main.scriptStage.globalToLocal(point);
		var index = 0;
		for (i => s in script.scripts) {
			var display = cast(s.customData, ScriptSprite);
			trace(sprite.y, point.y + display.y + display.scriptHeight / 2);
			if (sprite.y > point.y + display.y + display.scriptHeight / 2) {
				index = i + 1;
			}
		}
		return index;
	}

	public function test(sprite:ScriptSprite):Bool {
		point.x = this.x;
		point.y = this.y;
		point = this.parent.localToGlobal(point);
		point = Main.scriptStage.globalToLocal(point);
		if (Math.abs(point.x - sprite.x) < 32 && sprite.y > point.y && sprite.y < point.y + this.scriptHeight) {
			return true;
		}
		return false;
	}
}

enum ScriptType {
	NONE;
	PLAY;
}
