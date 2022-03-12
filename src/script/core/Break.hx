package script.core;

/**
 * 中断语句
 */
class Break extends Script {
	public function new() {
		super();
		this.name = "中断";
		this.color = CONTROL_BLUE;
	}

	override function onUpdate() {
		super.onUpdate();
		this.exit(RuntimeCode.BREAK);
	}
}
