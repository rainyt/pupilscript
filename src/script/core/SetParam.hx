package script.core;

class SetParam extends Script {
	/**
	 * 参数名
	 */
	public var paramName:String;

	/**
	 * 设置变量名
	 */
	public var value:Dynamic;

	public function new(paramName:String = "变量名", value:Dynamic = null) {
		super();
		this.needDisplay = false;
		this.desc = [
			TEXT("设置变量"),
			INPUT("paramName", 100, STRING),
			TEXT("值为"),
			INPUT("value", 0, AUTO)
		];
		this.color = SET_GREED;
	}

	override function onUpdate() {
		super.onUpdate();
		this.setParamValue(paramName, value);
		this.exit();
	}
}
