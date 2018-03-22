package zygame.data;

import zygame.data.RoleData;

/**
 *  角色数据管理，解析完毕的资源将会解析到这里
 */
class RoleDataManager {

    private var dict:Map<String,RoleData>;

    public function new(){
        dict = new Map<String,RoleData>();
    }

    /**
     *  解析指定角色的动作数据
     *  @param id - 角色ID
     *  @param xml - 角色动作数据
     */
    public function parsingRoleData(id:String,xml:Xml):Void
    {
        if(dict.get(id) != null)
        {
            return;
        }
        dict.set(id,new RoleData(id,xml));
    }

    /**
     *  获取角色数据
     *  @param id - 角色ID
     *  @return RoleData
     */
    public function getRoleData(id:String):RoleData
    {
        return dict.get(id);
    }
}