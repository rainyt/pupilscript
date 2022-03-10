import script.move.Move;

class Test {
	static function main() {
		// 新建一个儿童编程模块
		var pupil = new Pupil();
		var obj = {
			x: 0,
			y: 0
		};
		pupil.addScript(obj, new Move(200, 200));
		pupil.addScript(obj, new Move(-100, 200));
		pupil.start();
		trace(pupil);
		trace("运行结果：", obj);
	}
}
