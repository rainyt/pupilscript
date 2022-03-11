package script.core;

/**
 * 通用的基础Script脚本基础实现
 */
class Script implements IScript {
	/**
	 * 构造一个脚本，一般来说，需要对Scirpt继续继承，然后自定义脚本实现
	 */
	public function new() {
		scripts = [];
	}

	/**
	 * 当前脚本运行的状态码
	 */
	public var state:RuntimeCode = RuntimeCode.RUNING;

	/**
	 * 脚本运行索引
	 */
	public var scriptIndex:Int = -1;

	/**
	 * 当前脚本包含的子脚本索引，仅循环结构体支持
	 */
	public var scripts:Array<IScript>;

	/**
	 * 脚本影响的对象
	 */
	public var display:Any;

	/**
	 * 脚本逻辑实现方法，每帧都会调用
	 */
	public function onUpdate() {}

	/**
	 * 当脚本重新开始执行时的重置方法
	 * @param display 
	 */
	public function reset(display:Any) {
		this.state = RuntimeCode.RUNING;
		this.display = display;
	}

	/**
	 * 当脚本运行结束后，请求退出
	 * @param code 
	 */
	public function exit(code:RuntimeCode = RuntimeCode.RUNING):Void {
		state = code;
	}

	/**
	 * 添加脚本
	 * @param display 影响对象
	 * @param script 脚本
	 * @return IScript
	 */
	public function addScript(display:Any, script:IScript):IScript {
		if (scripts.indexOf(script) == -1) {
			script.display = display;
			scripts.push(script);
		}
		return this;
	}

	/**
	 * 删除脚本
	 * @param script 
	 */
	public function removeScript(script:IScript) {
		script.display = null;
		scripts.remove(script);
	}
}
