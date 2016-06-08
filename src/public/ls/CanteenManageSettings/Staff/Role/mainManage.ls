page =  null
edit-page = null
main-manage = let
    
    _all-roles = null

    _new-btn-dom = $ "\#staff-role-main .new-btn"
    _table-body-dom = $ ".sr-container-table > tbody"

    _all-permission = ['编辑餐牌','隐藏、显示、移动、排序餐品或品类','（待定）','（待定）',
    '活动管理','订单优惠','会员','卡券', '搭配推荐','（待定）','（待定）',
    '流水订单','数据统计','营销分析','（待定）','（待定）',
    '业务管理','店员管理','餐厅信息修改','餐厅日志','（待定）','（待定）',
    '接单处理','辅助点餐','会员充值','修改积分','退款','重打某单','打印日结','（待定）','（待定）']

    _all-tbd-index = [2, 3, 9, 10, 14, 15, 20, 21, 29, 30]

    _new-btn-click-event = !->
        page.toggle-page 'new'
    
    _edit-btn-click-event = (role)->
        edit-page.get-role-and-init role
        page.toggle-page 'edit'

    _delete-btn-click-event = (role) ->
        $.ajax {type: "POST", url: "/Waiter/Role/Remove/"+role.id, dataType: 'JSON', success: _delete-post-success}

    _delete-post-success = (data) !->
        if data.message === "success"
            location.reload!
        else if data.message === "Waiter role not found"
            alert "未找到该角色"
        else if data.message === "Cannot remove role with waiter still using"
            alert "还有员工使用此角色，无法删除"
    
    class Role
        (id, name, type, permission, permanent) ->
            @id = id
            @name = name
            @type = type
            @permission = permission
            @permanent = permanent
            @gene-dom!
            @set-dom-value!
            @init-event!
            @gene-permission-string!

        gene-permission-string: !->
            permission-string = []
            binary-string = @permission.to-string 2
            console.log binary-string
            for i from binary-string.length-1 to 0 by -1
                if binary-string.length-1-i in _all-tbd-index
                    continue
                if binary-string[i] === '1'
                    permission-string.push _all-permission[binary-string.length-1-i]
            @permission-dom.text permission-string.join '，'

        set-dom-value: !->
            @name-dom.text @name
            if @permanent
                @type-dom.text "系统"
            else
                @type-dom.text "自定义"
            @permission-dom.text @permission
        
        gene-dom : !->
            @tr-dom = $ "<tr></tr>"
            @name-dom = $ "<td class='td-name'></td>"
            @tr-dom.append @name-dom
            @type-dom = $ "<td class='td-type'></td>"
            @tr-dom.append @type-dom
            @permission-dom = $ "<td class='td-permission'></td>"
            @tr-dom.append @permission-dom
            @method-dom = $ "<td class='td-method'></td>"
            if @permanent === false    
                @edit-method-dom = $ "<div class='method-container'>
                <icon class='edit-icon'></icon>
                <p>修改</p>
                </div>"
                @delete-method-dom = $ "<div class='method-container'>
                <icon class='delete-icon'></icon>
                <p>删除</p>
                </div>"
                @method-dom.append @edit-method-dom
                @method-dom.append @delete-method-dom
            @tr-dom.append @method-dom
            _table-body-dom.append @tr-dom
        
        init-event : !->
            if @permanent === false
                @edit-method-dom.click !~> _edit-btn-click-event @
                @delete-method-dom.click !~> _delete-btn-click-event @
    
    _init-all-role = !->
        for role in _all-roles
            console.log role
            role_ = new Role role.id,role.name,role.type,role.auth,role.permanent

    _init-depend-module = !->
        page := require "./pageManage.js"
        edit-page := require "./editManage.js"
        
    _init-event = !->
        _new-btn-dom.click !-> _new-btn-click-event!
    
    initial: (_get-role-JSON)!->
        _all-roles := JSON.parse _get-role-JSON!
        _init-all-role!
        _init-depend-module!
        _init-event!


module.exports = main-manage