package script;

import openfl.display.Sprite;

/**
 * 辅助线
 */
class ScriptLine extends Sprite {
	public function new() {
		super();
		this.graphics.beginFill(0xffffff);
		this.graphics.drawRect(0, 0, 300, 3);
	}
}
