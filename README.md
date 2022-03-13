## 概述
这是一个可扩展、易用的儿童编程。（在开发中），可用于常用的剧情编辑逻辑实现等。

## 可视化少儿编程
![avatar](/desc.png)

## 自定义命令
通过继承Script实现自定义的命令块，然后添加命令进行执行。
```haxe
/**
 * 自定义命令
 */
class CustomScript extends Script {
	public var x:Float;

	public var y:Float;

	public function new(x:Float = 0, y:Float = 0) {
		super();
		this.x = x;
		this.y = y;
		// 提供给编辑器读取的名字
		this.name = "自定义脚本";
		// 如果需要提供修改解释
		this.desc = [TEXT("递增"),TEXT("X轴"),INPUT("x",50),TEXT("Y轴"),INPUT("y",50)];
	}

	override function onUpdate() {
		super.onUpdate();
		trace("onUpdate");
		var data:Dynamic = this.display;
		data.x += this.x;
		data.y += this.y;
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

## 延迟
如果希望代码延迟执行时，请在前面添加：
```haxe
// 延迟两秒
var script = new Sleep(2);
runtime.addScript(script);
```

## 高级使用
库中自带有一个编辑器功能，可以提供给OpenFL项目直接使用，如果需要给自已的游戏添加一个编辑器功能，那么这个就很有用。
```haxe
// 构造儿童编程模块
var pupilEditer = new PupilscriptMain();
this.addChild(pupilEditer);
pupilEditer.backgroundSkin = null;
// 屏幕适配
pupilEditer.scaleManager = new CustomScaleManager(2, new Rectangle(0, 0, getStageWidth(), getStageHeight()));
// 新增自定义脚本
// 角色交互
PupilscriptMain.leftMenu.addScript(new RoleInteractive());
// 角色移动
PupilscriptMain.leftMenu.addScript(new RoleMove());
// 角色说话
PupilscriptMain.leftMenu.addScript(new RoleDialog());
// 角色定位
PupilscriptMain.leftMenu.addScript(new RolePoint());
// 新增控制角色
PupilscriptMain.scriptStage.array.add(this.role);
```

## 脚本导出
可以通过`toScriptData`的方式导出Json格式的数据：
```haxe
Json.stringify(script.toScriptData());
```

## 脚本还原
当有了文本数据后，就可以通过对应的API进行还原，例如：
```haxe
Script.fromText(Json.stringify(script.toScriptData()),function(data:ScriptData):Any{
	// 通过data数据解析应该正确绑定的显示对象
	return null;
});
```