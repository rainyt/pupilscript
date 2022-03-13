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
	 * 是否需要上下文
	 */
	public var needDisplay:Bool = true;

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
	public function exit(code:RuntimeCode = RuntimeCode.EXIT):Void {
		this.scriptIndex = -1;
		state = code;
	}

	/**
	 * 添加脚本
	 * @param display 影响对象
	 * @param script 脚本
	 * @return IScript
	 */
	public function addScript(script:IScript, display:Any = null):IScript {
		addScriptAt(script, scripts.length, display);
		return this;
	}

	/**
	 * 根据索引添加脚本
	 * @param display 
	 * @param script 
	 * @param index 
	 * @return IScript
	 */
	public function addScriptAt(script:IScript, index:Int, display:Any = null):IScript {
		if (script.parent != null)
			script.parent.removeScript(script);
		script.parent = this;
		if (scripts.indexOf(script) == -1) {
			script.display = display;
			scripts.insert(index, script);
		}
		return this;
	}

	/**
	 * 删除脚本
	 * @param script 
	 */
	public function removeScript(script:IScript, clean:Bool = true):Void {
		if (clean)
			script.display = null;
		script.parent = null;
		scripts.remove(script);
	}

	public var name:String;

	public var desc:Array<Desc>;

	/**
	 * 是否支持子脚本
	 */
	public var supportChildScript:Bool = false;

	/**
	 * 父节点，如果是root节点，父亲是它自已
	 */
	public var parent:IScript;

	public var customData:Any;

	/**
	 * 命令模块颜色分类
	 */
	public var color:Color = NONE;

	/**
	 * 是否支持运行子脚本
	 */
	public var supportRunChildScript:Bool = true;

	/**
	 * 转换为ScriptData数据，用于文本储存，以便后续需要还原时读取
	 * @return String
	 */
	public function toScriptData():ScriptData {
		var data:ScriptData = {
			className: Type.getClassName(Type.getClass(this)),
			params: [],
			scripts: []
		};
		if (desc != null) {
			for (d in desc) {
				switch (d) {
					case INPUT(key, width):
						data.params.push(Reflect.getProperty(this, key));
					default:
				}
			}
		}
		for (s in scripts) {
			data.scripts.push(s.toScriptData());
		}
		return data;
	}
}
