package zygame.ui;

import zygame.ui.LayoutDisplayObjectContainer;
import zygame.layout.Layout;
import starling.events.Touch;
import openfl.geom.Point;
import zygame.layout.VerticalLayout;
import zygame.ui.ScrollBar;

/**
 *  滚动View
 */
class ScrollView extends LayoutDisplayObjectContainer{

    /**
     *  是否使用竖向滚动
     */
    public var useScorllV:Bool = true;

    /**
     *  是否使用横向滚动
     */
    public var useScorllH:Bool = true;

    /**
     *  是否滚动中
     */
    public var isScoring:Bool = false;
    
    /**
     *  最大的滚动轴
     */
    public var maxScorllV(get,never):Int;
    public function get_maxScorllV():Int
    {  
        return Std.int(this.height);
    }

    /**
     *  设置V的滚动条
     */
    public var scorllBarV(get,set):ScrollBar;
    private var _scorllBarV:ScrollBar;
    private function set_scorllBarV(bar:ScrollBar):ScrollBar
    {
        bar.scroll = this;
        _scorllBarV = bar;
        this.addChild(_scorllBarV);
        _scorllBarV.x = viewWidth - _scorllBarV.width;
        _scorllBarV.viewHeight = viewHeight;
        _scorllBarV.y = 0;
        return _scorllBarV;
    }
    private function get_scorllBarV():ScrollBar
    {
        return _scorllBarV;
    }

    override public function set_viewWidth(value:Int):Int
    {
        super.viewWidth = value;
        if(_scorllBarV != null){
            _scorllBarV.x = viewWidth - _scorllBarV.width;
        }
        return value;
    }

    override public function set_viewHeight(value:Int):Int
    {
        super.viewHeight = value;
        if(_scorllBarV != null){
            _scorllBarV.viewHeight = value;
        }
        return value;
    }

    /**
     *  最大的水平滚动轴
     */
    public var maxScorllH(get,never):Int;
    public function get_maxScorllH():Int
    {
        return Std.int(this.width);
    }

    private var movePos:Point;
    private var scoringTime:Int = 0;

    public function new(layout:Layout){
        super(layout);
        isTouch = true;
        movePos = new Point();
        //竖向布局
        if(Std.is(layout,VerticalLayout))
        {
            this.useScorllV = true;
            this.useScorllH = false;
        }
    }

    override public function onFrame():Void
    {
        super.onFrame();
        if(scoringTime > 0)
            scoringTime --;
        if(isScoring)
        {
            movePos.x += (0 -  movePos.x)*0.1;
            movePos.y += (0 -  movePos.y)*0.1;
            this.horizontalScrollX += movePos.x;
            this.verticalScrollY += movePos.y;
            if(Std.int(movePos.x) == 0 && Std.int(movePos.y) == 0)
            {
                var moveV:Int = 0;
                var moveH:Int = 0;

                if(useScorllV){
                    //回正处理
                    var minV:Int = -maxScorllV + viewHeight;
                    if(minV > 0)
                        minV = 0;
                    if(this.verticalScrollY > 0)
                        moveV = Std.int((this.verticalScrollY - 0)*0.2);
                    else if(this.verticalScrollY < minV)
                        moveV = Std.int((this.verticalScrollY - minV)*0.2);
                    this.verticalScrollY -= moveV;
                }

                if(useScorllH){
                    var minH:Int = -maxScorllH + viewWidth;
                    if(minH > 0)
                        minH = 0;
                    if(this.horizontalScrollX > 0)
                        moveH = Std.int((this.horizontalScrollX - 0)*0.2);
                    else if(this.horizontalScrollX < minH)
                        moveH = Std.int((this.horizontalScrollX - minH)*0.2);
                    this.horizontalScrollX -= moveH;
                }
                
                if(moveV == 0 && moveH == 0)
                    isScoring = false;
                    
            }
            this.layout.canUpdate = true;
        }
    }

    override public function onTouchBegin(touch:Touch):Void
    {
        isScoring = false;
    }

    override public function onTouchMove(touch:Touch):Void
    {
        if(this.useScorllH){
            movePos.x = touch.globalX - touch.previousGlobalX;
            this.horizontalScrollX += touch.globalX - touch.previousGlobalX;
        }
        if(this.useScorllV){
            movePos.y = touch.globalY - touch.previousGlobalY;
            this.verticalScrollY += touch.globalY - touch.previousGlobalY;
        }
        this.layout.canUpdate = true;
        scoringTime = 10;
    }

    override public function onTouchEnd(touch:Touch):Void
    {
        isScoring = true;
        if(scoringTime == 0){
            movePos.x = 0;
            movePos.y = 0;
        }
    }

    



}