package zygame.display;

import zygame.display.DisplayObjectContainer;
import starling.events.TouchEvent;
import starling.events.Touch;
import starling.events.TouchPhase;

class TouchDisplayObject extends DisplayObjectContainer{


    public function new(){
        super();
    }

    /**
     * 设置为是否可以点击，如果可以点击，将会返回onTouch方法 
     * @param value
     */		
    public var isTouch(get,set):Bool;
    public function set_isTouch(value:Bool):Bool
    {
        if(value && !isTouch)
            this.addEventListener(TouchEvent.TOUCH,onTouch);
        else if(hasEventListener(TouchEvent.TOUCH))
            this.removeEventListeners(TouchEvent.TOUCH);
        return value;
    }
    public function get_isTouch():Bool
    {
        return hasEventListener(TouchEvent.TOUCH);
    }

    /**
     * Touch分发 
     * @param e
     */		
    public function onTouch(e:TouchEvent):Void
    {
        var i:Int = 0;
        while(i<e.touches.length){
            var touch:Touch = e.touches[i];
            switch(touch.phase){
                case TouchPhase.BEGAN:
                    onTouchBegin(touch);
                case TouchPhase.MOVED:
                    onTouchMove(touch);
                case TouchPhase.ENDED:
                    onTouchEnd(touch);
                case TouchPhase.HOVER:
                    onTouchHover(touch);
            }
            i++;
        }
    }

    /**
     * touch点下 
     * @param touch
     * 
     */		
    public function onTouchBegin(touch:Touch):Void
    {
        
    }
    
    /**
     * touch悬浮 
     * @param touch
     * 
     */		
    public function onTouchHover(touch:Touch):Void
    {
        
    }
    
    /**
     * touch移动 
     * @param touch
     * 
     */		
    public function onTouchMove(touch:Touch):Void
    {
        
    }
    
    /**
     * touch松开
     * @param touch
     * 
     */		
    public function onTouchEnd(touch:Touch):Void
    {
        
    }

}