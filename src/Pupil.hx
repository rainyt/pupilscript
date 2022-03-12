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
	public function new() {
		super();
		this.supportChildScript = true;
		this.color = EVENT_DARK_BLUE;
		this.desc = [
			TEXT("运行"),
			DEBUG("开始", () -> {
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
	 */
	public function start():Void {
		if (this.scripts.length == 0 || _start)
			return;
		this.resetScriptIndex(this);
		_start = true;
		#if zygame
		FrameEngine.create(function(f) {
			var code = Runtime.run(this);
			if (_stop || code == RuntimeCode.EXIT) {
				f.stop();
				_stop = false;
				_start = false;
			}
		});
		#else
		_delayCall();
		#end
	}

	public function resetScriptIndex(script:IScript):Void {
		script.scriptIndex = -1;
		for (s in script.scripts) {
			resetScriptIndex(s);
		}
	}

	private function _delayCall():Void {
		Timer.delay(function() {
			var exit = Runtime.run(this);
			if (!_stop && exit == RuntimeCode.RUNING) {
				_delayCall();
			} else {
				if (exit == RuntimeCode.LOOP_EXIT)
					exit = RuntimeCode.EXIT;
				onExit(exit);
				_stop = false;
				_start = false;
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
}
