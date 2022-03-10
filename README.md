## 概述
这是一个可扩展、易用的儿童编程。（在开发中），可用于常用的剧情编辑逻辑实现等。

## 自定义命令
通过继承Script实现自定义的命令块，然后添加命令进行执行。

## 使用
```haxe
var runtime = new Pupil();
// 添加命令
var obj = {x:0,y:0};
runtime.addScript(obj,new CustomScript(10,10));
runtime.start();
```