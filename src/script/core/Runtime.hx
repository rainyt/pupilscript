package script.core;

class Runtime {
	/**
	 * 运行脚本
	 * @param script 
	 * @return Int 退出码
	 */
	public static function run(script:IScript, resetScript:Bool = true):RuntimeCode {
		// 开始循序执行script
		if (resetScript) {
			if (script.scriptIndex >= script.scripts.length) {
				script.scriptIndex = -1;
			}
		}
		if (script.scriptIndex == -1) {
			script.scriptIndex = 0;
			script.scripts[0].reset(script.scripts[0].display);
		}
		if (script.scriptIndex < script.scripts.length) {
			var runScript = script.scripts[script.scriptIndex];
			runScript.onUpdate();
			// 如果循序执行成功，则进入下一个
			if (runScript.state == RuntimeCode.EXIT) {
				script.scriptIndex++;
				var runScript = script.scripts[script.scriptIndex];
				if (runScript != null) {
					runScript.reset(runScript.display);
				}
				return run(script, false);
			} else {
				return runScript.state;
			}
		}
		return RuntimeCode.LOOP_EXIT;
	};
}
