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
	 * 当程序退出时
	 * @param code 
	 */
	dynamic public function onExit(code:Int):Void {}

	/**
	 * 开始执行
	 */
	public function start():Void {
		if (this.scripts.length == 0)
			return;
		#if zygame
		FrameEngine.create(function(f) {
			var code = Runtime.run(this);
			if (code == RuntimeCode.EXIT)
				f.stop();
		});
		#else
		_delayCall();
		#end
	}

	private function _delayCall():Void {
		Timer.delay(function() {
			var exit = Runtime.run(this);
			if (exit == RuntimeCode.RUNING) {
				_delayCall();
			} else {
				if (exit == RuntimeCode.LOOP_EXIT)
					exit = RuntimeCode.EXIT;
				onExit(exit);
			}
		}, 16);
	}

	/**
	 * 停止
	 */
	public function stop():Void {}
}
