package zygame.display;

import starling.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import zygame.display.World;
import starling.events.Event;
import starling.display.Quad;
import zygame.core.CoreStarup;
import starling.core.Starling;
import haxe.Constraints.Function;

/**
 * 游戏的容器
 */
class DisplayObjectContainer extends Sprite {
    
    /**
     *  用于剧情对话锚点使用，如果需要动态计算剧情的位置，可指定该值生效。
     */
    public var posPoint:Point;
    
    /**
     *  数据源
     */
    public var data:Dynamic;

    /**
     *  目标名字
     */
    public var targetName:String;

    /**
     *  世界
     */
    public var world:World;

    /**
     * 是否已经添加完毕，如果已经初始化，这不会再调用onInit(); 
     */		
    public var isInited:Bool = false;

    /**
     * 锁定矩形，避免频繁访问bounds造成性能问题
     */		
    private var _lockRect:Rectangle;

    /**
     * 锁定偏移 
     */		
    private var _lockPoint:Rectangle;

    /**
     * 是否进行删除，如果进行删除，引擎会在安全的地方进行移除，如世界运行每一帧的最后。
     */
    public var isRemoveing:Bool = false;

    /**
     *  帧事件录入
     */
    public var frameEvents:Array<DisplayObjectContainer>;

    /**
     *  帧事件父亲
     */
    public var frameEventParent:DisplayObjectContainer;

    /**
     *  是否在侦听帧事件
     */
    public var isListenerFrameEvent(get,never):Bool;
    private function get_isListenerFrameEvent():Bool
    {
        if(frameEventParent != null)
            return true;
        return this.hasEventListener(Event.ENTER_FRAME);
    }

    public function new(){
        super();
        frameEvents = [];
        this.addEventListener(Event.ADDED_TO_STAGE,onAdd);
        this.addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
        if(CoreStarup.getInstance().drawDisplayObjectContainerDebug)
            this.debug();
    }

    /**
     *  当添加到舞台时触发，该方法会每次添加都会调用
     *  @param e - 
     *  @return void
     */
    public function onAdd(e:Event):Void
    {
        //如果还未初始化，则开始初始化数据，以及onInit。
        if(!this.isInited){
            this.onInit();
        }
        this.isInited = true;
    }
    
    /**
     * 当从舞台移除时
     */
    public function onRemove(e:Event):Void
    {
    }

    /**
     *  初始化入口，建议所有初始化行为都在这里执行，因为在这里可以完整的访问到stage。
     */
    public function onInit():Void
    {
    }

    /**
     * 辅助线，你可以使用CoreStarup.getInstance().drawDisplayObjectContainerDebug=true进行自动渲染
     */
    public function debug():Void
    {
        var qx:Quad = new Quad(200,1,0xff0000);
        qx.x -= 100;
        this.addChild(qx);
        var qy:Quad = new Quad(1,200,0xff0000);
        qy.y -= 100;
        this.addChild(qy);
    }

    /**
     *  直接获取一个剧情对话锚点，该锚点会根据自身的中心点进行计算
     *  @return Point
     */
    public function getPoltPos():Point
    {
        var rect:Rectangle = this.bounds;
        if(posPoint == null){
            var point:Point = new Point(this.x,rect.y);
            posPoint = point;
        }
        else
        {
            posPoint.x = this.x;
            posPoint.y = rect.y;
        }
        return posPoint;
    }

    /**
     *  设置该容器的坐标
     *  @param pos - 坐标
     */
    public function setPos(pos:Point):Void
    {
       super.x = pos.x;
        super.y = pos.y;
    }

    /**
     * 设置X
     */
    public function setX(i:Int):Void
    {
        super.x = i;
    }
    
    /**
     * 设置Y
     */
    public function setY(i:Int):Void
    {
        super.y = i;
    }

    /**
     * 判断是否必须绘制在舞台上
     */
    public function isMustDrawStage():Bool
    {
        if(!CoreStarup.getInstance().disableIFMustDraw || this.world == null || this.parent == null) 
            return super.visible;
        return true;
        // return this.bounds.intersects(this.world.drawRect);
    }
    
    /**
     * 获取示例名字
     */
    public function getInstanceName():String
    {
        if(data == null || data.instanceName == null || Std.string(data.instanceName) == "")
        {
            return this.targetName;
        }
        return Std.string(data.instanceName);
    }

    /**
     * 延迟通知 
     * @param func
     */		
    public function callLate(func:Function):Void
    {
        Starling.current.juggler.delayCall(func,1/60);
    }

    /**
     * 侦听帧事件，当触发了该事件，当前容器的onFrame()方法将会主动调用 
     */		
    public function listenerFrame():Void
    {
        this.addEventListener(Event.ENTER_FRAME,function(e:Event):Void{
            onFrame();	
        });
    }

    /**
     *  加入到父集中的帧事件中
     *  由于cast性能极低，因此只做一次cast侦听处理
     */
    public function addToParentFrameEvents():Void
    {
        var tisparent:DisplayObjectContainer = try cast(this.parent,DisplayObjectContainer) catch(e:Dynamic) null;
        while(true)
        {
            if(tisparent == null || tisparent.parent == null)
            {
                break;
            }
            if(tisparent.isListenerFrameEvent == true)
            {
                tisparent.frameEvents.push(this);
                frameEventParent = tisparent;
                break;
            }
            tisparent = try cast(tisparent.parent,DisplayObjectContainer) catch(e:Dynamic) null;
        }
    }

    public function removeFrameEvents():Void
    {
        if(frameEventParent != null)
        {
            frameEventParent.frameEvents.remove(this);
        }
    }

    /**
     *  帧事件处理，需要加入到帧事件才会进行执行读取
     */
    public function onFrame():Void
    {
        var i:Int = 0;
        var len:Int = frameEvents.length;
        while(i < len){
            var display:DisplayObjectContainer = frameEvents[i];
            if(display != null){
                display.onFrame();
            }
            i++;
        }
    }

    override public function dispose():Void
    {
        super.dispose();
        this.removeFrameEvents();
    }

}