import script.utils.HaxeScript;
import haxe.Json;
import script.core.Break;
import script.core.Loop;
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
		pupil.addScript(new Loop().addScript(new CustomScript(1, 5), obj).addScript(new Break()));
		pupil.addScript(new CustomScript(10, 10), obj);
		pupil.addScript(new CustomScript(20, 20), obj);
		pupil.addScript(new CustomScript(-20, 10), obj);

		// 开始
		pupil.start();
		pupil.onExit = function(code) {
			trace("运行结果：", code, obj);
		}

		var sdata = Json.stringify(pupil.toScriptData());
		trace("储存数据：", sdata);

		var pupilBack = Script.fromText(sdata);
		trace("\n\n\n\n还原：", pupilBack);

		var haxedata = HaxeScript.convertToHaxe(pupil.toScriptData());
		trace("Haxe语法：", "\n" + haxedata + "\n\n\n");

		
	}
}

/**
 * 自定义命令
 */
class CustomScript extends Script {
	public var x:Float;

	public var y:Float;

	public function new(x:Float, y:Float) {
		super();
		this.x = x;
		this.y = y;
		this.desc = [TEXT("X"), INPUT("x", 50), TEXT("Y"), INPUT("y", 50)];
	}

	override function onUpdate() {
		super.onUpdate();
		trace("onUpdate");
		var data:Dynamic = this.display;
		data.x += x;
		data.y += y;
		exit();
	}
}
