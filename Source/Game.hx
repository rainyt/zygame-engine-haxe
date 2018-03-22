package;

import zygame.core.GameCore;
import starling.display.Quad;
import starling.events.Touch;
import zygame.display.World;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.events.Event;
import zygame.ui.Button;
import zygame.display.SpriteRole;
import starling.display.Image;
import zygame.ui.FullScreenView;
import zygame.layout.FreeLayoutData;
import zygame.data.ListData;
import zygame.ui.ListView;
import zygame.ui.ScrollBar;
import zygame.skin.ScrollBarSkin;
import zygame.layout.VerticalLayout;
import starling.display.Canvas;


class Game extends World {
	
	private var _text:TextField;
	private var _count:Int;
	
	public function new () {

		super("zx0",null);
		trace("Game Start!");
	}

	override public function onInit():Void
	{
		super.onInit();
		//侦听帧事件
		this.listenerFrame();

		//侦听键控
		this.listenerKey();

		//开启点击
		this.isTouch = true;
	
		_text = new TextField(200,32,"Count:0",new TextFormat("Verdana",18,0x0));

		var button:Button = new Button("播放背景音乐",GameCore.getTexture("icon"));
		button.addEventListener(Event.TRIGGERED,function(e:Event):Void
		{
			trace("点击事件");
		});

		var layout:FullScreenView = new FullScreenView();
		this.addChild(layout);
		layout.viewWidth = stage.stageWidth;
		layout.viewHeight = stage.stageHeight;
		layout.addChildToLayout(button,new FreeLayoutData(120,0,50,Math.NaN,Math.NaN,Math.NaN));
		layout.addChildToLayout(_text,new FreeLayoutData(120,0,5,Math.NaN,Math.NaN,Math.NaN));


		var vlayout:VLayout = new VLayout();
		layout.addChildToLayout(vlayout,new FreeLayoutData(Math.NaN,Math.NaN,0,0,Math.NaN,Math.NaN));
		layout.addEventListener(Event.TRIGGERED,onEventButton);

		var i:Int = 0;
		var arr:Array<Dynamic> = [];
		while(i < 100)
		{
			arr.push(i);
			i++;
		}

		var listView:ListView = new ListView(new ListData(arr));
		listView.itemRenderBind = DemoItem;
		cast(listView.layout,VerticalLayout).gap = 5;
		listView.viewWidth = 100;
		layout.addChildToLayout(listView,new FreeLayoutData(Math.NaN,0,200,0,Math.NaN,Math.NaN));
		listView.scorllBarV = new ScrollBar(new ScrollBarSkin(GameCore.getTexture("line"),GameCore.getTexture("moveBtn")));
	}

	public function onEventButton(e:Event):Void
	{
		switch(cast(e.target,Button).text)
		{
			case "生成角色":
				var role:SpriteRole = new SpriteRole("suixing", Math.random()*stage.stageWidth, Math.random()*stage.stageHeight,this,24,1,Std.int(Math.random()*100));
				this.addChild(role);
				this.role = role;
			case "生成方块":
				var sprite:GameSprite = new GameSprite();
				this.addChild(sprite);
				var fk:Body = new Body(BodyType.DYNAMIC);
				var rect:Polygon = new Polygon(Polygon.box(50,50,true));
				fk.shapes.add(rect);
				fk.position.x = Math.random()*stage.stageWidth;
				fk.position.y = Math.random()*stage.stageHeight;
				fk.space = nape;
				fk.userData.ref = sprite;
			case "打开窗口":

		}
	}

	override public function onFrame():Void
	{
		super.onFrame();
		_text.text = "Count:"+this.numChildren + "_"+_text.width;
	}


	override public function create():Void
	{
		super.create();

		// var bg:Image = new Image(GameCore.getTexture("bg"));
		// this.addChild(bg);
		// bg.y = -50;

		// createRect(0,600,2000,32,0);
		// createRect(600,0,32,2000,0);
		// createRect(600,0,32,2000,-0.3);
		// createRect(600,0,32,2000,-0.6);
		// createRect(600,0,32,2000,-1);
		// var can:Canvas = new Canvas();
		// can.beginFill(0x0);
		// can.drawCircle(200,200,100);
		// this.addChild(can);
	}

	/**
	 *  创建方块
	 *  @param x - 
	 *  @param y - 
	 *  @param w - 
	 *  @param h - 
	 *  @param r - 
	 */
	public function createRect(x:Int,y:Int,w:Int,h:Int,r:Float):Void
	{
		var diban:Quad = new Quad(w,h,0xff0000);	
		this.addChild(diban);
		diban.x = x;
		diban.alpha = 0.5;
		diban.rotation = r;
		diban.y = y;
		var fk:Body = new Body(BodyType.STATIC);
		var rect:Polygon = new Polygon(Polygon.rect(0,0,w,h));
		fk.shapes.add(rect);
		fk.position.x = x;
		fk.position.y = y;
		fk.rotation = r;
		fk.space = nape;
	}
	
}