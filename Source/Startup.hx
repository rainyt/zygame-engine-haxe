package;

import zygame.core.CoreStarup;
import zygame.core.RunderType;
import openfl.events.Event;
import openfl.display.Sprite;
import starling.core.Starling;
import openfl.Vector;
import zygame.utils.Log;
import openfl.display.Loader;
import openfl.net.URLRequest;
import openfl.text.TextField;
import openfl.text.TextFieldType;

class Startup extends CoreStarup {
		
	
	public function new () {
		
		super ();

		this.addEventListener(Event.ADDED_TO_STAGE,onInit);

		// Log.debug(stage);
	}

	private function onInit(e:Event):Void
	{
		//初始化Starling
		initStarling("assets/project.xml",GameMain,640,true,true);
		//设置运行速度
		this.runderType = RunderType.HIGH;
		//设置bug绘制
		// this.drawDisplayObjectContainerDebug = true;
		// var text:TextField = new TextField();
		// this.addChild(text);
		// text.type = TextFieldType.INPUT;
		// text.width = 100;
		// text.height = 100;
		// text.text = "测试test";

	}
	
}