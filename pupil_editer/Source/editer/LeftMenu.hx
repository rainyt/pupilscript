package editer;

import feathers.skins.RectangleSkin;
import feathers.controls.LayoutGroup;

class LeftMenu extends LayoutGroup {
	public function new() {
		super();
		this.width = 60;
		this.backgroundSkin = new RectangleSkin(SolidColor(0x333333));
	}
}
