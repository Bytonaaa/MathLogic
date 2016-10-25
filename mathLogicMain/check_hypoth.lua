return  function (tree_hyp, tree_expr)
  if (tree_hyp.operation == tree_expr.operation) then
    if (tree_hyp.operation == -1) then
      if (tree_hyp.variable == tree_expr.variable) then
        return true
      else
        return false
      end
    elseif (tree_hyp.operation == 3) then
      return check(tree_hyp.left_node,tree_expr.left_node);
    else
      return check(tree_hyp.left_node, tree_expr.left_node) and check(tree_hyp.right_node, tree_expr.right_node);
    end
  else 
    return false
  end
end