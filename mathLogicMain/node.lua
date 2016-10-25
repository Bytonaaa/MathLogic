local node_table = { }
local node_meta = { }
node_meta.__index = node_meta

  function node_table:new (operation, left_node, right_node, variable) 
    
    local obj = { }
    obj.left_node = left_node
    obj.right_node = right_node
    obj.operation = operation or -1
    obj.variable = variable or ""
    
    setmetatable(obj, node_meta)
    return obj
  end


  function node_meta:similar(node)
    
    
    if (self.operation ~= node.operation) then
      return false
    end
    
    if (self.operation == -1) then
      
      if (self.variable == node.variable) then
        return true
      else
        return false
      end
    elseif (self.operation == 3) then
      return self.left_node:similar(node.left_node)
    else
      local left_bool = self.left_node:similar(node.left_node)
      local right_bool = self.right_node:similar(node.right_node)
      return left_bool and right_bool
    end

  end

  function node_meta:equal(node)
    if (node == nil or self.operation ~= node.operation or self.variable ~= node.variable) then
      return false
    end
    
    local left_b = false
    local right_b = false
    
    if (self.left_node ~= nil) then
      left_b = self.left_node:equal(node.left_node)
    else
      left_b = not node.left_node
    end
    
    if (self.right_node ~= nil) then

      right_b = self.right_node:equal(node.right_node)
    else
      right_b = not node.right_node
    end
    
    return left_b and right_b
  end
  
  function node_meta:output() 
    print("operation: "..self.operation.." variable: ".. self.variable)
    if (self.left_node) then
      print("Left child start")
      self.left_node:output()
      print("Left child end")
    end
    
    if (self.right_node) then
      print("Right child start")
      self.right_node:output()
      print("Right child end")
    end    
  end

  function node_meta:string() 
    local s = "operation"..self.operation.."variable:".. self.variable
    if (self.left_node) then

      s = s  .. self.left_node:string()
    end
    
    if (self.right_node) then
      s = s ..self.right_node:string()
    end    
    return s
  end

return node_table