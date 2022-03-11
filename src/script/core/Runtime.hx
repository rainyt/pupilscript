package script.core;

class Runtime {
	/**
	 * 运行脚本
	 * @param script 
	 * @return Int 退出码
	 */
	public static function run(script:IScript):Int {
		// 开始循序执行script
		if (script.scriptIndex < script.scripts.length) {
			var runScript = script.scripts[script.scriptIndex];
			runScript.onUpdate();
			// 如果循序执行成功，则进入下一个
			if (runScript.state == 0) {
				script.scriptIndex++;
				var runScript = script.scripts[script.scriptIndex];
				if (runScript != null)
					runScript.bindDisplay(runScript.display);
				if (run(script) == RuntimeCode.EXIT)
					return RuntimeCode.EXIT;
			} else {
				return runScript.state;
			}
			return RuntimeCode.RUNING;
		}
		return RuntimeCode.LOOP_EXIT;
	};
}
