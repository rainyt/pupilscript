package script.core;

/**
 * 描述定义
 */
enum Desc {
	TEXT(text:String);
	INPUT(key:String, width:Int);
	DEBUG(text:String, cb:Void->Void);
}
