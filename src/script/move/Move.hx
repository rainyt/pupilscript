package script.move;

import script.core.Script;

/**
 * 移动模块实现
 */
class Move extends Script {
	public var x:Float;

	public var y:Float;

	public function new(x:Float, y:Float) {
		super();
		this.x = x;
		this.y = y;
	}

	override function onUpdate() {
		super.onUpdate();
		this.display.x += x;
		this.display.y += y;
		exit();
	}
}
