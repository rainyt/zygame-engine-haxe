package zygame.data;

import zygame.data.SpriteData;

/**
 *  精灵表帧管理
 */
class SpriteDataManager {

    private var dict:Map<String,SpriteData>;

    public function new(){
        dict = new Map<String,SpriteData>();
    }

    public function parsingTextureAlats(id:String,xml:Xml):Void
    {
        if(dict.get(id) != null)
        {
            return;
        }
        trace("新增SpriteData"+id);
        dict.set(id,new SpriteData(id,xml));
    }

    /**
     *  获取精灵表数据
     *  @param id - 角色ID
     *  @return RoleData
     */
    public function getSpriteData(id:String):SpriteData
    {
        return dict.get(id);
    }

}