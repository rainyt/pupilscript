package script.core;

/**
 * 描述定义
 */
enum Desc {
	TEXT(text:String);
	INPUT(key:String, width:Int, type:ParamClass);
	DEBUG(text:String, cb:Void->Void);
	BOOL(key:String, text:String);
}

/**
 * 参数类型
 */
enum ParamClass {
	// 数值
	NUMBER;
	// 字符串
	STRING;
	// 自动识别
	AUTO;
}
