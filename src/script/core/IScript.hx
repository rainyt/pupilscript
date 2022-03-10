package script.core;

/**
 * 脚本接口实现
 */
interface IScript {
	/**
	 * 运行脚本逻辑列表
	 */
	public var scripts:Array<IScript>;

	/**
	 * 当脚本开始执行时
	 */
	public function onStart():Void;

	/**
	 * 当脚本开始后，在没有执行onEnd时，会不停执行onFrame方法
	 */
	public function onFrame():Void;

	/**
	 * 当脚本执行结束时
	 */
	public function onEnd():Void;
}
