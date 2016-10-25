local axioms = require "axioms"
local check_axiom = require "check_axiom"
local check_hypoth = require "check_hypoth"
local parser = require "parser"

local hypothnes = { }
local all_tree_to_expr = { }
local all_tree_by_expr = { }
local all_right_impl = { }

local all_axiom_trees = { }
local all_hypoth_trees = { }
local all_expressions = { }

local function build_trees()
  for i, val in ipairs(axioms) do
    table.insert(all_axiom_trees, parser(val))
  end
  
  for i, val in ipairs(hypothnes) do
    table.insert(all_hypoth_trees, parser(val))
  end
end


local function readExpression(reader)
  str = reader:read()
  while (str ~= nil) do
    table.insert(all_expressions, str)
    str = reader:read()
  end
end


local function check_on_axiom(tree) 
  num = 1
  for key, val in ipairs(all_axiom_trees) do
    if (check_axiom(val, tree)) then
      return num
    end
    num = num + 1
  end
  return -1
end

local function check_on_hyp(tree)
  
end

local function workingWithTrees(tree, num)
  all_tree_to_expr[num] = tree
  all_tree_by_expr[tree:string()] = num
  if (tree.operation == 0) then
    if (all_right_impl[tree.right_node:string()]) then
      table.insert(all_right_impl[tree.right_node:string()], num)
    else
    temp = { num }
    all_right_impl[tree.right_node:string()] = temp
    end
  end
end


local function main(arg)

  file_in = io.input("tasks")
  file_out = io.output("ans")
  readExpression(file_in)
  
  build_trees()
  
  number = 0
  
  for key, val in ipairs(all_expressions) do
    is_proof = false 
    number = number + 1
    tree_expr = parser(val)
    num_ax = check_on_axiom(tree_expr)
    
    if (num_ax ~= -1) then
      workingWithTrees(tree_expr, number)
      file_out:write('(' .. number .. ')' .. val .. '(Сх. акс. ' .. num_ax .. ')\n')
      is_proof = true
    else 

      if (all_right_impl[tree_expr:string()]) then
        temp = all_right_impl[tree_expr:string()]
        for keyz, inte in ipairs(temp) do
          bool = false
          for keyzz, ex in ipairs(all_tree_to_expr) do 
            if (ex:equal(all_tree_to_expr[inte].left_node)) then
              bool = true
              break
            end
          end
          
          
          if (bool) then
            workingWithTrees(tree_expr, number)
            print("number: " .. number .. " value: ".. val)
            file_out:write('('..number..')'..val .. ' (M. P. ' .. all_tree_by_expr[all_tree_to_expr[inte].left_node:string()] .. ', ' ..  inte .. ')\n')
            is_proof = true
            break
          end
        end
      end
    end
    
    if (not is_proof) then
      file_out:write('(' .. number .. ') ' .. val .. ' ( не доказано )')
      return
    end
  end
  
  file_in.close()
  file_out.close()
end


main(arg)
