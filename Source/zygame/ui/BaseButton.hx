package zygame.ui;

import zygame.display.TouchDisplayObject;
import zygame.display.DisplayObjectContainer;
import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.Event;
import openfl.geom.Rectangle;
import zygame.utils.ZYMath;

/**
 *  按钮基类
 */
class BaseButton extends TouchDisplayObject
{
    /**
     *  按下的缩放率
     */
    public var downscale:Float = 0.8;

    /**
     *  是否可以触发点击事件
     */
    public var canTriggered(get,never):Bool;
    private var _canTriggered = false;
    public function get_canTriggered():Bool
    {
        return _canTriggered;
    }

    /**
     *  储存组
     */
    public var group:DisplayObjectContainer;

    public function new(){
        super();
        this.touchGroup = true; 
        group = new DisplayObjectContainer();
        super.addChild(group);
        this.isTouch = true;
    }

    /**
     *  这里添加的资源会往group填充
     *  @param child - 
     *  @return DisplayObject
     */
    override public function addChild(child:DisplayObject):DisplayObject
    {
        var child:DisplayObject = group.addChild(child);
        group.alignPivot();
        group.x = group.pivotX;
        group.y = group.pivotY;
        return child;
    }

    override public function get_width():Float
    {
        if(group.scale != 1)
            return group.width/downscale;
        else
            return super.width;
    }

    override public function get_height():Float
    {
        if(group.scale != 1)
            return group.height/downscale;
        else
            return super.height;
    }
    
    override public function onTouchBegin(touch:Touch):Void
    {
        this.onDownAnime();
        _canTriggered = true;
    }

    /**
     * touch悬浮 
     * @param touch
     * 
     */		
    override public function onTouchHover(touch:Touch):Void
    {
        
    }
    
    /**
     * touch移动 
     * @param touch
     * 
     */		
    override public function onTouchMove(touch:Touch):Void
    {
        
    }
    
    /**
     * touch松开
     * @param touch
     * 
     */		
    override public function onTouchEnd(touch:Touch):Void
    {
        this.onUpAnime();
        if(canTriggered){
            touch.getLocation(this.parent,ZYMath.pos());
            if(this.bounds.intersects(ZYMath.rect(ZYMath.lastPos().x,ZYMath.lastPos().y,1,1)))
            {
                this.dispatchEventWith(Event.TRIGGERED,true);
            }
            _canTriggered = false;
        }
    }

    public function onUpAnime():Void
    {
        this.group.scale = 1;
    }

    public function onDownAnime():Void
    {
        this.group.scale = downscale;
    }
}