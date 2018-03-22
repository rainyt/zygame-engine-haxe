package zygame.core;

import openfl.display.Sprite;
import starling.core.Starling;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.system.Capabilities;
import starling.events.Event;
import openfl.media.SoundMixer;
import openfl.media.SoundTransform;
import starling.utils.SystemUtil;
import zygame.core.RunderType;
import zygame.core.GameStarling;
import zygame.core.GameCore;
import starling.display.DisplayObjectContainer;
import starling.display.DisplayObject;
import zygame.ui.LayoutDisplayObjectContainer;

/**
 * 游戏引擎初始化入口，继承这个即可
 */
class CoreStarup extends Sprite{

    /**
     *  单例源
     */
    private static var _core:CoreStarup;
    public static function getInstance():CoreStarup{
        return _core;
    }

    /**
     *  渲染引擎
     */
    public var starling:GameStarling;

    /**
     *  禁用判断渲染，往往这样会使渲染引擎将屏幕外的对象一起渲染，默认为false；
	 */		
	public var disableIFMustDraw:Bool = false;

    /**
     *  是否渲染容器的debug视图
     */
    public var drawDisplayObjectContainerDebug:Bool = false;

    /**
     *  是否为PC端，如果是PC端，显示的比例会根据窗口来计算，否则全屏计算。
     */
    public var isPc:Bool;

    /**
     *  如果愿意，你可以指定一个可显示区域大小。
     */
    public var targetViewPort:Rectangle;

    /**
     * 是否测试模式，这将使Starling显示一个draw、CPU以及GPU使用率的显示。
     */
    public var isDebug:Bool = false;

    /**
     *  可用于适配刘海型号的手机类型，但建议只给手机使用。
     */
    public var statusBarHeight:Int;

    /**
     *  当引擎恢复时，将会还原的音量大小。
     */
    private var _restoreVolmue:Float;

    /**
     *  配置路径
     */
    public var projectPath:String;

    /**
     *  是否可以忽略帧，如果选择跳帧，那么在某些情况下，渲染遇到了压力的时候就会跳帧，减少渲染能力，从而保持FPS。
     *  注意：
     *  不是所有游戏都适合跳帧，但格斗系列游戏还是允许使用。另外如果runderType不属于high，建议不要使用。
     *  如果设置了非high的时候，isSkinFrame也会自动调为false。
     *  
     *  只在flash平台生效
     */
    public var isSkinFrame:Bool = false;

    public var mainClass:Class<Dynamic> = null;

    /**
     *  渲染类型
     *  high - 这将永远都保持60FPS的运行
     *  medium - 这将节省部分的性能，采取50FPS的运行
     *  low - 这将节省大部分的性能，但画面渲染次数直接减少一半，采取30FPS的运行
     */
    public var runderType(get,set):String;
    private var _runderType:String;
    private function set_runderType(value:String):String
    {
        switch(value)
        {
            case RunderType.HIGH:
                this.stage.frameRate = 60;
                this.starling.fps = 60;
            case RunderType.MEDIUM:
                this.stage.frameRate = 60;
                this.starling.fps = 50;
                isSkinFrame = false;
            case RunderType.LOW:
                this.stage.frameRate = 30;
                this.starling.fps = 30;
                isSkinFrame = false;
        }
        trace("Stage frameRate is "+this.stage.frameRate);
        _runderType = value;
        return _runderType;
    }
    private function get_runderType():String
    {
        return _runderType;
    }

    public function new(){
        _core = this;
        super();
    }

    public var viewPort:Rectangle;

    public var HDHeight:Int;

