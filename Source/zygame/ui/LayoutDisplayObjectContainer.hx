package zygame.ui;

import zygame.display.TouchDisplayObject;
import zygame.layout.Layout;
import zygame.layout.LayoutChild;
import zygame.layout.LayoutData;
import starling.display.DisplayObject;
import zygame.layout.FreeLayout;

class LayoutDisplayObjectContainer extends TouchDisplayObject {

    /**
     *  水平滚动
     */
    public var horizontalScrollX:Float = 0;

    /**
     *  竖向滚动条
     */
    public var verticalScrollY:Float = 0;

    /**
     *  布局逻辑
     */
    public var layout:Layout;

    /**
     *  绑定了布局的孩子们
     */
    public var childs:Array<LayoutChild>;

    /**
     *  设置实际窗口宽度
     */
    public var viewWidth(get,set):Int;
    private var _viewWidth:Int = -1;
    private function get_viewWidth():Int{
        if(_viewWidth == -1)
            return Std.int(width);
        return _viewWidth;
    }
    private function set_viewWidth(i:Int):Int{
       _viewWidth = i;
       layout.canUpdate = true;
       return get_viewWidth(); 
    }

    /**
     *  设置实际窗口高度
     */
    public var viewHeight(get,set):Int;
    private var _viewHeight:Int = -1;
    private function get_viewHeight():Int{
        if(_viewHeight == -1)
            return Std.int(height);
        return _viewHeight;
    }
    private function set_viewHeight(i:Int):Int{
       _viewHeight = i;
       layout.canUpdate = true;
       return get_viewHeight(); 
    }

    /**
     *  布局容器的宽度不会被更改，永远以原大小的宽度，但设置这个会影响viewWidth
     *  @param i - 
     *  @return Float
     */
    override public function set_width(i:Float):Float
    {
        viewWidth = Std.int(i);
        return super.width;
    }

    /**
     *  布局容器的高度不会被更改，永远以原大小的高度，但设置这个会影响viewHieght
     *  @param i - 
     *  @return Float
     */
    override public function set_height(i:Float):Float
    {
        viewHeight = Std.int(i);
        return super.height;
    }

    /**
     *  布局控件
     *  layout 默认为自由布局
     */
    public function new(layout:Layout = null){
        super();
        childs = new Array<LayoutChild>();
        if(layout == null)
            layout = new FreeLayout();
        this.layout = layout;
    }

    /**
     *  自动添加帧事件
     */
    override public function onInit():Void
    {
        super.onInit();
        this.addToParentFrameEvents();
        if(!this.isListenerFrameEvent){
            this.listenerFrame();
        }
    }

    /**
     *  大小被调整触发
     */
    public function onSize():Void
    {
        if(layout  != null)
            layout.canUpdate = true;
    }

    /**
     *  布局运算
     */
    override public function onFrame():Void
    {
        super.onFrame();
        if(layout != null)
            layout.onFrame(this,childs);
    }

    /**
     *  添加对象到布局中
     */
    public function addChildToLayout(display:DisplayObject,layoutdata:LayoutData):Void
    {
        super.addChild(display);
        childs.push(new LayoutChild(display,layoutdata));
        layout.canUpdate = true;
        layout.onFrame(this,childs);
    }

    

}