package zygame.layout;

import zygame.layout.LayoutData;

class FreeLayoutData extends LayoutData
{
    public var left:Float = Math.NaN;
    public var right:Float = Math.NaN;
    public var top:Float = -Math.NaN;
    public var bottom:Float = Math.NaN;
    public var centerX:Float = Math.NaN;
    public var centerY:Float = Math.NaN;

    public function new(left:Float,right:Float,top:Float,bottom:Float,cx:Float,cy:Float)
    {
        super();
        this.left = left;
        this.right = right;
        this.top = top;
        this.bottom = bottom;
        this.centerX = cx;
        this.centerY = cy;
    }
}