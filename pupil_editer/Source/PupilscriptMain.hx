package;

import script.core.ScriptData;
import feathers.controls.LayoutGroup;
import pupil.SetPoint;
import script.core.Trace;
import script.core.SetParam;
import script.core.Aync;
import script.core.Sleep;
import editer.ActionMenu;
import script.core.Script;
import editer.ScriptStage;
import script.core.Break;
import pupil.Move;
import openfl.text.TextField;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import script.core.OneLoop;
import script.core.If;
import script.core.Loop;
import script.ScriptSprite;
import feathers.skins.RectangleSkin;
import feathers.layout.AnchorLayoutData;
import feathers.layout.AnchorLayout;
import editer.ActionMenu;
import feathers.controls.Application;

/**
 * PupilScript可视化编辑器
 */
class PupilscriptMain extends #if false LayoutGroup #else Application #end {
	public static var leftMenu:ActionMenu;

	public static var current:PupilscriptMain;

	public static var scriptStage:ScriptStage;

	public function new() {
		super();
		current = this;
		this.layout = new AnchorLayout();
		leftMenu = new ActionMenu();
		this.addChild(leftMenu);
		leftMenu.layoutData = new AnchorLayoutData(0, null, 0, 0);

		scriptStage = new ScriptStage();
		this.addChild(scriptStage);
		scriptStage.layoutData = new AnchorLayoutData(0, 0, 0, 60);

		// 注册脚本
		leftMenu.addScript(new Loop());
		leftMenu.addScript(new Aync());
		leftMenu.addScript(new OneLoop());
		leftMenu.addScript(new Trace());
		leftMenu.addScript(new Pupil());
		leftMenu.addScript(new Break());
		leftMenu.addScript(new Sleep());
		leftMenu.addScript(new SetParam());
		// OpenFL库
		#if openfl
		leftMenu.addScript(new Move());
		leftMenu.addScript(new SetPoint());
		#end

		#if !pupilediter
		this.backgroundSkin = new RectangleSkin(SolidColor(0x252525));
		bindSaveData(function(array) {
			for (item in array) {
				trace(item);
			}
		});
		#else
		this.backgroundSkin = null;
		#end
	}

	public function bindSaveData(save:Array<ScriptData>->Void):Void {
		leftMenu.onSaveData = save;
	}

	public function getScriptStage():ScriptStage {
		return scriptStage;
	}
}
