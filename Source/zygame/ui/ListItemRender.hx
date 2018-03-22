package zygame.ui;

import zygame.ui.LayoutDisplayObjectContainer;
import zygame.ui.ListView;

/**
 *  默认渲染器
 */
@:keep
class ListItemRender extends LayoutDisplayObjectContainer
{
    private var _data:Dynamic;

    private var _index:Int;

    private var _isSelect:Bool;

    public var ownView:ListView;

    override public function set_viewWidth(i:Int):Int
    {
        if(super.viewWidth != i)
        {
            super.viewWidth = i;
            this.onRender();
        }
        return i;
    }

    override public function set_viewHeight(i:Int):Int
    {
        if(super.viewHeight != i)
        {
            super.viewHeight = i;
            this.onRender();
        }
        return i;
    }

    public function new(){
        super();
    }

    /**
     *  渲染入口
     */
    public function onRender():Void
    {
        this.layout.canUpdate = true;
        this.onFrame();
    }

    /**
     *  重写初始化，不主动加入onFrame
     */
    override public function onInit():Void
    {

    }

    public function setData(ob:Dynamic):Void
    {
        _data = ob;
    }

    public function getData():Dynamic
    {
        return _data;
    }

    public function setIndex(i:Int):Void
    {
        _index = i;
    }

    public function getIndex():Int
    {
        return _index;
    }

    public function setSelect(isSelect:Bool):Void
    {
        _isSelect = isSelect;
    }

    public function getSelect():Bool
    {
        return _isSelect;
    }
}