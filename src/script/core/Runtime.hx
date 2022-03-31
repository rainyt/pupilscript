package script.core;

class Runtime {
	/**
	 * 重置脚本
	 * @param script 
	 */
	public static function resetScripts(script:IScript):Void {
		script.scriptIndex = -1;
		script.state = RUNING;
		for (script in script.scripts) {
			resetScripts(script);
		}
	}

	/**
	 * 运行脚本
	 * @param script 
	 * @return Int 退出码
	 */
	public static function run(script:IScript):RuntimeCode {
		if (script.scriptIndex == -1) {
			script.scriptIndex = 0;
			if (script.scripts[0] != null)
				script.scripts[0].reset(script.scripts[0].display);
		}
		if (script.supportRunChildScript && script.scriptIndex < script.scripts.length) {
			var runScript = script.scripts[script.scriptIndex];
			runScript.onUpdate();
			// 如果循序执行成功，则进入下一个
			if (runScript.state == RuntimeCode.EXIT) {
				script.scriptIndex++;
				var runScript = script.scripts[script.scriptIndex];
				if (runScript != null) {
					runScript.reset(runScript.display);
				}
				return run(script);
			} else {
				return runScript.state;
			}
		}
		return RuntimeCode.LOOP_EXIT;
	};
}
