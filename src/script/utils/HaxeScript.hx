package script.utils;

import script.core.ScriptData;

/**
 * Haxe语言生成工具
 */
class HaxeScript {
	/**
	 * 将ScriptData数据编译成Haxe语言
	 * @param data ScriptData对象
	 * @param varParams 自定义导出格式
	 * @return String
	 */
	public static function convertToHaxe(data:ScriptData, varParams:VarParams = null, parent:String = null):String {
		if (varParams == null)
			varParams = {
				uid: 0,
				name: "script"
			};
		var haxe:Array<String> = [];
		varParams.uid++;
		var currentParent = "";
		if (varParams.uid == 1) {
			haxe.push('var pupil = new Pupil();');
			currentParent = "pupil";
		} else {
			var args:Array<String> = [];
			for (index => value in data.params) {
				if (Std.isOfType(value, String)) {
					args.push('"${value}"');
				} else {
					args.push(value);
				}
			}
			haxe.push('var ${varParams.name}${varParams.uid} = new ${data.className}(${data.params.join(",")});');
			currentParent = '${varParams.name}${varParams.uid}';
		}
		if (parent != null) {
			haxe.push('${parent}.addScript(${varParams.name}${varParams.uid});');
		}
		for (s in data.scripts) {
			haxe.push(convertToHaxe(s, varParams, currentParent));
		}
		return haxe.join("\n");
	}
}

typedef VarParams = {
	uid:Int,
	?name:String
}
