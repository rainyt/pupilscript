package pupil;

import openfl.display.DisplayObject;
import script.core.Script;

/**
 * 设置坐标
 */
class SetPoint extends Script {
	public var x:Float;

	public var y:Float;

	public function new(x:Float = 0, y:Float = 0) {
		super();
		this.x = x;
		this.y = y;
		this.desc = [
			TEXT("设置"),
			TEXT("X轴"),
			INPUT("x", 100, NUMBER),
			TEXT("Y轴"),
			INPUT("y", 100, NUMBER)
		];
		this.color = MOTION_RED;
		this.needDisplay = true;
	}

	override function onUpdate() {
		super.onUpdate();
		var obj:DisplayObject = this.display;
		if (obj == null) {
			exit();
			return;
		}
		obj.x = x;
		obj.y = y;
		exit();
	}
}
