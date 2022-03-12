package script.core;

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
	 * 父节点的脚本
	 */
	public var parent:IScript;

	/**
	 * 自定义数据
	 */
	public var customData:Any;
}
