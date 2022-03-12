package script.core;

enum abstract Color(UInt) {
	// 未分类
	var NONE = 0xf5be67;
	// 深蓝色，事件分类
	var EVENT_DARK_BLUE = 0x6a8ee7;
	// 蓝色，控制分类
	var CONTROL_BLUE = 0x82cbfa;
	// 红色，动画分类
	var MOTION_RED = 0xec706c;
	// 绿色，设置分类
	var SET_GREED = 0x63c6a9;
	// 紫色，输出分类
	var TRACE_VIOLET = 0x9975f7;
}
