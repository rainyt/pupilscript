package script.core;

class Trace extends Script {
	public var msg:String;

	public function new(msg:String) {
		super();
		this.msg = msg;
		this.name = "输出";
		this.color = TRACE_VIOLET;
		this.needDisplay = false;
		this.desc = [TEXT("输出"), INPUT("msg", 0)];
	}

	override function onUpdate() {
		super.onUpdate();
		trace("pupilscript:" + msg);
		this.exit();
	}
}
