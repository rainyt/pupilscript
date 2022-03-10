package script.core;

class Runtime {
	/**
	 * 运行脚本
	 * @param script 
	 */
	public static function run(script:IScript):Void {
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
				run(script);
			} else if (runScript.state > 0) {
				throw "Error state:" + runScript.state;
			}
		}
	};
}
