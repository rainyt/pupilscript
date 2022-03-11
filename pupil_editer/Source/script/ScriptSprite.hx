package script;

import script.core.IScript;
import feathers.layout.VerticalAlign;
import feathers.controls.Label;
import openfl.display.Sprite;

/**
 * 脚本精灵
 */
class ScriptSprite extends Sprite {
	public var label:Label;

	public var type:ScriptType;

	public function new(type:ScriptType) {
		super();

		this.type = type;

		label = new Label("开始");
		label.height = 36;
		label.x = 5;
		label.verticalAlign = VerticalAlign.MIDDLE;
	}

	public var scriptHeight:Float = 0;

	public function draw(script:IScript):Void {
		this.removeChildren();
		label.text = Type.getClassName(Type.getClass(script));
		var itemHeight = 36;
		var itemWidth = 200;
		var offestX:Float = 5;
		var offestY:Float = itemHeight;
		this.graphics.beginFill(0xffccee, 1);
		this.graphics.lineStyle(1, 0xffffff);
		this.graphics.drawRoundRectComplex(0, 0, itemWidth, itemHeight, 0, 18, 0, 18);
		scriptHeight = 36;
		for (s in script.scripts) {
			var newSprite = new ScriptSprite(NONE);
			this.addChild(newSprite);
			newSprite.draw(s);
			newSprite.x = offestX;
			newSprite.y = offestY;
			offestY += newSprite.scriptHeight;
			scriptHeight += newSprite.scriptHeight;
			trace(s, offestY, newSprite.scriptHeight);
		}
		if (script.scripts.length > 0) {
			this.graphics.drawRect(0, 36, 5, offestY - itemHeight);
			this.graphics.drawRoundRectComplex(0, offestY, itemWidth * 3 / 4, 6, 0, 3, 0, 3);
			scriptHeight += 6;
		}
		this.addChild(label);
	}
}

enum ScriptType {
	NONE;
	PLAY;
}
