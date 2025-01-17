local function check (tree_hyp, tree_expr)
  
  if (tree_hyp.operation ~= tree_expr.operation) then
    return false
  end
  
  if (tree_hyp.operation == -1) then
    return tree_hyp.variable == tree_expr.variable
  end
    
  return check(tree_hyp.left_node, tree_expr.left_node) 
    and (tree_hyp.operation == 3 or check(tree_hyp.right_node, tree_expr.right_node));  
  
end

return check