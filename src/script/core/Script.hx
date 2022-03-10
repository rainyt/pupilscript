package script.core;

import script.display.DisplayObject;

/**
 * 通用的基础Script脚本基础实现
 */
class Script implements IScript {
	public function new() {
		scripts = [];
	}

	public var state:Int = -1;

	public var scriptIndex:Int = 0;

	public var scripts:Array<IScript>;

	public var display:DisplayObject;

	public function onUpdate() {}

	public function exit(code:Int = 0):Void {
		state = code;
	}

	public function addScript(display:Any, script:IScript) {
		if (scripts.indexOf(script) == -1) {
			script.display = display;
			scripts.push(script);
		}
	}

	public function removeScript(script:IScript) {
		script.display = null;
		scripts.remove(script);
	}
}
