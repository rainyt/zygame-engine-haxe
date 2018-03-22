package zygame.data;

import zygame.data.RoleFrameActionGroup;

class RoleData {

    /**
     *  绑定的角色ID
     */
    public var id:String;

    /**
     *  解析的XML动作组
     */
    public var actions:Map<String,RoleFrameActionGroup>;

    public function new(id:String,xml:Xml)
    {
        this.id = id;
        actions = new Map<String,RoleFrameActionGroup>();
        var childs:Iterator<Xml> = xml.elementsNamed("action");
        var xmlactions:Iterator<Xml> = childs.next().elementsNamed("act");
        while(xmlactions.hasNext())
        {
            var child:Xml = xmlactions.next();
            actions.set(child.get("name"),new RoleFrameActionGroup(child,this));
        }
    }

}