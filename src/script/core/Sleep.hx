package script.core;

/**
 * 延迟指令
 */
class Sleep extends Script {
	public var time:Float = 0;

	private var _time:Float = 0;

	public function new(time:Float = 0) {
		super();
		this.time = time;
		this.desc = [TEXT("延迟"), INPUT("time", 50, NUMBER), TEXT("秒")];
		this.needDisplay = false;
		this.color = CONTROL_BLUE;
	}

	override function reset(display:Any) {
		super.reset(display);
		_time = time;
	}

	override function onUpdate() {
		super.onUpdate();
		_time -= 1 / 60;
		trace("sleep", _time);
		if (_time <= 0) {
			exit();
		}
	}
}
