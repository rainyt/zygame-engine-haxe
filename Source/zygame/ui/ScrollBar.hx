package zygame.ui;

import zygame.ui.LayoutDisplayObjectContainer;
import starling.display.Image;
import zygame.layout.FreeLayoutData;
import zygame.skin.ScrollBarSkin;
import zygame.ui.ScrollView;

/**
 *  实现ScrollBar的滚动条
 */
class ScrollBar extends LayoutDisplayObjectContainer{

    /**
     *  竖向
     */
    public static inline var VERTICAL:String = "vertical";

    public static inline var HORIZONTAL:String = "horizontal";

    private var _skin:ScrollBarSkin;

    private var _type:String;

    private var _move:Image;

    public var scroll:ScrollView;

    /**
     *  用于显示当前Scroll的比例
     *  @param type - 横向或者竖向
     *  @param bgSkin - 背景，允许为null
     *  @param moveSkin - 移动块
     */
    public function new(skin:ScrollBarSkin,type:String = "vertical"){
        super();
        _type = type;
        _skin = skin;
    }

    override public function onInit():Void
    {
        super.onInit();
        if(_skin.bgSkin != null)
        {
            var img:Image = new Image(_skin.bgSkin);
            img.scale9Grid = _skin.bgS9Rect;
            switch(_type)
            {
                case VERTICAL:
                    this.addChildToLayout(img,new FreeLayoutData(Math.NaN,0,0,0,Math.NaN,Math.NaN));
                case HORIZONTAL:
                    this.addChildToLayout(img,new FreeLayoutData(0,0,Math.NaN,0,Math.NaN,Math.NaN));
            }
        }

        if(_skin.moveSkin != null)
        {
            _move = new Image(_skin.moveSkin);
            _move.scale9Grid = _skin.moveS9Rect;
            switch(_type)
            {
                case VERTICAL:
                    this.addChildToLayout(_move,new FreeLayoutData(Math.NaN,0,Math.NaN,Math.NaN,Math.NaN,Math.NaN));
                case HORIZONTAL:
                    this.addChildToLayout(_move,new FreeLayoutData(Math.NaN,Math.NaN,Math.NaN,0,Math.NaN,Math.NaN));
            }
        }
    }

    override public function onFrame():Void
    {
        super.onFrame();
        _move.y = -(this.viewHeight - _move.height) * (scroll.verticalScrollY / (scroll.maxScorllV - scroll.viewHeight));
    }
}   