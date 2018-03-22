package zygame.layout;

import zygame.layout.Layout;
import zygame.ui.LayoutDisplayObjectContainer;
import zygame.layout.LayoutChild;
import zygame.layout.VerticalLayoutData;
import zygame.ui.ListView;
import zygame.ui.ListItemRender;

/**
 *  竖向的布局排版
 */
class VerticalLayout extends Layout {

    /**
     *  水平对齐线
     */
    public var horizontalAlign:String = "left";

    /**
     *  上下间隔
     */
    public var gap:Int = 0;

    public function new(align:String = "left")
    {
        horizontalAlign = align;
    }

    override public function onUpdate(root:LayoutDisplayObjectContainer,arr:Array<LayoutChild>):Void
    {
        if(Std.is(root,ListView))
        {
            this.onListUpdate(cast(root,ListView),arr);
            return;
        }
        super.onUpdate(root,arr);
        var i:Int = 0;
        var iy:Float = 0;
        while(i < arr.length)
        {
            var layoutChild:LayoutChild = arr[i];
            var layoutData:VerticalLayoutData = cast(layoutChild.data,VerticalLayoutData);
            align(root,layoutChild);
            layoutChild.child.width = root.viewWidth;
            layoutChild.child.y = root.verticalScrollY + iy; 
            iy += layoutData.getHeight(layoutChild.child) + gap;
            i++;
        }
    }

    private function onListUpdate(root:ListView,arr:Array<LayoutChild>):Void
    {
        var item:ListItemRender = null;
        if(arr.length == 0)
        {
            item = root.createItem();
            root.addChildToLayout(item,root.layoutData);
        }
        else
        {
            item = cast(arr[0].child,ListItemRender);
        }

        //计算出当前第一个组件的索引
        var index:Int = -Std.int(root.verticalScrollY/item.height);
        if(index < 0)
            index = 0;

        //数组后移或者前移
        var moveArrayIndex:Int = item.getIndex() - index;
        var moveItem:LayoutChild = null;

        //计算出第一个渲染组件的索引坐标
        var startY:Float = index * item.height;
        if(startY > root.maxScorllV - root.viewHeight){
            startY = root.maxScorllV - root.viewHeight;
            moveArrayIndex = 0;
            index = item.getIndex();
        }

        if(moveArrayIndex < 0)
        {
            //左边往后面丢
            moveArrayIndex *= -1;
            while(moveArrayIndex > 0)
            {
                moveItem = arr.shift();
                arr.push(moveItem);
                moveArrayIndex --;
            }
        }
        else if(moveArrayIndex > 0)
        {
            //右边往前面丢
            while(moveArrayIndex > 0)
            {
                moveItem = arr.pop();
                arr.insert(0,moveItem);
                moveArrayIndex --;
            }
        }

        //计算出所需的组件数量，并生成
        var itemCount:Int = Std.int(root.viewHeight/item.height) + 1;
        var i:Int = arr.length;
        while(i < itemCount)
        {
            root.addChildToLayout(root.createItem(),root.layoutData);
            i++;
        }

        //开始计算排版
        i = 0;
        var iy:Float = startY;
        while(i < arr.length)
        {
            var layoutChild:LayoutChild = arr[i];
            item = cast(layoutChild.child,ListItemRender);
            if(index + i < root.listData.length)
            {
                item.visible = true;
                if(item.getIndex() != index + 1)
                {
                    item.setIndex(index + i);
                    item.setData(root.listData.at(item.getIndex()));
                }
            }
            else
            {
                item.visible = false;
            }
            var layoutData:VerticalLayoutData = cast(layoutChild.data,VerticalLayoutData);
            align(root,layoutChild);
            layoutChild.child.width = root.viewWidth;
            layoutChild.child.y = root.verticalScrollY + iy; 
            iy += layoutData.getHeight(layoutChild.child) + gap;
            i++;
        }

    }

    private function align(root:LayoutDisplayObjectContainer,layoutChild:LayoutChild):Void
    {
        switch(horizontalAlign)
        {
            case "left":
                layoutChild.child.x = root.horizontalScrollX;
            case "center":
                layoutChild.child.x = root.horizontalScrollX + root.viewWidth/2 - layoutChild.child.width/2;
            case "right":
                layoutChild.child.x = root.horizontalScrollX + root.viewWidth - layoutChild.child.width;
        }
    }

}