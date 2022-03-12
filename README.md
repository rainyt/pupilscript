## 概述
这是一个可扩展、易用的儿童编程。（在开发中），可用于常用的剧情编辑逻辑实现等。

## 自定义命令
通过继承Script实现自定义的命令块，然后添加命令进行执行。
```haxe
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
		trace("onUpdate");
		var data:Dynamic = this.display;
		data.x += _x;
		data.y += _y;
        // 当你认为这个脚本已经运行结束了，则运行exit()结束该脚本，如果不调用此方法，onUpdate会不停执行，直到exit()
		exit();
	}
}
```

## 使用
```haxe
var runtime = new Pupil();
// 添加命令
var obj = {x:0,y:0};
runtime.addScript(new CustomScript(10,10),obj);
runtime.start();
```

## 循环 loop
使用`Loop`进行循环运算：
```haxe
var loop = new Loop();
runtime.addScript(loop);
loop.addScript(new CustomScript(10,10),obj);
```
如果需要指定次数，可以：
```haxe
// 执行5次
var loop = new Loop(5);
```

## 中断 break
可以在循环结构体中使用，进行中断运行：
```haxe
loop.addScript(new Break());
```

## 判断 if
可以自定义判断条件，进行逻辑判断，当逻辑符合时，就会执行`If`中的程序。
```haxe
// 循环里新增一个判断，判断里放了一个break
loop.addScript(new If((display)->true).addScript(obj, new Break()),obj);
```

## 否则 else
可以在`If`条件中设置`elseScript`，如：
```haxe
var script = new OneLoop();
script.addScript(new Trace("else"),obj);
ifscript.elseScript = script;
```
如果是elseif，那么可以直接传递`If`对象：
```haxe
var script = new If((display)->true);
script.addScript(new Trace("else"),obj);
ifscript.elseScript = script;
```