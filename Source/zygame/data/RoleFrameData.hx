package zygame.data;

import zygame.data.RoleFrameActionGroup;
import nape.geom.Vec2;
import zygame.utils.NapeUtils;
import zygame.data.BeHitData;
import zygame.data.EffectData;
import zygame.data.FrameData;

/**
 *  每帧的数据
 */
class RoleFrameData extends FrameData{
    
    /**
     *  纹理名字
     */
    public var textureName:String;

    /**
     *  显示对象的坐标X
     */
    public var x:Int;

    /**
     *  显示对象的坐标Y
     */
    public var y:Int;

    /**
     *  是否有停顿点
     */
    public var stop:Bool = false;

    /**
     *  原始的移动值
     */
    public var gox:Float;
    public var goy:Float;

    /**
     *  移动X轴
     */
    public var moveX:Float;

    /**
     *  移动Y轴
     */
    public var moveY:Float;

    public var hitPoint:Array<Vec2>;

    /**
     *  识别ID：动作组+帧ID
     */
    public var id:String;

    /**
     *  组
     */
    public var actionGroup:RoleFrameActionGroup;

    /**
     *  攻击数据
     */
    public var beHitData:BeHitData;

    /**
     *  特效数据
     */
    public var effectDatas:Array<EffectData>;

    public function new(xml:Xml,group:RoleFrameActionGroup){
        super();
        actionGroup = group;
        textureName = xml.get("name");
        stop = xml.get("stop") == "stop";
        gox = Std.parseFloat(xml.get("gox"));
        goy = Std.parseFloat(xml.get("goy"));
        var lastFrame:RoleFrameData = null;
        if(group.frames.length > 0)
            lastFrame = group.frames[group.frames.length - 1];
        if(lastFrame != null){
            moveX = lastFrame.gox - gox;
            moveY = lastFrame.goy - goy; 
        }
        else
        {
            moveX = gox;
            moveY = goy;
        }
        moveX = -moveX;
        //碰撞数据
        var hitData:String = xml.get("hitPoint");
        if(hitData != null){
            hitPoint = NapeUtils.parsingPoint(hitData);
            beHitData = new BeHitData(this);
            beHitData.hitX = Std.parseFloat(xml.get("hitX"));
            beHitData.hitY = Std.parseFloat(xml.get("hitY"));
            beHitData.straight = Std.parseInt(xml.get("straight"));
            beHitData.hitEffect = Std.parseInt(xml.get("hitEffect"));
        }
        at = group.frames.length;
        id = group.actionName + at;
        //解析特效数据
        var effectString:String = xml.get("effects");
        if(effectString != null && effectString != "[]")
        {
            effectDatas = [];
            var arr:Array<Dynamic> = haxe.Json.parse(effectString);
            var arrIndex:Int = 0;
            while(arrIndex < arr.length)
            {
                effectDatas.push(new EffectData(arr[arrIndex]));
                arrIndex ++;
            }
        }
    }

}