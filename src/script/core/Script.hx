package script.core;

import script.event.IScriptEvent;
import haxe.Json;

/**
 * 通用的基础Script脚本基础实现
 */
class Script implements IScript {
	/**
	 * 参数绑定
	 */
	public var paramsBind:Map<String, String> = [];

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
	public function onUpdate() {
		for (event in _listeners) {
			event.onUpdate();
		}
	}

	/**
	 * 当脚本重新开始执行时的重置方法
	 * @param display 
	 */
	public function reset(display:Any) {
		// 参数绑定变更实现
		if (this.desc != null)
			for (d in this.desc) {
				switch (d) {
					case INPUT(key, width, type):
						if (paramsBind.exists(key)) {
							var newkey = paramsBind.get(key);
							var newvalue = this.getParamValue(newkey);
							trace("同步修改值变量", key, newvalue, newkey);
							if (type == STRING) {
								// 字符串
								Reflect.setProperty(this, key, Std.string(newvalue));
							} else {
								// 数值
								Reflect.setProperty(this, key, Std.parseFloat(newvalue));
							}
						}
					case BOOL(key, text):
						if (paramsBind.exists(key)) {
							var newkey = paramsBind.get(key);
							var newvalue = this.getParamValue(newkey);
							if (newvalue != null) {
								Reflect.setProperty(this, key, newvalue == "true");
							}
						}
					default:
				}
			}
		this.state = RuntimeCode.RUNING;
		this.display = display;
		for (event in _listeners) {
			event.onStart();
		}
	}

	/**
	 * 当脚本运行结束后，请求退出
	 * @param code 
	 */
	public function exit(code:RuntimeCode = RuntimeCode.EXIT):Void {
		this.scriptIndex = -1;
		state = code;
		trace("exit?");
		for (event in _listeners) {
			event.onExit(state);
		}
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
		var bindValue = {};
		for (key => value in paramsBind) {
			Reflect.setProperty(bindValue, key, value);
		}
		var data:ScriptData = {
			display: this.display != null ? Reflect.getProperty(this.display, "name") : null,
			className: Type.getClassName(Type.getClass(this)),
			params: [],
			scripts: [],
			binds: bindValue
		};
		if (desc != null) {
			for (d in desc) {
				switch (d) {
					case INPUT(key, width, type):
						data.params.push(Reflect.getProperty(this, key));
					case BOOL(key, text):
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

	/**
	 * 恢复ScriptData数据为IScript
	 * @param data 
	 * @param onDisplayBind 
	 * @return IScript
	 */
	public static function recovery(data:ScriptData, onDisplayBind:ScriptData->Any):IScript {
		var script:Script = Type.createInstance(Type.resolveClass(data.className), data.params);
		// 恢复binds
		if (data.binds != null) {
			var keys = Reflect.fields(data.binds);
			for (key in keys) {
				script.paramsBind.set(key, Reflect.getProperty(data.binds, key));
			}
		}
		if (onDisplayBind != null) {
			script.display = onDisplayBind(data);
		}
		for (s in data.scripts) {
			script.scripts.push(recovery(s, onDisplayBind));
		}
		return script;
	}

	/**
	 * 从字符串还原
	 * @param text 
	 * @return IScript
	 */
	public static function fromText(text:String, onDisplayBind:ScriptData->Any = null):IScript {
		return fromJson(Json.parse(text), onDisplayBind);
	}

	/**
	 * 从Json还原
	 * @param json 
	 */
	public static function fromJson(json:Dynamic, onDisplayBind:ScriptData->Any = null):IScript {
		return fromScriptData(json, onDisplayBind);
	}

	/**
	 * 从ScritpData数据还原
	 * @param data 
	 * @return IScript
	 */
	public static function fromScriptData(data:ScriptData, onDisplayBind:ScriptData->Any = null):IScript {
		return recovery(data, onDisplayBind);
	}

	/**
	 * 事件列表
	 */
	private var _listeners:Array<IScriptEvent> = [];

	/**
	 * 侦听事件
	 * @param listener 
	 */
	public function addListener(listener:IScriptEvent) {
		if (_listeners.indexOf(listener) != -1)
			_listeners.push(listener);
	}

	/**
	 * 移除事件
	 * @param listener 
	 */
	public function removeListener(listener:IScriptEvent) {
		_listeners.remove(listener);
	}

	/**
	 * 定义变量值
	 * @param name 
	 * @param value 
	 */
	public function setParamValue(name:String, value:Dynamic):Void {
		if (parent == null)
			return;
		if (Std.isOfType(this, Pupil)) {
			cast(this, Pupil).setParamValue(name, value);
		}
		parent.setParamValue(name, value);
	}

	/**
	 * 获取定义变量值
	 * @param name 
	 * @param defualt 
	 * @return Dynamic
	 */
	public function getParamValue(name:String, defaultValue:Dynamic = null):Dynamic {
		if (parent == null)
			return defaultValue;
		if (Std.isOfType(this, Pupil)) {
			return cast(this, Pupil).getParamValue(name, defaultValue);
		}
		return parent.getParamValue(name, defaultValue);
	}
}
