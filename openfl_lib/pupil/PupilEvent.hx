package pupil;

import openfl.events.EventDispatcher;
import script.event.IScriptEvent;
import openfl.events.Event;

/**
 * Pupil运行事件
 */
class PupilEvent extends EventDispatcher implements IScriptEvent {
	public static inline var START:String = "start";
	public static inline var UPDATE:String = "update";
	public static inline var EXIT:String = "exit";

	private static var startEvent:Event = new Event(START);
	private static var updateEvent:Event = new Event(UPDATE);
	private static var exitEvent:Event = new Event(EXIT);

	public var state:Int = 0;

	public function new() {
		super();
	}

	public function onStart() {
		this.dispatchEvent(startEvent);
	}

	public function onUpdate() {
		this.dispatchEvent(updateEvent);
	}

	public function onExit(code:Int) {
		state = code;
		this.dispatchEvent(exitEvent);
	}
}
