## graph format:
## [v1, v2, ...]:
## vertex v: [num, [num(v^a1), num(v^a1), ...]]
## where ai - generators of group

shreyer_gens := function(G, gens, n)
  local vertices, vert_graph, gens_graph, vert_num, gens_num, i, j, img;

  vertices := TreeLevelTuples(SphericalIndex(G), n);
  vert_num := Length(vertices);
  gens_num := Length(gens);
  vert_graph := List([1..vert_num], i -> [i]);
  gens_graph := List(gens, g->[]);

  for i in [1..vert_num] do
    for j in [1..gens_num] do
      img := Position(vertices, vertices[i]^gens[j]);
      Add(vert_graph[i], img);
      Add(gens_graph[j], [i, img]);
    od;
  od;

  return gens_graph;
end;

shreyer := function(G, n)
  return shreyer_gens(G, GeneratorsOfGroup(G), n);
end;
