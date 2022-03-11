package script.core;

class Runtime {
	/**
	 * 运行脚本
	 * @param script 
	 * @return Int 退出码
	 */
	public static function run(script:IScript):Int {
		// 开始循序执行script
		if (script.scriptIndex == -1) {
			script.scriptIndex = 0;
			script.scripts[0].bindDisplay(script.scripts[0].display);
		}
		if (script.scriptIndex < script.scripts.length) {
			var runScript = script.scripts[script.scriptIndex];
			runScript.onUpdate();
			// 如果循序执行成功，则进入下一个
			if (runScript.state == 0) {
				script.scriptIndex++;
				if (script.scriptIndex >= script.scripts.length)
					script.scriptIndex = -1;
				else {
					var runScript = script.scripts[script.scriptIndex];
					if (runScript != null) {
						runScript.bindDisplay(runScript.display);
					}
				}
				return run(script);
			} else {
				return runScript.state;
			}
		}
		script.scriptIndex = -1;
		return RuntimeCode.LOOP_EXIT;
	};
}
