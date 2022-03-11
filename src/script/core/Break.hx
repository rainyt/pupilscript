package script.core;

/**
 * 中断语句
 */
class Break extends Script {
	override function onUpdate() {
		super.onUpdate();
		this.exit(RuntimeCode.BREAK);
	}
}
