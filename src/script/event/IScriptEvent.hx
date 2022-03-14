package script.event;

/**
 * 接口事件
 */
interface IScriptEvent {
	/**
	 * 程序执行
	 */
	public function onStart():Void;

	/**
	 * 程序触发onUpdate时
	 */
	public function onUpdate():Void;

	/**
	 * 程序退出
	 * @param code 返回码
	 */
	public function onExit(code:Int):Void;
}
