package zygame.ui;

import zygame.ui.LayoutDisplayObjectContainer;
import zygame.layout.Layout;

/**
 *  全屏锁定窗口，x，y轴永远为0，宽度高度永远为stage.stageWidth,stage.stageHeight
 */
class FullScreenView extends LayoutDisplayObjectContainer{

    public function new(layout:Layout = null){
        super(layout);
    }

    override public function onInit():Void
    {
        super.onInit();
        this.viewWidth = stage.stageWidth;
        this.viewHeight = stage.stageHeight;  
    }

    override public function onFrame():Void
    {
        super.onFrame();
        this.x = 0;
        this.y = 0;
    }

    override public function onSize():Void
    {
        this.viewWidth = stage.stageWidth;
        this.viewHeight = stage.stageHeight;
        super.onSize();
    }

}