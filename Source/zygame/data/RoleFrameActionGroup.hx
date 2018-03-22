package zygame.data;

import zygame.data.RoleFrameData;
import zygame.data.RoleData;

/**
 *  角色动作组，管理一个动作的每一帧事件
 */
class RoleFrameActionGroup {

    /**
     *  动作长度
     */
    private var _length:Int;

    /**
     *  每帧的数据
     */
    public var frames:Array<RoleFrameData>;

    /**
     *  角色数据
     */
    public var roleData:RoleData;

    /**
     *  允许跳跃打断
     */
    public var allowJump:Bool = false;

    /**
     *  允许空中技能自由移动
     */
    public var allowJumpMove:Bool = false;

    /**
     *  动作名
     */
    public var actionName:String;

    public function new(xml:Xml,data:RoleData)
    {
        roleData = data;
        frames = [];
        _length = 0;
        var childs:Iterator<Xml> = xml.elements();
        while(childs.hasNext())
        {
            _length++;
            var frame:Xml = childs.next();
            frames.push(new RoleFrameData(frame,this));
        }
        actionName = xml.get("name");
        if(actionName == "普通攻击")
        {
            allowJump = true;
        }
        if(actionName == "空中攻击")
        {
            allowJumpMove = true;
        }
    }

    /**
     *  可直接获取动作长度
     *  @return Int
     */
    public function count():Int
    {
        return _length;
    }

}