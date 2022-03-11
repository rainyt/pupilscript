package script;

import openfl.geom.Point;
import openfl.text.TextFormat;
import openfl.text.TextField;
import script.core.IScript;
import openfl.display.Sprite;

/**
 * 脚本精灵
 */
class ScriptSprite extends Sprite {
	public static var point:Point = new Point();

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
		// label.verticalAlign = VerticalAlign.MIDDLE;
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

	public function draw(script:IScript):Void {
		this.script = script;
		script.customData = this;
		this.removeChildren();
		label.text = script.name == null ? Type.getClassName(Type.getClass(script)) : script.name;
		label.setTextFormat(new TextFormat(null, 14));
		label.y = (32 - label.textHeight) / 2;
		this.addChild(label);
		var itemHeight = 36;
		var itemWidth = label.textWidth + 20;
		var bottomHeight = 16;
		var offestX:Float = bottomHeight;
		var offestY:Float = itemHeight;
		this.graphics.clear();
		this.graphics.beginFill(0xffccee, 1);
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
