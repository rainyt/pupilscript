package pupil;

import openfl.display.DisplayObject;
import script.core.Script;

/**
 * 移动命令
 */
class Move extends Script {
	public var time:Float = 0;

	public var x:Float = 0;

	public var y:Float = 0;

	private var _rootX:Float = 0;

	private var _rootY:Float = 0;

	private var _curTime:Float = 0;

	/**
	 * 移动命令
	 * @param time 
	 * @param x 
	 * @param y 
	 */
	public function new(time:Float, x:Float, y:Float) {
		super();
		this.name = "移动";
		this.desc = [
			{
				type: "input",
				name: "time"
			},
			"秒内移动",
			"X轴",
			{
				type: "input",
				name: "x"
			},
			"Y轴",
			{
				type: "input",
				name: "y"
			}
		];
		this.time = time;
		this.x = x;
		this.y = y;
		this.color = MOTION_RED;
	}

	override function reset(display:Any) {
		super.reset(display);
		var obj:DisplayObject = display;
		_rootX = obj.x;
		_rootY = obj.y;
		_curTime = 0;
	}

	override function onUpdate() {
		super.onUpdate();
		_curTime += 1 / 60;
		if (_curTime > this.time)
			_curTime = this.time;
		var obj:DisplayObject = display;
		obj.x = _rootX + this.x * _curTime / this.time;
		obj.y = _rootY + this.y * _curTime / this.time;
		if (_curTime == this.time) {
			exit();
		}
	}
}
