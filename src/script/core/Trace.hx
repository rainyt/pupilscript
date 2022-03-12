package script.core;

class Trace extends Script {
	private var _msg:String;

	public function new(msg:String) {
		super();
		_msg = msg;
		this.name = "输出";
		this.color = TRACE_VIOLET;
		this.needDisplay = false;
	}

	override function onUpdate() {
		super.onUpdate();
		trace("pupilscript:" + _msg);
		this.exit();
	}
}
