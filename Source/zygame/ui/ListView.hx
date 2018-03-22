package zygame.ui;

import zygame.layout.Layout;
import zygame.ui.ScrollView;
import starling.display.Quad;
import zygame.ui.ListItemRender;
import zygame.data.ListData;
import zygame.layout.VerticalLayout;
import zygame.ui.DefalutItemRender;
import zygame.layout.LayoutData;
import zygame.layout.VerticalLayoutData;
import starling.display.DisplayObject;


/**
 *  用于显示列表，会对显示内容进行优化处理
 */
class ListView extends ScrollView{

    private var _maskQuad:Quad;
    override public function set_viewWidth(i:Int):Int
    {
        super.viewWidth = i;
        _maskQuad.width = i;
        return i;
    }
    override public function set_viewHeight(i:Int):Int
    {
        super.viewHeight = i;
        _maskQuad.height = i;
        return i;
    }

    public var listData(get,set):ListData;
    private var _listData:ListData;
    public function get_listData():ListData
    {
        return _listData;
    }
    public function set_listData(value:ListData):ListData
    {
        _listData = value;
        return value;
    }


    /**
     *  渲染项目
     */
    public var itemRenderBind:Class<Dynamic> = null;

    public var layoutData(get,set):LayoutData;
    private var _layoutData:LayoutData;
    private function get_layoutData():LayoutData
    {
        return _layoutData;
    }
    private function set_layoutData(data:LayoutData):LayoutData
    {
        _layoutData = data;
        return data;
    }

    public function new(listData:ListData,layout:Layout = null,layoutData:LayoutData = null)
    {
        if(layoutData == null)
            layoutData = new VerticalLayoutData();
        this.layoutData = layoutData;
        itemRenderBind = DefalutItemRender;
        //默认使用竖向布局
        if(layout == null)
            layout = new VerticalLayout();
        super(layout);
        //数据
        this.listData = listData;
        //遮罩层
        _maskQuad = new Quad(1,1,0xff0000);
        _maskQuad.alpha = 0.5;
        this.mask = _maskQuad;
    }   

    /**
     *  初始化
     */
    override public function onInit():Void
    {
        super.onInit();
    }

    /**
     *  回收池计算
     */
    override public function onFrame():Void
    {
        super.onFrame();
    }

    /**
     *  创建一个渲染组件
     *  @return ListItemRender
     */
    public function createItem():ListItemRender
    {
        var item:ListItemRender = Type.createInstance(itemRenderBind,[]);
        return item;
    }

    /**
     *  根据组件+数据计算最大maxScorllH
     *  @return Int
     */
    override public function get_maxScorllV():Int
    {
        if(Std.is(layout,VerticalLayout) && childs.length > 0)
            return Std.int(layoutData.getHeight(childs[0].child)*listData.length);
        return super.maxScorllV;
    }

    /**
     *  为了保证ScorllBar在最顶
     *  @param display - 
     *  @param layout - 
     */
    override public function addChildToLayout(display:DisplayObject,layout:LayoutData):Void
    {
        super.addChildToLayout(display,layout);
        if(_scorllBarV != null)
            this.addChild(_scorllBarV);
    }
}