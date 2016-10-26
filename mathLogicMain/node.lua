local node_table = { }
local node_meta = { }
node_meta.__index = node_meta

  function hash_str (str) 
    hash = 0
    for i = 1, #str do
      hash = (hash*51 + string.byte(str, i)*101) % 1000000007
    end
    return hash % 1000000007
  end
  
  
  function node_table:new (operation, left_node, right_node, variable) 
    
    local obj = { }
    obj.left_node = left_node
    obj.right_node = right_node
    obj.operation = operation or -1
    obj.variable = variable or ""
    
    local str_left = ""
    local str_right = ""
    local str_var = ""
    
    if (left_node) then
      str_left = left_node.hash
    end
    
    if (right_node) then
      str_right = right_node.hash
    end
    
    if (variable) then
      str_var = variable
    end
    
    obj.hash = str_left .. str_var .. str_right
    obj.hash_eq = hash_str(obj.hash)
    setmetatable(obj, node_meta)
    return obj
  end


  function node_meta:equal(node)
    if (self.operation ~= node.operation or self:hash_equal() ~= node:hash_equal()) then
      return false
    end
    if (self.operation == -1) then
      return self.variable == node.variable
    else
      return self.left_node:equal(node.left_node) and (self.operation == 3 or self.right_node:equal(node.right_node))
    end

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

  function node_meta:hash_equal()
    if (not self.hash_eq) then
      self.hash_eq = hash_str(self.hash)
    end
    return self.hash_eq
  end
  
  function node_meta:string() 
    return self.hash
  end

return node_table