    /**
     *  初始化Starling引擎，Starling版本为2.x
     *  @param configPath - project.xml文件路径
     *  @param mainClass - 主Starling启动类
     *  @param HDHeight - 以高适配的高度
     *  @param debug - 是否为测试模式
     *  @param isPc - 是否为PC端
     *  @param stage3DProfile - stage3d的配置
     *  @param isMultitouch - 是否多点触控
     *  @param runMode - 渲染模式
     *  @param antiAliasing - 抗锯齿层度
     *  @param loadContextImage - 上下文丢失加载图
     */
    public function initStarling(configPath:String,mainClass:Class<Dynamic>,HDHeight:Int=480,debug:Bool=false,_isPc:Bool=false,stage3DProfile:String="auto",isMultitouch:Bool = true,runMode:String = "auto",antiAliasing:Int = 16,loadContextImage:BitmapData = null):Void
    {
        this.HDHeight = HDHeight;
        this.mainClass = mainClass;
        this.projectPath = configPath;
        this.isDebug = debug;
        this.isPc = _isPc;
        Starling.multitouchEnabled = isMultitouch;
        
        viewPort = targetViewPort!=null?targetViewPort:new Rectangle(0,0,
            isPc ? stage.stageWidth : stage.fullScreenWidth, 
            isPc ? stage.stageHeight : stage.fullScreenHeight
        );

        if(viewPort.width == 0){
				viewPort.width = 800;
        }
        if(viewPort.height == 0){
            viewPort.height = 550;
        }

        //用于适配刘海，建议竖屏使用。
        viewPort.y = statusBarHeight;
        viewPort.height -= statusBarHeight;

        //得到以高适配的屏幕计算
        var hscale:Float = (viewPort.height)/HDHeight;
        
        starling = new GameStarling(mainClass,this.stage,viewPort,null,runMode,stage3DProfile);
        starling.stage.stageWidth = Std.int((viewPort.width - viewPort.height)/hscale + HDHeight);
        starling.stage.stageHeight = HDHeight;
        starling.enableErrorChecking = Capabilities.isDebugger;
        starling.antiAliasing = antiAliasing;
        starling.addEventListener(Event.ROOT_CREATED,onRootCreate);

        //初始化引擎
        GameCore.init(stage,projectPath);

        //侦听引擎的启动/静止
        this.addEventListener(openfl.events.Event.ACTIVATE,onActivate);
		this.addEventListener(openfl.events.Event.DEACTIVATE,onDeactivate);
        stage.addEventListener(Event.RESIZE,onSize);
    }

    /**
     *  尺寸变更，舞台大小变更
     *  @param e - 
     */
    public function onSize(e:Event):Void
    {
        viewPort.width = isPc ? stage.stageWidth : stage.fullScreenWidth;
        viewPort.height = isPc ? stage.stageHeight : stage.fullScreenHeight;

        //用于适配刘海，建议竖屏使用。
        viewPort.y = statusBarHeight;
        viewPort.height -= statusBarHeight;

        //得到以高适配的屏幕计算
        var hscale:Float = (viewPort.height)/HDHeight;
        starling.viewPort = viewPort;
        starling.stage.stageWidth = Std.int((viewPort.width - viewPort.height)/hscale + HDHeight);
        starling.stage.stageHeight = HDHeight;

        if(isDebug)
            starling.showStatsAt("right","top");

        //通知舞台所有LayoutDisplayObjectContainer类舞台事件
        pushSizeEvent(starling.stage);
    }

    private function pushSizeEvent(display:DisplayObjectContainer):Void
    {
        var i:Int = 0;
        while(i < display.numChildren)
        {
            var child:DisplayObject = display.getChildAt(i);
            if(Std.is(child,DisplayObjectContainer))
            {
                if(Std.is(child,LayoutDisplayObjectContainer))
                {
                    cast(child,LayoutDisplayObjectContainer).onSize();
                }
                pushSizeEvent(cast(child,DisplayObjectContainer));
            }
            i++;
        }
    }

    /**
     *  成功创建上下文回调
     *  @param e - 
     *  @param app - 
     */
    private function onRootCreate(e:Event):Void{
        trace("StarlingHaxe Go!");
        starling.start();
        starling.removeEventListener(Event.ROOT_CREATED, onRootCreate);
        //初始化
        GameCore.currentCore.initProject();
        //是否DEBUG
        if(isDebug){
            starling.showStatsAt("right","top");
        }
    } 

    /**
     *  当被激活时
     *  @param event - 
     */
    private function onActivate(event:openfl.events.Event):Void
    {
        trace("onActivate");
        if(starling != null){
            starling.start();
        }
        if(!SystemUtil.isDesktop){
            SoundMixer.soundTransform = new SoundTransform(this._restoreVolmue);
        }
    }

    /**
     *  当被冷冻时
     *  @param event - 
     */
    private function onDeactivate(event:openfl.events.Event):Void
    {
        trace("onDeactivate");
        if(starling != null){
            starling.stop();
        }
        if(!SystemUtil.isDesktop){
            this._restoreVolmue = SoundMixer.soundTransform.volume;
            SoundMixer.soundTransform = new SoundTransform(0);
        }
    }

}