import script.core.Script;
import script.core.IScript;

/**
 * 用于管理多个PupilGoup的组合
 */
class PupilGroup extends Script {
	public function start():Void {
		for (script in scripts) {
			if (Std.isOfType(script, Pupil))
				cast(script, Pupil).start();
		}
	}

	public function stop():Void {
		for (script in scripts) {
			if (Std.isOfType(script, Pupil))
				cast(script, Pupil).stop();
		}
	}
}
