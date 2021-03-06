page =  null
edit-page = null
main-manage = let
    
    _all-roles = null

    _new-btn-dom = $ "\#staff-role-main .new-btn"
    _table-body-dom = $ ".sr-container-table > tbody"

    _all-permission = ['餐品增删改','餐品操作','单品优惠','（待定）',
    '活动发布','订单优惠','会员','优惠券', '会员设置','（待定）','（待定）',
    '流水订单','数据统计','营销分析','（待定）','（待定）',
    '业务管理','店员管理','餐厅信息修改','查看敏感操作','（待定）','（待定）',
    '接单','辅助点单','会员充值','修改积分','退款','重打订单','打印日结小票','（待定）','（待定）']

    _all-tbd-index = [3, 9, 10, 14, 15, 20, 21, 29, 30]
    _zero-permission = 1613809160 # 1100000001100001100011000001000

    _new-btn-click-event = !->
        page.toggle-page 'new'
    
    _edit-btn-click-event = (role)->
        edit-page.get-role-and-init role
        page.toggle-page 'edit'

    _delete-btn-click-event = (role) ->
        if confirm "是否确定删除该角色"
            $.ajax {type: "POST", url: "/Waiter/Role/Remove/"+role.id,\
                dataType: 'JSON', contentType: "application/json", success: _delete-post-success, error: _delete-post-fail}
            role.delete-method-dom.unbind "click"

    _delete-post-success = (data) !->
        if data.message === "Waiter role not found"
            alert "未找到该角色"
        if data.message === "Cannot remove role with waiter still using"
            alert "还有员工使用此角色，无法删除"
        location.reload!

    _delete-post-fail = (data)!->
        alert "请求删除角色失败"
        location.reload!
    
    class Role
        (id, name, permission, permanent) ->
            @id = id
            @name = name
            @permission = permission
            @permanent = permanent
            @gene-dom!
            @set-dom-value!
            @init-event!
            @gene-permission-string!

        gene-permission-string: !->
            permission-string = []
            break-point = [4,7,5,6,9]
            permission-value = (_zero-permission .|. @permission )
            binary-string = permission-value.to-string 2
            level = 0
            count = break-point[level]
            permission-level = []
            for i from binary-string.length-1 to 0 by -1
                count -= 1
                if count === 0
                    permission-string.push permission-level
                    permission-level = []
                    level += 1
                    count = break-point[level]
                if binary-string.length-1-i in _all-tbd-index
                    continue
                if binary-string[i] === '1'
                    permission-level.push _all-permission[binary-string.length-1-i]
            @permission-dom.text ''
            for string-array in permission-string
                if string-array.length > 0
                    string = string-array.join '，'
                    @permission-dom.append $ "<div>"+string+"</div>"

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
            else
                if @permission !== 2147483647
                    @edit-method-dom = $ "<div class='method-container'>
                    <icon class='edit-icon'></icon>
                    <p>修改</p>
                    </div>"
                    @method-dom.append @edit-method-dom
            @tr-dom.append @method-dom
            _table-body-dom.append @tr-dom
        
        init-event : !->
            if @permanent === false
                @edit-method-dom.click !~> _edit-btn-click-event @
                @delete-method-dom.click !~> _delete-btn-click-event @
            else
                if @permission !== 2147483647
                    @edit-method-dom.click !~> _edit-btn-click-event @
    
    _init-all-role = !->
        for role in _all-roles
            role_ = new Role role.id,role.name,role.auth,role.permanent

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