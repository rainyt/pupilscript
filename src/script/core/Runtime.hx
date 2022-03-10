package script.core;

class Runtime {
	/**
	 * 运行脚本
	 * @param script 
	 */
	public static function run(script:IScript):Void {
		if (script.scriptIndex < script.scripts.length) {
			var runScript = script.scripts[script.scriptIndex];
			runScript.onUpdate();
			if (runScript.state == 0) {
				script.scriptIndex++;
				var runScript = script.scripts[script.scriptIndex];
				if (runScript != null)
					runScript.bindDisplay(runScript.display);
				run(script);
			}
		}
	};
}
