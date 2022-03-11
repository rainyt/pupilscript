package script.core;

/**
 * 通用的基础Script脚本基础实现
 */
class Script implements IScript {
	public function new() {
		scripts = [];
	}

	/**
	 * 当前脚本运行的状态码
	 */
	public var state:RuntimeCode = RuntimeCode.RUNING;

	public var scriptIndex:Int = -1;

	public var scripts:Array<IScript>;

	public var display:Any;

	public function onUpdate() {}

	public function reset(display:Any) {
		this.state = RuntimeCode.RUNING;
		this.display = display;
	}

	public function exit(code:RuntimeCode = RuntimeCode.RUNING):Void {
		state = code;
	}

	public function addScript(display:Any, script:IScript):IScript {
		if (scripts.indexOf(script) == -1) {
			script.display = display;
			scripts.push(script);
		}
		return this;
	}

	public function removeScript(script:IScript) {
		script.display = null;
		scripts.remove(script);
	}
}
