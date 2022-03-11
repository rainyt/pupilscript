package script.core;

/**
 * 判断语句
 */
class If extends Script {
	/**
	 * 否则语句
	 */
	public var elseScript:IScript;

	private var _iffunc:Any->Bool;

	public function new(iffunc:Any->Bool) {
		super();
		_iffunc = iffunc;
		this.name = "判断";
	}

	override function onUpdate() {
		super.onUpdate();
		if (_iffunc(this.display)) {
			// 执行If自身的命令
			var code = Runtime.run(this);
			if (code == RuntimeCode.BREAK) {
				this.exit(RuntimeCode.BREAK);
			} else if (code == RuntimeCode.EXIT || code == RuntimeCode.LOOP_EXIT) {
				this.exit();
			}
		} else {
			trace("else", elseScript.scriptIndex);
			if (elseScript == null)
				this.exit();
			else {
				var code = Runtime.run(elseScript);
				if (code == RuntimeCode.BREAK) {
					this.exit(RuntimeCode.BREAK);
				} else if (code == RuntimeCode.EXIT || code == RuntimeCode.LOOP_EXIT) {
					this.exit();
				}
			}
		}
	}
}
