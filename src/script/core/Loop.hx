package script.core;

/**
 * 循环结构实现
 */
class Loop extends Script {
	override function onUpdate() {
		super.onUpdate();
		var code = Runtime.run(this);
		if (code == RuntimeCode.EXIT || code == RuntimeCode.BREAK) {
			this.exit();
		} else if (code == RuntimeCode.LOOP_EXIT) {
			onUpdate();
		}
	}
}
