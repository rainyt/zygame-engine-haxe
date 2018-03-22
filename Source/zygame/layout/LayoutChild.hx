package zygame.layout;

import starling.display.DisplayObject;
import zygame.layout.LayoutData;

class LayoutChild {

    public var child:DisplayObject;

    public var data:LayoutData;

    public function new(child:DisplayObject,layout:LayoutData)
    {
        this.child = child;
        this.data = layout;
    }

}