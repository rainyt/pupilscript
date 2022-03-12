package script.core;

/**
 * 一次性循环
 */
class OneLoop extends Loop {
	public function new() {
		super(1);
		this.name = "单次执行";
		this.desc = null;
		this.needDisplay = false;
	}

	override function reset(display:Any) {
		super.reset(display);
		this.loop = 1;
	}

	override function exit(code:RuntimeCode = RuntimeCode.EXIT) {
		super.exit(code);
		trace("oneloop exit");
	}
}
