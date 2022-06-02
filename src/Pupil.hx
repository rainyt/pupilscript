import script.core.IScript;
import script.core.RuntimeCode;
import haxe.Timer;
#if zygame
import zygame.utils.FrameEngine;
#end
import script.core.Runtime;
import script.core.Script;

/**
 * 参考儿童编程，可以自定义组件，使组件按循序执行
 */
class Pupil extends Script {
	/**
	 * 程序名称
	 */
	public var pupilName:String;

	/**
	 * 变量列表
	 */
	public var params:Map<String, Dynamic> = [];

	public function new(pupilName:String = "main") {
		super();
		this.pupilName = pupilName;
		this.supportChildScript = true;
		this.needDisplay = false;
		this.color = EVENT_DARK_BLUE;
		this.desc = [
			TEXT("程序名称"),
			INPUT("pupilName", 0, STRING),
			DEBUG("运行", () -> {
				if (isStart) {
					this.stop();
				} else {
					this.start();
				}
				trace("处理：", isStart);
			})
		];
	}

	/**
	 * 当程序退出时
	 * @param code 
	 */
	dynamic public function onExit(code:Int):Void {}

	/**
	 * 是否停止
	 */
	private var _stop:Bool = false;

	/**
	 * 是否已开始
	 */
	private var _start:Bool = false;

	/**
	 * 是否正在运行
	 */
	public var isStart(get, never):Bool;

	private function get_isStart():Bool {
		return _start;
	}

	/**
	 * 开始执行
	 * @param resume 是否恢复脚本，如果为true，则不会重置程序，会继续执行
	 */
	public function start(resume:Bool = false):Void {
		if (this.scripts.length == 0 || _start)
			return;
		if (!resume)
			Runtime.resetScripts(this);
		_start = true;
		_stop = false;
		#if zygame
		FrameEngine.create(function(f) {
			if (!_stop) {
				var code = Runtime.run(this);
				if (code == RuntimeCode.LOOP_EXIT)
					code = RuntimeCode.EXIT;
				if (code == RuntimeCode.EXIT) {
					f.stop();
					exitPupil(code);
				}
			} else {
				f.stop();
				exitPupil(RuntimeCode.EXIT);
			}
		});
		#else
		_delayCall();
		#end
	}

	private function exitPupil(code:RuntimeCode):Void {
		onExit(!_stop ? code : STOP_EXIT);
		if (!_stop)
			exit(code);
		_stop = false;
		_start = false;
	}

	private function _delayCall():Void {
		Timer.delay(function() {
			var exitcode = Runtime.run(this);
			if (!_stop && exitcode == RuntimeCode.RUNING) {
				_delayCall();
			} else {
				if (exitcode == RuntimeCode.LOOP_EXIT)
					exitcode = RuntimeCode.EXIT;
				exitPupil(exitcode);
			}
		}, 16);
	}

	/**
	 * 停止
	 */
	public function stop():Void {
		_stop = true;
		_start = false;
	}

	/**
	 * 生成出hscript脚本
	 * @return String
	 */
	public function toHScript():String {
		var hscript = "";
		return hscript;
	}

	/**
	 * 设置变量定义
	 * @param name 
	 * @param value 
	 */
	override function setParamValue(name:String, value:Dynamic) {
		trace("set param", name, value);
		params.set(name, value);
	}

	/**
	 * 获取变量定义
	 * @param name 
	 * @param defaultValue 
	 * @return Dynamic
	 */
	override function getParamValue(name:String, defaultValue:Dynamic = null):Dynamic {
		var value = params.get(name);
		return value == null ? defaultValue : value;
	}
}
