import script.core.Script;

class Test {
	static function main() {
		// 新建一个儿童编程模块
		var pupil = new Pupil();
		var obj = {
			x: 0,
			y: 0
		};
        // 添加命令执行循序
		pupil.addScript(obj, new CustomScript(10, 10));
		pupil.addScript(obj, new CustomScript(20, 20));
		pupil.addScript(obj, new CustomScript(-20, 10));
        // 开始
		pupil.start();
		trace(pupil);
		trace("运行结果：", obj);
	}
}

/**
 * 自定义命令
 */
class CustomScript extends Script {
	private var _x:Float;

	private var _y:Float;

	public function new(x:Float, y:Float) {
		super();
		_x = x;
		_y = y;
	}

	override function onUpdate() {
		super.onUpdate();
		var data:Dynamic = this.display;
		data.x += _x;
		data.y += _y;
		exit();
	}
}
