package script.core;

import script.display.DisplayObject;

/**
 * 脚本接口实现
 */
interface IScript {
	/**
	 * 运行状态，-1为正常运行，0为正常结束，其他为错误
	 */
	public var state:Int;

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
	public function bindDisplay(display:Any):Void;

	/**
	 * 当脚本开始时，将会不停更新这个接口
	 */
	public function onUpdate():Void;

	/**
	 * 结束当前脚本的运行
	 * @param code 0为正常
	 */
	public function exit(code:Int = 0):Void;

	/**
	 * 添加执行脚本
	 * @param script 
	 */
	public function addScript(display:Any, script:IScript):Void;

	/**
	 * 删除执行脚本
	 * @param script 
	 */
	public function removeScript(script:IScript):Void;
}