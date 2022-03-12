package editer;

import openfl.events.FocusEvent;
import feathers.skins.RectangleSkin;
import feathers.controls.LayoutGroup;
import feathers.data.ListViewItemState;
import script.core.IScript;
import feathers.data.ArrayCollection;
import script.ScriptSprite;
import feathers.utils.DisplayObjectRecycler;
import feathers.controls.ListView;

class ActionListView extends ListView {
	public function new(data:ArrayCollection<IScript>) {
		super(data);
		this.itemRendererRecycler = DisplayObjectRecycler.withFunction(function() {
			return new ScriptSprite(SELECT);
		}, function(target, state:ListViewItemState) {
			var iscript:IScript = cast state.data;
			target.draw(iscript);
		});
		this.backgroundSkin = new RectangleSkin(SolidColor(0x1e1e1e));
		this.addEventListener(FocusEvent.FOCUS_OUT, function(e) {
			this.visible = false;
		});
	}
}
