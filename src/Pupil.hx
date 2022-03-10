import zygame.utils.FrameEngine;
import script.core.Runtime;
import script.core.Script;
import script.core.IScript;

/**
 * 参考儿童编程，可以自定义组件，使组件按循序执行
 */
class Pupil extends Script {
	/**
	 * 开始执行
	 */
	public function start():Void {
		this.scriptIndex = 0;
		this.scripts[0].bindDisplay(this.scripts[0].display);
		#if zygame
		FrameEngine.create(function(f) {
			Runtime.run(this);
		});
		#else
		Runtime.run(this);
		#end
	}

	/**
	 * 停止
	 */
	public function stop():Void {}
}
