package script.core;

import script.event.IScriptEvent;

/**
 * 脚本接口实现
 */
interface IScript {
	/**
	 * 运行状态，-1为正常运行，0为正常结束，其他为错误
	 */
	public var state:RuntimeCode;

	/**
	 * 运行脚本逻辑列表
	 */
	public var scripts:Array<IScript>;

	/**
	 * 控制对象
	 */
	public var display:Any;

	/**
	 * 脚本运行索引
	 */
	public var scriptIndex:Int;

	/**
	 * 绑定控制对象
	 * @param display 
	 */
	public function reset(display:Any):Void;

	/**
	 * 当脚本开始时，将会不停更新这个接口
	 */
	public function onUpdate():Void;

	/**
	 * 结束当前脚本的运行
	 * @param code 0为正常
	 */
	public function exit(code:RuntimeCode = RuntimeCode.RUNING):Void;

	/**
	 * 添加执行脚本
	 * @param script 
	 */
	public function addScript(script:IScript, display:Any = null):IScript;

	/**
	 * 添加执行脚本
	 * @param display
	 * @param script 
	 * @param index
	 */
	public function addScriptAt(script:IScript, index:Int, display:Any = null):IScript;

	/**
	 * 删除执行脚本
	 * @param script 
	 */
	public function removeScript(script:IScript, clean:Bool = true):Void;

	/**
	 * 脚本名称
	 */
	public var name:String;

	/**
	 * 脚本描述
	 */
	public var desc:Array<Desc>;

	/**
	 * 该命令的颜色
	 */
	public var color:Color;

	/**
	 * 是否支持子脚本
	 */
	public var supportChildScript:Bool;

	/**
	 * 是否支持运行子脚本
	 */
	public var supportRunChildScript:Bool;

	/**
	 * 是否需要上下文
	 */
	public var needDisplay:Bool;

	/**
	 * 父节点的脚本
	 */
	public var parent:IScript;

	/**
	 * 自定义数据
	 */
	public var customData:Any;

	/**
	 * 转换为ScriptData数据，用于文本储存，以便后续需要还原时读取
	 * @return String
	 */
	public function toScriptData():ScriptData;

	/**
	 * 侦听事件
	 * @param listener 
	 */
	public function addListener(listener:IScriptEvent):Void;

	/**
	 * 移除事件
	 * @param listener 
	 */
	public function removeListener(listener:IScriptEvent):Void;

	/**
	 * 定义变量值
	 * @param name 
	 * @param value 
	 */
	public function setParamValue(name:String, value:Dynamic):Void;

	/**
	 * 获取定义变量值
	 * @param name 
	 * @param defualt 
	 * @return Dynamic
	 */
	public function getParamValue(name:String, defaultValue:Dynamic = null):Dynamic;
}
