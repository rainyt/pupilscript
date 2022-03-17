package editer;

import script.core.ScriptData;
import feathers.layout.AnchorLayoutData;
import openfl.events.MouseEvent;
import feathers.data.ArrayCollection;
import script.core.IScript;
import feathers.layout.VerticalListLayout;
import feathers.controls.Button;
import feathers.skins.RectangleSkin;
import feathers.controls.LayoutGroup;

/**
 * 动作库
 */
class ActionMenu extends LayoutGroup {
	/**
	 * 注册列表
	 */
	public var scripts:ArrayCollection<IScript> = new ArrayCollection();

	public var listView:ActionListView;

	public function new() {
		super();
		this.width = 60;
		this.layout = new VerticalListLayout();
		this.backgroundSkin = new RectangleSkin(SolidColor(0x333333));
		var button:Button = new Button("添加");
		this.addChild(button);
		button.addEventListener(MouseEvent.CLICK, function(e) {
			if (listView == null)
				listView = new ActionListView(scripts);
			this.parent.addChild(listView);
			listView.x = 60;
			listView.layoutData = new AnchorLayoutData(0, null, 0, 60);
			stage.focus = listView;
			listView.visible = true;
		});

		var save:Button = new Button("保存");
		this.addChild(save);
		save.addEventListener(MouseEvent.CLICK, function(e) {
			var array = [];
			for (script in PupilscriptMain.scriptStage.scripts) {
				if (Std.isOfType(script, Pupil)) {
					array.push(script.toScriptData());
				}
			}
			this.onSaveData(array);
		});
	}

	dynamic public function onSaveData(data:Array<ScriptData>):Void {}

	/**
	 * 注册脚本列表
	 * @param script 
	 */
	public function addScript(script:IScript):Void {
		if (scripts.indexOf(script) == -1)
			scripts.add(script);
	}
}
