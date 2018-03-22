package zygame.layout;

import zygame.layout.LayoutChild;
import zygame.ui.LayoutDisplayObjectContainer;

/**
 *  布局基类
 */
class Layout {

    public var canUpdate:Bool = true;

    /**
     *  尺寸变更时，需要更新计算时
     */
    public function onUpdate(root:LayoutDisplayObjectContainer, arr:Array<LayoutChild>):Void
    {
        canUpdate = false;
    }

    /**
     *  每帧更新
     */
    public function onFrame(root:LayoutDisplayObjectContainer, arr:Array<LayoutChild>):Void
    {
        if(canUpdate)
            this.onUpdate(root,arr);
    }

}