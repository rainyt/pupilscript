package script.core;

/**
 * 循环结构实现
 */
class Loop extends Script {
	private var _loop:Int = -1;

	/**
	 * 构造一个循环结构
	 * @param loop 循环次数，默认-1为一直循环
	 */
	public function new(loop:Int = -1) {
		super();
		_loop = loop;
	}

	override function onUpdate() {
		super.onUpdate();
		var code = Runtime.run(this);
		if (code == RuntimeCode.EXIT || code == RuntimeCode.BREAK) {
			this.exit();
		} else if (code == RuntimeCode.LOOP_EXIT) {
			this.scriptIndex = -1;
			if (_loop > 0)
				_loop--;
			if (_loop == 0)
				this.exit();
			else
				onUpdate();
		}
	}
}
