
data = { nodes={
    {
      children={
        {
          children={
            {
              children={
                {
                  children={
                    {
                      func="BuySugar",
                      name="Action_2",
                      type="Action",
                    },
                    {
                      func="BuyCar",
                      name="Action_3",
                      type="Action",
                    }
                  },
                  func="",
                  name="Loop_1",
                  type="Loop",
                }
              },
              func="HasMoney",
              name="Filter_1",
              type="Filter",
            },
            {
              func="Rest",
              name="Sleepy",
              type="Condition",
            },
            {
              func="GoHome",
              name="Action_3",
              type="Action",
            }
          },
          func="",
          name="Selector_1",
          type="Selector",
        }
      },
      func="",
      name="",
      type="Start",
    }
  },}

local BT = {}
local obj

--行为树的开始
--bt配置的行为树
--object 对象的实体
function b_tree.run(bt, object)
	obj = object
	local first_children = bt.nodes[1].children[1]
	BT[first_children.type](first_children)
end


-- Selector 节点
function BT.Selector(node)
	local return_value = false
	for _, child in ipairs(node.children) do
		if BT[child.type](child) == true then
			return_value = true
			break
		end
	end
	return return_value
end
-- Sequence 节点
function BT.Sequence(node)
	local return_value = true
	for _, child in ipairs(node.children) do
		if BT[child.type](child) == false then
			return_value = false
			break
		end
	end
	return return_value
end


-- Action 节点 执行动作事件返回true
function BT.Action(node)
	return obj[node.func]()
end
-- Condition 节点如果为真就执行action返回true 为假就返回false不执行action
function BT.Condition(node)
	if obj[node.name]() then
		obj[node.func]()
		return true
	else
		return false
	end
end

--choice action
--如果真就执行第一个子节点如果假就执行第二个子节点
function BT.Choice(node)
	if obj[node.func] then
		local first_children = node.children[1]
		if first_children then
			BT[first_children.type](first_children)
		else
			print('Choice node first children is nil');
		end
		return true
	else
		local second_children = node.children[2]
		if second_children then
			BT[second_children.type](second_children)
		else
			print('choice node second children is nil' )
		end
		return true
	end
end
-- Decorator Node

--SuccessAction
--执行本身成功之后执行子节点
function BT.SuccessAction(node)
	if obj[node.func]()then
		local first_children = node.children[1]
		if first_children then
			BT[first_children.type](first_children)
		else
			print('SuccessAction children is nil');
		end
		return true
	end
	return false
end

--loop节点循环执行节点知道有一个能执行返回true
function BT.Loop(node)
	local index = 1;
	local child;
	print('looping')
	repeat
		child = node.children[index]
		index = index + 1;
		if index > #node.children then
			index = 1;
		end
		print('looping')
	until BT[child.type](child)

	return true
end


-- Filter 如果为真就执行子节点返回true，为假就不执行子节点
function BT.Filter(node)
	if obj[node.func]() then
		local first_children = node.children[1]
		BT[first_children.type](first_children)
		return true
	else
		return false
	end
end

action_time = 0
local person =
{
	HasMoney = function() return true end,
	Sleepy = function()  return true  end,
	Rest = function() print('rest') end,
	BuyCar = function() 
	print('buy car') 
	action_time = action_time +1
	print(action_time)
	if action_time > 10 then 
		return true 
	else 
		return false
	end
	end,
	BuySugar = function() print('buy sugar') end,
	GoHome = function() print('go home') end,
}
--for i = 1, 2 do
	BT.run(data, person)
--end


