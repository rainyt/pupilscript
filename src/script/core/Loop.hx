package script.core;

/**
 * 循环结构实现
 */
class Loop extends Script {
	private var _loop:Int = -1;

	/**
	 * 当前剩余循环
	 */
	public var loop(get, set):Int;

	private function get_loop():Int {
		return _loop;
	}

	private function set_loop(i:Int):Int {
		_loop = i;
		return _loop;
	}

	/**
	 * 构造一个循环结构
	 * @param loop 循环次数，默认-1为一直循环
	 */
	public function new(loop:Int = -1) {
		super();
		_loop = loop;
		this.name = "循环执行";
		this.supportChildScript = true;
	}

	override function onUpdate() {
		super.onUpdate();
		var code = Runtime.run(this);
		if (code == RuntimeCode.EXIT || code == RuntimeCode.BREAK) {
			this.exit();
		} else if (code == RuntimeCode.LOOP_EXIT) {
			if (_loop > 0)
				_loop--;
			if (_loop == 0)
				this.exit();
			else
				onUpdate();
		}
	}
}
