package editer;

import feathers.layout.VerticalLayout;
import feathers.controls.VScrollBar;
import openfl.events.MouseEvent;
import openfl.events.FocusEvent;
import feathers.skins.RectangleSkin;
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
			target.mouseChildren = false;
			target.draw(iscript);
		});
		this.layout = new VerticalLayout();
		this.backgroundSkin = new RectangleSkin(SolidColor(0x1e1e1e));
		this.addEventListener(FocusEvent.FOCUS_OUT, function(e) {
			this.visible = false;
		});
		this.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
			if (e.target is ScriptSprite) {
				this.visible = false;
			}
		});
		this.scrollBarYFactory = () -> {
			return new VScrollBar();
		}
	}
}
