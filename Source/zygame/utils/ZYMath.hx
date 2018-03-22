package zygame.utils;

import nape.geom.Vec2;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class ZYMath{

    private static var _vec2:Vec2;

    private static var _pos2:Point;

    private static var _rect4:Rectangle;

    /**
     *  转换为角度
     *  @param rad - 
     *  @return Float
     */
    public static function rad2deg(rad:Float):Float
    {
        return rad / Math.PI * 180.0;            
    }

    /** 
     *  转换为弧度
     */
    public static function deg2rad(deg:Float):Float
    {
        return deg / 180.0 * Math.PI;   
    }

    /**
     *  转换成名字，不带路径和后缀
     *  @param str - 
     *  @return String
     */
    public static function toName(str:String):String
    {
        if(str.indexOf("/")!=-1)
            str = str.substr(str.lastIndexOf("/") + 1);
        if(str.indexOf(".")!=-1)
            str = str.substr(0,str.lastIndexOf("."));
        return str;
    }

    public static function vec2(x:Float = 0,y:Float = 0):Vec2
    {
        if(_vec2 == null)
            _vec2 = new Vec2();
        _vec2.x = x;
        _vec2.y = y;
        return _vec2;
    }

    public static function lastPos():Point
    {
        return _pos2;
    }

    public static function pos(x:Float = 0,y:Float = 0):Point
    {
        if(_pos2 == null)
            _pos2 = new Point();
        _pos2.x = x;
        _pos2.y = y;
        return _pos2;
    }

    public static function rect(x:Float,y:Float,w:Float,h:Float):Rectangle
    {
        if(_rect4 == null)
            _rect4 = new Rectangle();
        _rect4.x = x;
        _rect4.y = y;
        _rect4.width = w;
        _rect4.height = h;
        return _rect4;
    }

}