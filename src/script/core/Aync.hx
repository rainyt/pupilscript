package script.core;

/**
 * 同步运行循环，在这里的所有命令都是同时执行
 */
class Aync extends Script {
	public var loop:Int = -1;

	public function new(loop:Int = -1) {
		super();
		this.loop = loop;
		this.name = "同步执行";
		this.supportChildScript = true;
		this.supportRunChildScript = false;
		this.color = CONTROL_BLUE;
	}

	override function reset(display:Any) {
		super.reset(display);
		for (script in scripts) {
			script.scriptIndex = -1;
			script.state = RuntimeCode.RUNING;
			script.reset(script.display);
		}
	}

	override function onUpdate() {
		super.onUpdate();
		var isRuning = false;
		for (script in scripts) {
			if (script.state == RuntimeCode.RUNING) {
				isRuning = true;
				script.onUpdate();
			}
		}
		if (!isRuning) {
			this.exit();
		}
	}
}
