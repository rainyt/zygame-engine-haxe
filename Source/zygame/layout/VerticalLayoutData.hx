package zygame.layout;

import zygame.layout.LayoutData;
import starling.display.DisplayObject;

class VerticalLayoutData extends LayoutData
{
    /**
     *  布局单个item的高度
     */
    public var itemHeight:Float = -1;

    /**
     *  竖向占比大小
     *  @param acc - 
     */
    public function new(?itemHeight:Float = -1){
        super();
        this.itemHeight = itemHeight;
    }

    /**
     *  获取高度
     *  @param display - 
     *  @return Float
     */
    override public function getHeight(display:DisplayObject):Float
    {
        if(itemHeight <= 0)
            return display.height;
        return itemHeight;
    }
}