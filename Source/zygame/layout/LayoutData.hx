package zygame.layout;

import starling.display.DisplayObject;

/**
 *  布局数据
 */
class LayoutData {
    
    public var data:Map<String,Dynamic>;

    public function new(){
        data = new Map<String,Dynamic>();
    }

    public function getWidth(display:DisplayObject):Float
    {
        return display.width;
    }

    public function getHeight(display:DisplayObject):Float
    {
        return display.height;
    }

}