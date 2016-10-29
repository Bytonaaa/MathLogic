local nodes = require "node"
local lexem_types = {
  lopen = 0,
  lclose = 1,
  lend = 2,
  lvariable = 3,
  lnot = 4,
  land = 5,
  lor = 6,
  limpl = 7
}
local index = 1;
local pattern = "[a-zA-Z][a-zA-Z0-9]*"
local expr = ""
local parser

local switcher = { 
  ['('] = function () return "(", lexem_types.lopen end,
  [')'] = function () return ")", lexem_types.lclose end,
  ['&'] = function () return "&", lexem_types.land end,
  ['|'] = function () return "|", lexem_types.lor end,
  ['-'] = function () return "->", lexem_types.limpl end,
  ['!'] = function () return "!", lexem_types.lnot end,
  ["default"] = function () return nil end

}

local function get_next_lexem() 
  if (index > #expr) then
    return nil, lexem_types.lend
  end

  local char_at = string.byte(expr, index) 
  if (char_at - string.byte('A') >= 0 and char_at - string.byte('A') <= 32) then
    local m = string.match(expr, pattern, index)
    index = index + #m
    return m, lexem_types.lvariable
  end


  if (switcher[string.char(char_at)]) then
    
    local str, lex = switcher[string.char(char_at)]()
    if (str ~=nil) then
      index = index + #str
    end
    return str, lex
  else
    return switcher["default"]()
  end
end

local function expressionBalance  (stack_var, stack_op) 
  while (#stack_op ~= 0) do
    local operation = table.remove(stack_op)
    local secondVariable
    local firstVariable = table.remove(stack_var)
    if (operation.operation ~= 3) then
      secondVariable, firstVariable = firstVariable, table.remove(stack_var)
    end
    table.insert(stack_var, nodes:new(operation.operation, firstVariable, secondVariable));
  end
  return table.remove(stack_var);
end


local switcher_lexem = { 
  [lexem_types.lopen] = function (stack_var) table.insert(stack_var, parser()) end,
  [lexem_types.lclose] = function (stack_var, stack_op) return expressionBalance(stack_var, stack_op) end,
  [lexem_types.lend] = function (stack_var, stack_op) 
    if (#stack_op ~=0) then 
      return expressionBalance(stack_var, stack_op) 
    else 
      return stack_var[1] 
    end 
  end,
  [lexem_types.lvariable] = function (stack_var, stack_op, cur_lex) table.insert(stack_var, nodes:new(nil, nil, nil, cur_lex)) end,
  [lexem_types.lnot] = function(stack_var, stack_op) table.insert(stack_op, nodes:new(3)) end,
  [lexem_types.land] = function(stack_var, stack_op)
    if (#stack_op~=0 and stack_op[1].operation >= 2) then
      while (#stack_op~=0 and stack_op[1].operation == 3) do
        local operation = table.remove(stack_op)
        local firstVariable = table.remove(stack_var)
        table.insert(stack_var, nodes:new(operation.operation, firstVariable, nil, nil))
      end
      while (#stack_op~=0 and stack_op[1].operation >= 2) do
        local operation = table.remove(stack_op)
        if (operation.operation ~= 3) then
          local secondVariable = table.remove(stack_var)
          local firstVariable = table.remove(stack_var)
          table.insert(stack_var, nodes:new(operation.operation, firstVariable, secondVariable));
        else 
          local firstVariable = table.remove(stack_var)
          table.insert(stack_var,nodes:new(operation.operation, firstVariable));
        end
      end
    end
    table.insert(stack_op, nodes:new(2));
  end,
  
  
  [lexem_types.lor] = function(stack_var, stack_op)
      while (#stack_op~=0 and stack_op[1].operation == 3) do
        local operation = table.remove(stack_op)
        local firstVariable = table.remove(stack_var)
        table.insert(stack_var,nodes:new(operation.operation, firstVariable, nil, nil))
      end
      while (#stack_op~=0 and stack_op[1].operation >= 1) do
        local operation = table.remove(stack_op)
        if (operation.operation ~= 3) then
          local secondVariable = table.remove(stack_var)
          local firstVariable = table.remove(stack_var)
          table.insert(stack_var, nodes:new(operation.operation, firstVariable, secondVariable))
        else 
          local firstVariable = table.remove(stack_var)
          table.insert(stack_var, nodes:new(operation.operation, firstVariable))
        end
      end
    table.insert(stack_op, nodes:new(1));
    
  end,
  
  
  [lexem_types.limpl] = function(stack_var, stack_op)
    while (#stack_op~=0 and stack_op[1].operation == 3) do
        local operation = table.remove(stack_op)
        local firstVariable = table.remove(stack_var)
        table.insert(stack_var, nodes:new(operation.operation, firstVariable, nil, nil))
      end
      
      while (#stack_op~=0 and stack_op[1].operation >= 1) do
        local operation = table.remove(stack_op)
        if (operation.operation ~= 3) then
          local secondVariable = table.remove(stack_var)
          local firstVariable = table.remove(stack_var)
          table.insert(stack_var, nodes:new(operation.operation, firstVariable, secondVariable))
        else 
          local firstVariable = table.remove(stack_var)
          table.insert(stack_var, nodes:new(operation.operation, firstVariable))
        end
      end
    table.insert(stack_op, nodes:new(0))
  end

}

parser = function ()
  
  
  local stack_var = { }
  local stack_op = { }
  
  while (true) do
    
    local str, lexem = get_next_lexem()
    local data = switcher_lexem[lexem](stack_var, stack_op, str)
    
    if (data ~= nil) then
      return data
    end
    
  end
  
  
end

return function (exp) 
  index = 1
  expr = exp
  return parser()
end
