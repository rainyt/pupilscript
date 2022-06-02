package script.core;

enum abstract RuntimeCode(Int) to Int {
	var RUNING = -1;
	var EXIT = 0;
	var LOOP_EXIT = 1;
	var BREAK = 2;
	var STOP_EXIT = 3;
}
