package script.core;

/**
 * 方法调用实现
 */
class Call extends Script {
	private var _call:Void->Void;

	public function new(call:Void->Void) {
		super();
		_call = call;
	}

	override function onUpdate() {
		super.onUpdate();
		if (_call != null)
			_call();
		exit();
	}
}
