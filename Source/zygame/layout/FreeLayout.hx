package zygame.layout;

import zygame.layout.Layout;
import zygame.layout.LayoutChild;
import zygame.layout.FreeLayoutData;
import starling.display.DisplayObject;
import zygame.ui.LayoutDisplayObjectContainer;

/**
 *  自由布局
 */
class FreeLayout extends Layout {

    public function new(){

    }

    /**
     *  
     */
    override public function onUpdate(root:LayoutDisplayObjectContainer, arr:Array<LayoutChild>):Void
    {
        super.onUpdate(root,arr);
        var i:Int = 0;
        while(i < arr.length){
            var layoutChild:LayoutChild = arr[i];
            var layoutData:FreeLayoutData = cast(layoutChild.data,FreeLayoutData);

            //left centerX rigth
            if(!Math.isNaN(layoutData.left) && !Math.isNaN(layoutData.right)){ 
                layoutChild.child.x = root.horizontalScrollX + layoutData.left;
                layoutChild.child.width = root.viewWidth - (layoutData.left + layoutData.right);
            }
            else if(!Math.isNaN(layoutData.left)){ 
                layoutChild.child.x = root.horizontalScrollX + layoutData.left;
            }
            else if(!Math.isNaN(layoutData.right)){ 
                layoutChild.child.x = root.horizontalScrollX + root.viewWidth - (layoutChild.child.width - layoutChild.child.pivotX) - layoutData.right;
            }
            else if(!Math.isNaN(layoutData.centerX)){
                layoutChild.child.x = root.horizontalScrollX + root.viewWidth/2 - (layoutChild.child.width - layoutChild.child.pivotX) + layoutData.centerX;
            }

            //top centerY bottom
            if(!Math.isNaN(layoutData.top) && !Math.isNaN(layoutData.bottom)){ 
                layoutChild.child.y = root.verticalScrollY + layoutData.top;
                layoutChild.child.height = root.viewHeight - (layoutData.top + layoutData.bottom);
            }
            else if(!Math.isNaN(layoutData.top)){ 
                layoutChild.child.y = root.verticalScrollY + layoutData.top;
            }
            else if(!Math.isNaN(layoutData.bottom)){ 
                layoutChild.child.y = root.verticalScrollY + root.viewHeight - (layoutChild.child.height - layoutChild.child.pivotY) - layoutData.bottom;
            }
            else if(!Math.isNaN(layoutData.centerY)){
                layoutChild.child.y = root.verticalScrollY + root.viewHeight/2 - (layoutChild.child.width - layoutChild.child.pivotX) + layoutData.centerY;
            }

            i++;
        }
    }

}