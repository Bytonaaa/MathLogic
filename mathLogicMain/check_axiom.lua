local map
local  function check (tree_axiom, tree_expr)
  if (tree_axiom.operation == tree_expr.operation) then

    if (tree_axiom.operation == -1) then
      if (map[tree_axiom.variable]) then
        return map[tree_axiom.variable]:similar(tree_expr)
      else
        map[tree_axiom.variable] = tree_expr
        return true
      end
    elseif (tree_axiom.operation == 3) then
      return check(tree_axiom.left_node, tree_expr.left_node)
    else
      return check(tree_axiom.left_node, tree_expr.left_node) and check(tree_axiom.right_node, tree_expr.right_node)
    end
  elseif (tree_axiom.operation == -1) then
    if (map[tree_axiom.variable]) then
      return map[tree_axiom.variable]:similar(tree_expr);
    else
      map[tree_axiom.variable] = tree_expr;
      return true;
    end
  end
  return false;
end


return function(axiom, expr)
  map = { }
  return check(axiom, expr)
end