#############################################################################
##
#W  selfs.gi             automgrp package                      Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##



InstallGlobalFunction(ReduceWord,
function(v)
  local i, b;
  b := [];
  for i in [1..Length(v)] do
    if v[i] <> 1 then
      Add(b, v[i]);
    fi;
  od;
  return b;
end);


InstallGlobalFunction(ProjectWord, function(w, s, G)
  local i, perm, d, proj;
  d := Length(G[1])-1;
  if s > d or s < 1 then
    Error("Incorrect index of a subtree");
  fi;
  proj := [];
  perm := ();
  for i in [1..Length(w)] do
    Add(proj, G[w[i]][s^perm]);
    perm := perm*G[w[i]][d+1];
  od;
  return proj;
end);


InstallGlobalFunction(WordActionOnFirstLevel, function(w, G)
  local i, perm, d;
  d := Length(G[1])-1;
  perm := ();
  for i in [1..Length(w)] do perm := perm*G[w[i]][d+1]; od;
  return perm;
end);


InstallGlobalFunction(WordActionOnVertex, function(w, ver, G)
  local i, cur_w, new_ver, perm;
  new_ver := [];
  cur_w := ShallowCopy(w);
  for i in [1..Length(ver)] do
    perm := WordActionOnFirstLevel(cur_w, G);
    new_ver[i] := ver[i]^perm;
    cur_w := ProjectWord(cur_w, ver[i], G);
  od;
  return new_ver;
end);


InstallMethod(OrbitOfVertex, "for [IsList, IsTreeHomomorphism, IsCyclotomic]", true, [IsList, IsTreeHomomorphism, IsCyclotomic],
function(ver, g, n)
  local i, ver_tmp, orb;
  i := 0; orb := [];
  ver_tmp := ver;
  while i < n and (ver <> ver_tmp or i = 0) do
    Add(orb, ver_tmp);
    ver_tmp := ver_tmp^g;
    i := i+1;
  od;
  return orb;
end);


InstallMethod(OrbitOfVertex, "for [IsList, IsTreeHomomorphism]", [IsList, IsTreeHomomorphism],
function(ver, g)
  return OrbitOfVertex(ver, g, infinity);
end);


InstallMethod(OrbitOfVertex, "for [IsString, IsTreeHomomorphism, IsCyclotomic]", true, [IsString, IsTreeHomomorphism, IsCyclotomic],
function(ver, g, n)
  local i, ver_tmp, orb, ch;

  ver_tmp := [];
  for i in [1..Length(ver)] do
    ch := Int(String([ver[i]]));
    if ch < 1 or ch > g!.deg then
      Error("received string ", ver, " does not represent a valid vertex");
    fi;
    Add(ver_tmp, ch);
  od;
  ver := ver_tmp;

  i := 0; orb := [];
  ver_tmp := ver;
  while i < n and (ver <> ver_tmp or i = 0) do
    Add(orb, ver_tmp);
    ver_tmp := ver_tmp^g;
    i := i+1;
  od;
  return orb;
end);


InstallMethod(OrbitOfVertex, "for [IsString, IsTreeHomomorphism]",
              [IsString, IsTreeHomomorphism],
function(ver, g)
  return OrbitOfVertex(ver, g, infinity);
end);


InstallMethod(PrintOrbitOfVertex, "for [IsList, IsTreeHomomorphism, IsCyclotomic]",
             [IsList, IsTreeHomomorphism, IsCyclotomic],
function(ver, w, n)
  local orb, i, j;
  orb := OrbitOfVertex(ver, w, n);
  if w!.deg = 2 then
    for i in [1..Length(orb)] do
      for j in [1..Length(orb[1])] do
        #  Print(orb[i][j]);
        if orb[i][j] = 1 then Print(" "); else Print("x"); fi;
      od;
      Print("\n");
    od;
  else
     for i in [1..Length(orb)] do
      for j in [1..Length(orb[1])] do
        Print(orb[i][j]);
      od;
      Print("\n");
    od;
  fi;
end);

InstallMethod(PrintOrbitOfVertex, "for [IsString, IsTreeHomomorphism]", [IsList, IsTreeHomomorphism],
function(ver, g)
  PrintOrbitOfVertex(ver, g, infinity);
end);


InstallGlobalFunction(IsOneWordSelfSim, function(w, G)
  local i, IsOneWordIter, ReachedWords, d;

  IsOneWordIter := function(v)
  local i, j, perm;
    if v in ReachedWords then return true;
    else
      perm := ();
      for i in [1..Length(v)] do perm := perm*G[v[i]][d+1]; od;
      if perm <> () then return false; fi;
      Add(ReachedWords, v);
      for j in [1..d] do
        if not IsOneWordIter(ProjectWord(v, j, G)) then return false; fi;
      od;
      return true;
    fi;
  end;

  d := Length(G[1])-1;
  if Length(w) = 0 then return true; fi;
  ReachedWords := [];
  return IsOneWordIter(w);
end);


InstallGlobalFunction(IsOneWordContr, function(word, G)
  local IsOneWordContrLocal;

  IsOneWordContrLocal:=function(word)
    local i, b, l, v, c, k, res, t, w;
    w := ShallowCopy(word);
#    Print("w=",w,"\n");
    if Length(w) = 0 then return true; fi;
    if Length(w) = 1 then
      if w = [1] then return true;
               else return false;
      fi;
    fi;
    if Length(w) mod 2 = 1 then Add(w, 1); fi;
    l := [];
    for i in [1..Length(w)/2] do
      Add(l, StructuralCopy(G[w[2*i-1]][w[2*i]]));
    od;
  #  Print("l = ", l);
  # list c contains permutations c[i+1] = pi[1]*pi[2]*...*pi[i]
    c := [(), l[1][Length(l[1])]];
    t := Length(l);
    for i in [2..t] do
  #    Print("c[", i, "] = ", c[i], ", l[", i, "] = ", l[i][Length(l[i])], ";");
      Add(c, c[i]*l[i][Length(l[i])]);
      l[i][Length(l[i])] := c[i];
    od;
    if c[Length(c)] <> () then
      return false;
    fi;
    l[1][Length(l[1])] := ();
    b := [];
    for i in [1..Length(l)] do
      b[i] := Permuted(l[i],(l[i][Length(l[i])])^(-1));
    od;
    i := 1;
    res := true;
    while res and (i <= Length(b[1])-1) do
      v := [];
      for k in [1..Length(b)] do
        Add(v, b[k][i]);
      od;
      v := ReduceWord(v);
      res := IsOneWordContrLocal(v);
      i := i+1;
    od;
    return res;
  end;

  return IsOneWordContrLocal(word);
end);


InstallGlobalFunction(AG_IsOneList, function(w, G)
  if IsList(G[1][1]) then return IsOneWordContr(w, G);
                     else return IsOneWordSelfSim(w, G);
  fi;
end);


InstallMethod(AG_MinimizedAutomatonList, "for [IsAutomGroup]", [IsAutomGroup],
function(H)
  return AG_AddInversesListTrack(List(AutomatonList(H), x -> List(x)));
end);


InstallGlobalFunction(CONVERT_ASSOCW_TO_LIST, function(w)
  local w_list, w_ext, i, j, numstates, cur_gen;
  numstates := FamilyObj(w)!.numstates;
  w_list := [];
  w_ext := ExtRepOfObj(w!.word);
  for i in [1..Length(w_ext)/2] do
    if w_ext[2*i] > 0 then
      cur_gen := w_ext[2*i-1];
    else
      cur_gen := w_ext[2*i-1]+numstates;
    fi;
    for j in [1..AbsInt(w_ext[2*i])] do Add(w_list, cur_gen); od;
  od;
  return w_list;
end);


InstallGlobalFunction(IsOneContr,
function(a)
  local a_list, a_list_orig, track_l, Gi, i;

  a_list_orig := CONVERT_ASSOCW_TO_LIST(a);


  Gi := AG_MinimizedAutomatonList(GroupOfAutomFamily(FamilyObj(a)));
  track_l := Gi[3];

  #a_list := [];
  #for i in [1..Length(a_list_orig)] do Add(a_list, track_l[a_list_orig[i]]); od;

  a_list := List(a_list_orig, i -> track_l[i]);

  return IsOneWordContr(a_list, AG_ContractingTable(GroupOfAutomFamily(FamilyObj(a))));
end);


###############################################################################
##
#M  AG_IsOneList(w, G)      (IsList, IsAutomGroup)
##
#InstallGlobalFunction(AG_IsOneList,
#function(w, G)
#  if HasIsContracting(G) and IsContracting(G) and UseContraction(G) then
#    return IsOneWordContr(w, AG_ContractingTable(G));
#  else
#    return IsOneWordSelfSim(w, AG_MinimizedAutomatonList(G)[1]);
#  fi;
#end);



InstallGlobalFunction(AG_ChooseAutomatonList,
function(G)
  if HasIsContracting(G) and IsContracting(G) and UnderlyingAutomFamily(G)!.use_contraction then
    return AG_ContractingTable(G);
  else
    return AG_MinimizedAutomatonList(G)[1];
  fi;
end);


InstallMethod(AG_OrderOfElement, "for [IsList, IsList, IsCyclotomic]", true,
              [IsList, IsList, IsCyclotomic],
function(v, G, size)
  local w, k;
  v := ReduceWord(v);
  w := StructuralCopy(v); k := 1;
  if Length(G[1]) = 3 then
    while (not AG_IsOneList(w, G)) and k < size do
      Append(w, w);
#     Print(w, ";");
      k := 2*k;
    od;
  else
    while (not AG_IsOneList(w, G)) and k < size do
      Append(w, v);
#     Print(w, ";");
      k := k+1;
    od;
  fi;
  if AG_IsOneList(w, G) then return k; else return fail; fi;
end);


InstallMethod(AG_OrderOfElement, "for [IsList, IsList, IsPosInt]",
              [IsList, IsList],
function(v, G)
  return AG_OrderOfElement(v, G, infinity);
end);


InstallGlobalFunction(GeneratorActionOnVertex, function(G, g, w)
  local i, v, gen, d;
  d := Length(G[1])-1;
  gen := g; v := [];
  for i in [1..Length(w)] do
    Add(v, (w[i]+1)^G[gen][d+1]-1);
    gen := G[gen][w[i]+1];
  od;
  return v;
end);


InstallGlobalFunction(AG_NumberOfVertex, function(w, d)
  local i, s;
  s := 0;
  for i in [1..Length(w)] do
    s := s+w[i]*d^(Length(w)-i);
  od;
  return s;
end);


InstallGlobalFunction(NumberOfVertex, function(w, d)
  local i, s, w_loc;
  s := 0;
  if IsString(w) then
    w_loc := List(w, x -> Int(String([x]))-1);
  else
    w_loc := List(w, x -> x-1);
  fi;
  for i in w_loc do
    if i < 0 or i >= d  then
      Error("received string ", w, " does not represent a valid vertex");
    fi;
  od;
  for i in [1..Length(w)] do
    s := s+w_loc[i]*d^(Length(w)-i);
  od;
  return s+1;
end);


InstallGlobalFunction(AG_VertexNumber, function(k, n, d)
  local i, l, l1, t;
  t := k; l := [];
  while t > 0 do
    Add(l, t mod d);
    t := (t-(t mod d))/d;
  od;
  for i in [Length(l)+1..n] do Add(l, 0); od;
  l1 := [];
  for i in [1..n] do l1[i] := l[n-i+1]; od;
  return l1;
end);


InstallGlobalFunction(VertexNumber, function(k, n, d)
  local i, l, l1, t;
  t := k-1; l := [];
  while t > 0 do
    Add(l, t mod d);
    t := (t-(t mod d))/d;
  od;
  for i in [Length(l)+1..n] do Add(l, 0); od;
  l1 := [];
  for i in [1..n] do l1[i] := l[n-i+1]; od;
  return List(l1, x -> x+1);
end);


InstallGlobalFunction(GeneratorActionOnLevel, function(G, g, n)
  local l, d, i, s, v, w, k;
  s := (); d := Length(G[1])-1;
  l := [];
  for i in [1..d^n] do Add(l, 0); od;
  i := 0;
  while i < d^n do
    k := 0;
    while l[k+1] > 0 do
      k := k+1;
    od;
    w := AG_VertexNumber(k, n, d);
    v := StructuralCopy(w);
    i := i+1;
    repeat
      l[AG_NumberOfVertex(v, d)+1] := 1;
      v := GeneratorActionOnVertex(G, g, v);
      if v <> w then
        s := s*(k+1, AG_NumberOfVertex(v, d)+1);
        i := i+1;
      fi;
    until v = w;
  od;
  return s;
end);


InstallGlobalFunction(PermActionOnLevel, function(perm, big_lev, sm_lev, deg)
  local l, i;
  l := [];
  for i in [0..deg^sm_lev-1] do
    Add(l, Int(((1+i*deg^(big_lev-sm_lev))^perm-1)/(deg^(big_lev-sm_lev)))+1);
  od;
  return PermList(l);
end);


InstallGlobalFunction(WordActionOnLevel, function(G, w, n)
  local gen, perm;
  perm := ();
  for gen in w do
    perm := perm*GeneratorActionOnLevel(G, gen, n);
  od;
  return perm;
end);


InstallGlobalFunction(AG_IsWordTransitiveOnLevel, function(G, w, lev)
  return Length(OrbitPerms([WordActionOnLevel(G, w, lev)], 1)) = (Length(G[1])-1)^lev;
end);


InstallGlobalFunction(AG_GeneratorActionOnLevelAsMatrix, function(G, g, n)
  local perm, i, j, m, d;
  perm := GeneratorActionOnLevel(G, g, n);
  d := Length(G[1])-1;
  m := List([1..d^n], x -> List([1..d^n], x -> 0));
  for i in [1..d^n] do
    m[i][i^perm] := 1;
  od;
  return m;
end);


InstallGlobalFunction(PermOnLevelAsMatrix, function(g, lev)
  local perm, i, j, m, d;
  perm := PermOnLevel(g, lev);
  d := g!.deg;
  m := List([1..d^lev], x -> List([1..d^lev], x -> 0));
  for i in [1..d^lev] do
    m[i][i^perm] := 1;
  od;
  return m;
end);


InstallGlobalFunction(TransformationOnLevelAsMatrix, function(g, lev)
  local trans, i, j, m, d;
  trans := TransformationOnLevel(g, lev);
  d := DegreeOfTransformation(trans);
  m := List([1..d], x -> List([1..d], x -> 0));
  for i in [1..d] do
    m[i][i^trans] := 1;
  od;
  return m;
end);


InstallGlobalFunction(InvestigatePairs, function(G)
  local i, j, k, i1, j1, k1, Pairs, Trip, n, IsPairEq, d, res, tmp;

  IsPairEq := function(i, j, k)   # ij = k?
    local t, res;
    if (not IsList(Pairs[i][j])) or (IsList(Pairs[i][j])
                                     and (Pairs[i][j][1] <> k)) then
      if (not IsList(Pairs[i][j])) and (Pairs[i][j] <> -1) then
        if Pairs[i][j] = k then return true;
                         else return false;
        fi;
      fi;
      if IsList(Pairs[i][j]) then
        if Length(Pairs[i][j]) = 1 then
          Trip[i][j][Pairs[i][j][1]] := 0;
        else
          Trip[i1][j1][k1] := 0;
          return true;
        fi;
      fi;
      if Trip[i][j][k] = 0 then return false;
      else
        if G[i][d+1]*G[j][d+1] <> G[k][d+1] then
          Trip[i][j][k] := 0;
          return false;
        fi;
        Pairs[i][j] := [k];
        t := 1; res := true;
        while res and (t <= d) do
#          Print("i = ", i, ", j = ", j, ", k = ", k, ", t = ", t, ";   ");
          res := IsPairEq(G[i][t], G[j][t^G[i][d+1]], G[k][t]);
          t := t+1;
        od;
        if res then
          if Trip[i][j][k] <> 0 then
            Pairs[i][j] := [k, 1];
            return true;
          else
            Pairs[i][j] := -1;
            return false;
          fi;
        else
          Trip[i][j][k] := 0;
          Pairs[i][j] := -1;
          return false;
        fi;
      fi;
    else
      return true;
    fi;
  end;

  Pairs := [[]]; Trip := [];
  n := Length(G);
  d := Length(G[1])-1;
  for j in [1..n] do Add(Pairs[1], j); od;
  for i in [2..n] do
    Add(Pairs, [i]);
    Trip[i] := [];
    for j in [2..n] do
      Pairs[i][j] := -1;
      Trip[i][j] := [];
      for k in [1..n] do Trip[i][j][k] := -1; od;
    od;
  od;
#  Print(Pairs);
#  Print(Trip);
  for i1 in [2..n] do for j1 in [2..n] do
    if Pairs[i1][j1] = -1 then
      k1 := 1; res := false;
      while (not res) and (k1 <= n) do
        res := IsPairEq(i1, j1, k1);
#        Print(Pairs, "\n");
        for i in [2..n] do for j in [2..n] do
          if IsList(Pairs[i][j]) then
            if res then Pairs[i][j] := Pairs[i][j][1];
                   else Pairs[i][j] := -1;
            fi;
          fi;
        od; od;
        k1 := k1+1;
      od;
      if Pairs[i1][j1] = -1 then Pairs[i1][j1] := 0; fi;
    fi;
  od; od;
  return Pairs;
end);


InstallMethod(ContractingLevel, "for [IsAutomGroup]", [IsAutomGroup],
function(H)
  if not HasIsContracting(H) then
    Info(InfoAutomGrp, 1, "If  < H >  is not contracting, the algorithm will never stop");
  fi;
  FindNucleus(H,false);
  return ContractingLevel(H);
end);




InstallMethod(AG_ContractingTable, "for [IsAutomGroup]", [IsAutomGroup],
function(H)
  local AG_ContractingTableLocal;
  AG_ContractingTableLocal := function(G)
    local lev, n, d, i, j, ContractingPair, Pairs, ContTable;
    ContractingPair := function(i, j)
      local l, k, t, PairAct, TmpList, g1, g2;
      if Pairs[i][j] <> 0 then PairAct := [Pairs[i][j]];
                        else PairAct := [[i, j]];
      fi;
      for l in [1..lev] do
        TmpList := [];
        for t in [1..Length(PairAct)] do
          if not IsList(PairAct[t]) then
            for k in [1..d] do Add(TmpList, G[PairAct[t]][k]); od;
          else
            for k in [1..d] do
              g1 := G[PairAct[t][1]][k];
              g2 := G[PairAct[t][2]][k^G[PairAct[t][1]][d+1]];
              if Pairs[g1][g2] <> 0 then Add(TmpList, Pairs[g1][g2]);
                                    else Add(TmpList, [g1, g2]);
              fi;
            od;
          fi;
        od;
        PairAct := StructuralCopy(TmpList);
      od;
      Add(PairAct, GeneratorActionOnLevel(G, i, lev)*GeneratorActionOnLevel(G, j, lev));
      return PairAct;
    end;

    lev := ContractingLevel(H);
    Pairs := InvestigatePairs(G);
    n := Length(G);
    d := Length(G[1])-1;
    ContTable := [];
    for i in [1..n] do
      Add(ContTable, []);
      for j in [1..n] do Add(ContTable[i], ContractingPair(i, j)); od;
    od;
    return ContTable;
  end;
################ AG_ContractingTable itself #################################

  if not HasIsContracting(H) then
    Info(InfoAutomGrp, 1, "If  < H >  is not contracting, the algorithm will never stop");
  fi;
  return AG_ContractingTableLocal(AG_GeneratingSetWithNucleusAutom(H));
end);


InstallMethod(ContractingTable, "for [IsAutomGroup]", [IsAutomGroup],
function(H)
  local T, i, j, k, deg, numstates;
  T := StructuralCopy(AG_ContractingTable(H));
  deg := Length(T[1][1])-1;
  numstates := Length(T);
  for i in [1..numstates] do
    for j in [1..numstates] do
      for k in [1..deg] do
        T[i][j][k] := GeneratingSetWithNucleus(H)[T[i][j][k]];
      od;
      T[i][j] := TreeAutomorphism(T[i][j]{[1..deg]} , T[i][j][deg+1]);
    od;
  od;
  return T;
end);


# The base of the code of the function below below was written by Andriy Russev
InstallGlobalFunction(AG_MinimizationOfAutomatonListTrack, function(A)
  local n, perms, m, classes, states, list, i, j, ids, temp, s, d, new_as_old, old_as_new, aut_list, perm, state;
  n := Length(A);
  d:=Length(A[1])-1;
  perms := SSortedList(List(A,x->x[d+1]));
  # In the minimization process the set of states is partitioned into classes
  m := Length(perms); # number of states of automaton A

  # "classes" contains classes of states. To each state of automaton A we assign an number from 1 to m
  # (the first element in the list; if the class is not "finished", we add n)
  classes := List([1..n], x -> [Position(perms, A[x][d+1])]);
  # Canonical representatives of classes of states
  states := [];

  # The list of states of A that have not been classified yet
  list := [1..n];

  # At this moment all the states that belong to the same class act identically
  # on words of length 1. During each iteration, classes consist of states that
  # act identically on the words of length k will be partitioned into smalled
  # subclasses of states that act identically on words of length k+1.
  # If no class was partitioned during an iteration, then all the states in
  # each class are equivalent and act identically on words of arbitrary length.
  # This is the end of minimization procedure
  while true do
    # states from each class act identically on all words of length k.
    for i in list do
      # Define classes for the states of the first level
      classes[i][2] := List(A[i]{[1..d]}, x -> classes[x][1]);
    od;

    # the extended identifier of a class contains information about the action
    # of this state, and of its first level states on words of length k.
    # I.e., it describes the action of the state on words of the length k+1.
    # If extended identifiers of states coincide, then these states act
    # identically on words of length k+1.
    # Update the identifiers of classes; save to "temp" the list of classes
    # that contain one state
    ids := [];
    temp := [];
    s := Length(states);
    for i in list do
      j := Position(ids, classes[i]);
      if j = fail then
        Add(ids, ShallowCopy(classes[i]));
        j := Length(ids);
        temp[j] := i;
      else
        Unbind(temp[j]);
      fi;
      classes[i][1] := s + j + n;
    od;
    # Check if new classes created during the iteration
    if s + Length(ids) = m then break; fi;
    m := s + Length(ids);
    # Find canonical representatives of classes that contain only a single state of A
    temp := Compacted(temp);
    for i in temp do
      s := s + 1;
      classes[i][1] := s;
      states[s] := i;
    od;
    # remove all classes with one state from future iterations.
    SubtractSet(list, temp);
  od;
  # Find canonical representatives of the remaining classes


  ids := [];
  for i in list do
    classes[i][1] := classes[i][1] - n;
    j := Position(ids, classes[i]);
    if j = fail then
      Add(ids, classes[i]);
      states[classes[i][1]] := i;
    fi;
  od;

  aut_list:=List(states,
    x -> Flat([List(A[x]{[1..d]}, y -> classes[y][1]),
    A[x][d+1]]));
  old_as_new:=List(classes,c->c[1]);
  new_as_old:=List([1..Length(states)],x->Position(old_as_new,x));

  #Now sort the new list in the same order as the old states
  perm:=Sortex(new_as_old);

  aut_list:=Permuted(aut_list,perm);
  for state in aut_list do
    for i in [1..d] do
      state[i]:=state[i]^perm;
    od;
  od;

  Apply(old_as_new, x->x^perm);

  return [aut_list,
    new_as_old,
    old_as_new];
end);


InstallGlobalFunction(AG_MinimizationOfAutomatonList, function(G)
  return AG_MinimizationOfAutomatonListTrack(G)[1];
end);


InstallGlobalFunction(AG_AddInversesListTrack, function(H)
  local d, n, G, idEl, st, i, perm, inv, minimized_autlist;

##  track_s - new generators in terms of old ones
##  track_l - old generators in terms of new ones

  d := Length(H[1])-1;
  n := Length(H);
  if n < 1 or d < 1 then return fail; fi;
  idEl := Flat([List([1..d],x->1),()]);
  G := [idEl];
  for i in [1..n] do Add(G, StructuralCopy(H[i])); od;

  for st in [2..n+1] do
    for i in [1..d] do G[st][i] := G[st][i]+1; od;
  od;

  for st in [2..n+1] do
    inv := [];
    perm := G[st][d+1]^(-1);
    for i in [1..d] do Add(inv, G[st][i^perm]+n); od;
    Add(inv, perm);
    Add(G, inv);
  od;
#  return AG_MinimizationOfAutomatonListTrack(G, [0..Length(G)-1], [2..Length(G)]);
  minimized_autlist := AG_MinimizationOfAutomatonListTrack(G);
  return [minimized_autlist[1], List(minimized_autlist[2],x->x-1), minimized_autlist[3]{[2..Length(minimized_autlist[3])]}];
end);


InstallGlobalFunction(AG_AddInversesList, function(H)
  return AG_AddInversesListTrack(H)[1];
end);



InstallMethod(UseContraction, "for [IsAutomGroup]", true,
              [IsAutomGroup],
function(G)
  local H;
  H := GroupOfAutomFamily(UnderlyingAutomFamily(G));

  if not HasIsContracting(H) then
    Print("Error in UseContraction(<G>): It is not known whether the group of family is contracting\n");
    return fail;
  elif not IsContracting(H) then
    Print("Error in UseContraction(<G>): The group of family is not contracting");
    return fail;
  fi;

  #  IsContracting returns either true or false or an error (it can not return fail)
  UnderlyingAutomFamily(G)!.use_contraction := true;
  return true;
end);


InstallMethod(DoNotUseContraction, "for [IsAutomGroup]", true,
              [IsAutomGroup],
function(G)
  UnderlyingAutomFamily(G)!.use_contraction := false;
  return true;
end);



InstallMethod(FindNucleus, "for [IsAutomatonGroup, IsCyclotomic, IsBool]", true,
                                    [IsAutomatonGroup, IsCyclotomic, IsBool],
function(H, max_nucl, print_info)
  local G, g, Pairs, i, j, PairsToAdd, AssocWPairsToAdd, res, ContPairs, n, d, found, num, DoesPairContract, AddPairs, lev, maxlev, tmp, Nucl, IsElemInNucleus,
    nucl_final, cur_nucl, cur_nucl_tmp, Hi, track_s, track_l, G_track, automgens, cur_nucl_length, info;

#   DoesPairContract := function(i, j, lev)
#     local t, res;
#     if lev > maxlev then maxlev := lev; fi;
#
#     # ContPairs[i][j] may take the following values:
#     # -1 - [i, j] was not met before
#     # 1  - [i, j] contracts
#     # 2  - [i, j] was met above in the tree
#
#     if (ContPairs[i][j] = 1) then return true; fi;
#     if Pairs[i][j] <> 0 then
#       ContPairs[i][j] := 1;
#       return true;
#     fi;
#     # if we've seen this pair before it needs to be in the nucleus
#     if ContPairs[i][j] = 2 then return [i, j]; fi;
#     t := 1; res := true;
#     ContPairs[i][j] := 2;
#     while res = true and (t <= d) do
#       res := DoesPairContract(G[i][t], G[j][t^G[i][d+1]], lev+1);
#       t := t+1;
#     od;
#     if res = true then
#              ContPairs[i][j] := 1;
#              return true;
#     else return res;
#     fi;
#   end;


  DoesPairContract := function(i, j, lev)
    local t, res, localmaxlev;
    if lev > maxlev then maxlev := lev; fi;

#   ContPairs[i][j] may take the following values:
#   -1 - [i, j] was not met before
#   [k]  - [i, j] contracts on level k
#   2  - [i, j] was met above in the tree

    if IsList(ContPairs[i][j]) then
      if lev+ContPairs[i][j][1] > maxlev then maxlev := lev+ContPairs[i][j][1]; fi;
      return true;
    fi;
    if Pairs[i][j] <> 0 then
      ContPairs[i][j] := [0];
      return true;
    fi;
    if ContPairs[i][j] = 2 then return [i,j]; fi;
    t := 1; res := true;
    ContPairs[i][j] := 2;
    localmaxlev := 0;
    while res = true and (t <= d) do
      res := DoesPairContract(G[i][t], G[j][t^G[i][d+1]], lev+1);
      if res = true then
        if ContPairs[G[i][t]][G[j][t^G[i][d+1]]][1]+1 > localmaxlev then
          localmaxlev := ContPairs[G[i][t]][G[j][t^G[i][d+1]]][1]+1;
        fi;
      fi;
      t := t+1;
    od;
    if res = true then
             ContPairs[i][j] := [localmaxlev];
             return true;
           else return res;
    fi;
  end;

  AddPairs := function(i, j)
    local tmp, l, CurNum;
    if Pairs[i][j] > 0 then return Pairs[i][j]; fi;
    Pairs[i][j] := num;
    CurNum := num;
    Add(PairsToAdd, []);
    num := num+1;
    tmp := [];
    for l in [1..d] do
      Add(tmp, AddPairs(G[i][l], G[j][l^G[i][d+1]]));
    od;
    Add(tmp, G[i][d+1]*G[j][d+1]);
    Append(PairsToAdd[CurNum-n], tmp);
    AssocWPairsToAdd[CurNum-n] := cur_nucl[i]*cur_nucl[j];
    return CurNum;
  end;

  IsElemInNucleus := function(g)
    local i, res;
    if g in tmp then
      for i in [Position(tmp, g)..Length(tmp)] do
        if not (tmp[i] in Nucl) then Add(Nucl, tmp[i]); fi;
      od;
      return g = tmp[1];
    fi;
    Add(tmp, g);
    res := false; i := 1;
    while (not res) and i <= d do
      res := IsElemInNucleus(G[g][i]);
      i := i+1;
    od;
    Remove(tmp);
    return res;
  end;

#  ******************  FindNucleus itself *******************************

  if HasIsContracting(H) and not IsContracting(H) then
    return fail;
  fi;

  automgens := UnderlyingAutomFamily(H)!.automgens;
  d := UnderlyingAutomFamily(H)!.deg;
  cur_nucl := [One(UnderlyingAutomFamily(H))];

  Hi := StructuralCopy(AG_MinimizedAutomatonList(H));
#  Print("Gi = ", Gi, "\n");
  G := Hi[1];

  track_s := Hi[2];
  track_l := Hi[3];

  for i in [2..Length(track_s)] do Add(cur_nucl, automgens[track_s[i]]); od;

  found := false;

  while (not found) and Length(G) < max_nucl do
    res := true; maxlev := 0; ContPairs := [];
    Pairs := InvestigatePairs(G);
    n := Length(G);
#    Print("n = ", n, "\n");
    if print_info = true then
      Print("Trying generating set with ", n, " elements\n");
    else
      Info(InfoAutomGrp, 3, "Trying generating set with ", n, " elements");
    fi;
#     for i in [1..n] do
#       Add(ContPairs, [1]);
#       for j in [1..n-1] do
#         if i = 1 then Add(ContPairs[i], 1);
#                else Add(ContPairs[i], -1);
#         fi;
#       od;
#     od;

    for i in [1..n] do
      Add(ContPairs, [[0]]);
      for j in [1..n-1] do
        if i = 1 then Add(ContPairs[i], [0]);
               else Add(ContPairs[i], -1);
        fi;
      od;
    od;


    i := 1;

    while res = true and (i <= n) do
      j := 1;
      while res = true and (j <= n) do
        #Print("i = ", i, ", j = ", j, "\n");
        if ContPairs[i][j] = -1 then res := DoesPairContract(i, j, 0); fi;
        if res <> true then
          PairsToAdd := [];
          AssocWPairsToAdd := [];
#  num represents current number of generators
          num := n+1;
          AssocWPairsToAdd := [];
          AddPairs(res[1], res[2]);
          if print_info = true then
            Print("Elements added:", List(AssocWPairsToAdd, x -> x!.word), "\n");
          else
            Info(InfoAutomGrp, 3, "Elements added:", List(AssocWPairsToAdd, x -> x!.word));
          fi;
          Append(G, PairsToAdd);
#          Print("G = ", G, "\n");
          Append(cur_nucl, AssocWPairsToAdd);
          G_track := AG_AddInversesListTrack(G);
#          Print("G_track = ", G_track, "\n");
          G := G_track[1];
          cur_nucl_tmp := [];
          cur_nucl_tmp := [One(UnderlyingAutomFamily(H))];
          cur_nucl_length := Length(cur_nucl);
          for i in [2..Length(G_track[2])] do
            if G_track[2][i] <= cur_nucl_length then
              Add(cur_nucl_tmp, cur_nucl[G_track[2][i]]);
            else
              Add(cur_nucl_tmp, cur_nucl[G_track[2][i]-cur_nucl_length]^-1);
            fi;
          od;
          cur_nucl := StructuralCopy(cur_nucl_tmp);
        fi;
        j := j+1;
      od;
      i := i+1;
    od;
    if res = true then
      found := true;
    fi;
  od;

  if not found then return fail; fi;
  Nucl := [];
# first add elements of cycles
  for i in [1..Length(G)] do
    tmp := [];
    if not (i in Nucl) then IsElemInNucleus(i); fi;
  od;

# now add sections of elements
  for g in Nucl do
    for i in [1..d] do
      if not (G[g][i] in Nucl) then
        Add(Nucl, G[g][i]);
      fi;
    od;
  od;
#  Print("Nucleus:", Nucl, "\n");

  nucl_final := [];
  for i in Nucl do Add(nucl_final, cur_nucl[i]); od;

  SetIsContracting(H, true);
  SetGroupNucleus(H, nucl_final);
  SetGeneratingSetWithNucleus(H, cur_nucl);
  SetAG_GeneratingSetWithNucleusAutom(H, G);
  SetGeneratingSetWithNucleusAutom(H, MealyAutomaton(G));
  SetContractingLevel(H, maxlev);
  UseContraction(H);

  return [nucl_final, cur_nucl, GeneratingSetWithNucleusAutom(H)];
end);


InstallMethod(FindNucleus, "for [IsAutomatonGroup, IsBool]", true,
                                    [IsAutomatonGroup, IsBool],
function(H, print_info)
  return FindNucleus(H, infinity, print_info);
end);

InstallMethod(FindNucleus, "for [IsAutomatonGroup, IsCyclotomic]", true,
                                    [IsAutomatonGroup, IsCyclotomic],
function(H, max_nucl)
  return FindNucleus(H, max_nucl, true);
end);

InstallMethod(FindNucleus, "for [IsAutomatonGroup]", true,
                                    [IsAutomatonGroup],
function(H)
  return FindNucleus(H, infinity, true);
end);





InstallMethod(IsContracting, "for [IsAutomGroup]", true,
              [IsAutomGroup],
function(G)
  local res;
  if IsSelfSimilar(G) = false then
    Info(InfoAutomGrp, 3, "The group  <G>  is not self-similar, so it is not contracting");
    return false;
  elif not IsAutomatonGroup(G) then
    Print("Represent  <G>  as a group generated by finite automaton\n");
    return fail;
  fi;
  if FindNucleus(G, 50, false) <> fail then return true; fi;
  if IsNoncontracting(G, 10, 10)  =  true then return false; fi;
  Info(InfoAutomGrp, 3, "You can try FindNucleus( <G>, <max_nucl> ) or");
  Info(InfoAutomGrp, 3, "            IsNoncontracting( <G>, <lengh>, <depth> ) with bigger bounds");
  TryNextMethod();
end);


InstallMethod(GroupNucleus, "for [IsAutomGroup]", true,
              [IsAutomGroup],
function(G)
  FindNucleus(G, false);
  return GroupNucleus(G);
end);


InstallMethod(GeneratingSetWithNucleus, "for [IsAutomGroup]", true,
              [IsAutomGroup],
function(G)
  FindNucleus(G, false);
  return GeneratingSetWithNucleus(G);
end);


InstallMethod(GeneratingSetWithNucleusAutom, "for [IsAutomGroup]", true,
              [IsAutomGroup],
function(G)
  FindNucleus(G, false);
  return GeneratingSetWithNucleusAutom(G);
end);



InstallMethod(AG_GeneratingSetWithNucleusAutom, "for [IsAutomGroup]", true,
              [IsAutomGroup],
function(G)
  FindNucleus(G, false);
  return AG_GeneratingSetWithNucleusAutom(G);
end);



InstallGlobalFunction(InversePerm, function(G)
  local i, j, viewed, inv, found;
  viewed := []; inv := ();
  for i in [1..Length(G)] do
    if not (i in viewed) then
      j := 1; found := false;
      while j <= Length(G) and not found do
        #Print("[", i, ", ", j, "]\n");
        if AG_IsOneList([i, j], G) then
          found := true;
          if i <> j then
            inv := inv*(i, j);
            Append(viewed, [i, j]);
          else
            Add(viewed, i);
          fi;
        fi;
        j := j+1;
      od;
    fi;
  od;
  return inv;
end);



InstallGlobalFunction(AG_AutomPortraitMain, function(w)
  local PortraitIter, bndry, inv, d, Perm_List, max_lev, G, w_list, w_list_orig, Gi, track_l, nucl;

  PortraitIter := function(v, lev, plist)
    local i, j, tmpv, sigma;
    for i in [1..Length(G)] do
      tmpv := StructuralCopy(v);
      Add(tmpv, i);
      if AG_IsOneList(tmpv, G) then
        Add(bndry, [lev, nucl[i^inv]]);
        Add(plist, nucl[i^inv]);
        return;
      fi;
    od;

    for i in [1..d] do
      tmpv := []; sigma := ();
      for j in v do
        Add(tmpv, G[j][i^sigma]);
        sigma := sigma*G[j][d+1];
      od;
      if i = 1 then Add(plist, sigma);fi;
      Add(plist, []);
      PortraitIter(tmpv, lev+1, plist[i+1]);
    od;
  end;

  d := w!.deg;
  G := AG_GeneratingSetWithNucleusAutom(GroupOfAutomFamily(FamilyObj(w)));
  nucl := GeneratingSetWithNucleus(GroupOfAutomFamily(FamilyObj(w)));

  Gi := AG_MinimizedAutomatonList(GroupOfAutomFamily(FamilyObj(w)));
  track_l := Gi[3];
  w_list_orig := CONVERT_ASSOCW_TO_LIST(w);
  w_list := List(w_list_orig, i -> track_l[i]);


  bndry := [];
  Perm_List := [];
  inv := InversePerm(G);
  max_lev := 0;
  PortraitIter(w_list, 0, Perm_List);
  return [d, bndry, Perm_List];
end);

InstallGlobalFunction(AutomPortrait, function(w)
  return AG_AutomPortraitMain(w)[3];
end);

InstallGlobalFunction(AutomPortraitBoundary, function(w)
  return AG_AutomPortraitMain(w)[2];
end);

InstallGlobalFunction(AutomPortraitDepth, function(w)
  local bndry;
  return Maximum(List(AG_AutomPortraitMain(w)[2], x -> x[1]));
end);



################################################################################
##
#F WritePortraitToFile. . . . . . . . . . .Writes portrait in a file in the form
##                                                       understandable by Maple

# InstallGlobalFunction(WritePortraitToFile, function(p, file, add)
#   local WritePerm, l;
#
#   WritePerm := function(perm)
#     local j;
#     AppendTo(file, "[ ");
#     if Length(perm) > 0 then
#       AppendTo(file, "`", perm[1], "`");
#       for j in [2..Length(perm)] do
#         AppendTo(file, ", ");
#         WritePerm(perm[j]);
#       od;
#     fi;
#     AppendTo(file, " ]");
#   end;
#
#
#   l := [p[1], List(p[2], x -> [x[1], x[2]!.word])];
#   if add then AppendTo(file, "[ ", l[1], ", ");
#     else PrintTo(file, "[ ", l[2], ", ");
#   fi;
#   WritePerm(p[3]);
#   AppendTo(file, " ]");
# end);


################################################################################
##
#F WritePortraitsToFile. . . . . . . . . . . . .Writes portraitso of elements of
##                          a list in a file in the form understandable by Maple

# InstallGlobalFunction(WritePortraitsToFile, function(lst, G, file, add)
#   local WritePerm, i, p;
#
#   if add then AppendTo(file, "[ ");
#     else PrintTo(file, "[ ");
#   fi;
#
#   for i in [1..Length(lst)] do
#     if i = 1 then
#         AppendTo(file, "[ ", lst[i], ", ");
#     else
#         AppendTo(file, ", [ ", lst[i], ", ");
#     fi;
#     p := AutomPortrait(lst[i], G);
#     WritePortraitToFile(p, file, true);
#     AppendTo(file, "]");
#
#   od;
# end);


InstallMethod(Growth, "for [IsAutomGroup, IsCyclotomic]", true,
              [IsGroup, IsCyclotomic],
function(G, max_len)
  local ElList, GrList, i, j, orig_gens, gen, gens, new_gen, g, len, viewed, oldgr, New, k, cur_els;

# produce a symmetric generating set
  orig_gens := ShallowCopy(GeneratorsOfGroup(G));
  Append(orig_gens, List(orig_gens, x -> x^-1));

  gens := [];

# select pairwise different generators
  for i in [1..Length(orig_gens)] do
    if not IsOne(orig_gens[i]) then
      new_gen := true;
      for j in [1..i-1] do if orig_gens[i] = orig_gens[j] then new_gen := false; fi; od;
      if new_gen then Add(gens, orig_gens[i]); fi;
    fi;
  od;

  ElList := [One(G)]; Append(ElList, ShallowCopy(gens));
  GrList := [1, Length(gens)+1];
  len := 1;

  while len < max_len and GrList[len] <> GrList[len+1] do
    for i in [GrList[len]+1..GrList[len+1]] do
      oldgr := Length(ElList);
      for gen in gens do
        g := ElList[i]*gen;
        New := true;
        if len = 1 then k := 1; else k := GrList[len-1]; fi;
        while New and k <= oldgr do
          if g = ElList[k] then New := false; fi;
          k := k+1;
        od;
        if New then Add(ElList, g); fi;
      od;
    od;
    Add(GrList, Length(ElList));
    Print("There are ", Length(ElList), " elements of length up to ", len+1, "\n");
    len := len+1;
  od;
  if GrList[len] = GrList[len+1] then
    SetSize(G, GrList[len]);
  fi;
  return GrList;
end);


InstallMethod(Growth, "for [IsTreeHomomorphismSemigroup, IsCyclotomic]", true,
              [IsTreeHomomorphismSemigroup, IsCyclotomic],
function(G, max_len)
  local iter, g, i;
  iter := Iterator(G, max_len);
  for g in iter do od;
  return List(iter!.levels, x -> x[Length(x)]);
end);


InstallMethod(ListOfElements, "for [IsTreeHomomorphismSemigroup, IsCyclotomic]", true,
              [IsGroup, IsCyclotomic],
function(G, max_len)
  return FindElements(G, ReturnTrue, true, max_len);
end);


InstallMethod(AG_FiniteGroupId, "for [IsAutomatonGroup, IsPosInt]", true,
              [IsAutomatonGroup, IsCyclotomic],
function(H, size)
  local gr, len, ElList, GrList, inv, i, j, k, oldgr, v, tmpv, New, IsNewRel, inverse, G, FinG, tmpl, push, ProductEls, act, rels, LongCycle;

  inverse := function(w)
    local i, iw;
    iw := [];
    for i in [1..Length(w)] do
      iw[i] := w[Length(w)-i+1]^inv;
    od;
    return iw;
  end;

  ProductEls := function(i, j)
    local t, v, tmpv;
    v := StructuralCopy(ElList[i]);
    Append(v, ElList[j]);
    for t in [1..Length(ElList)] do
      tmpv := StructuralCopy(v);
      Append(tmpv, inverse(ElList[t]));
      if AG_IsOneList(tmpv, G) then return t; fi;
    od;
  end;

  LongCycle := function(n)
    local l, i;
    l := [];
    for i in [2..n] do Add(l, i); od;
    Add(l, 1);
    return PermList(l);
  end;

  IsNewRel := function(v)
    local  tmp, i, j, cyc, cycr, v_cyc, r_cyc, r, r_cyc_inv;
    cyc := LongCycle(Length(v));
    for i in [0..Length(v)-1] do
      v_cyc := Permuted(v, cyc^i);
      if v_cyc[1] = v_cyc[Length(v)]^inv then return false; fi;
      for r in rels do
        cycr := LongCycle(Length(r));
        for j in [0..Length(r)-1] do
          r_cyc := Permuted(r, cycr^j);
          r_cyc_inv := inverse(Permuted(r, cycr^j));
          if PositionSublist(v_cyc, r_cyc) <> fail or PositionSublist(v_cyc, r_cyc_inv) <> fail then
            return false;
          fi;
        od;
      od;
    od;
    return true;
  end;
  


#######################   _FiniteGroupId  itself #########################################
  gr := 1; len := 1;

  G := AG_ChooseAutomatonList(H);

  inv := InversePerm(G);
  if not HasIsFinite(H) then
    Info(InfoAutomGrp, 2, "warning, if  < H >  is infinite the algorithm will never stop");
  fi;
  GrList := [1, Length(G)];
  ElList := []; rels := [];
  for i in [1..Length(G)] do
    Add(ElList, [i]);
  od;
  while GrList[len+1] > GrList[len] and GrList[len+1] < size do
    for i in [GrList[len]+1..GrList[len+1]] do
      oldgr := Length(ElList);
      for j in [2..Length(G)] do
        v := StructuralCopy(ElList[i]);
        if j <> v[Length(v)]^inv then
          Add(v, j);
          New := true;
          if len = 1 then k := 1; else k := GrList[len-1]+1; fi;
          while New and k <= oldgr do
            tmpv := StructuralCopy(v);
            Append(tmpv, inverse(ElList[k]));
            if AG_IsOneList(tmpv, G) then
              New := false;
## show relations
              if IsNewRel(tmpv) then
                Add(rels, tmpv);
#                Info(InfoAutomGrp, 3, v, "*", ElList[k], "^(-1) = 1");
#               Print(tmpv, "\n");
              fi;
            fi;
            k := k+1;
          od;
          if New then Add(ElList, v); fi;
        fi;
      od;
    od;
    Add(GrList, Length(ElList));
    Info(InfoAutomGrp, 3, "There are ", Length(ElList), " elements of length up to ", len+1);
    len := len+1;
  od;

  if GrList[len+1] > GrList[len] then return fail; fi;

  SetSize(H, GrList[len]);

# in case of finite group construct Cayley table


  FinG := [];
  for i in [2..UnderlyingAutomFamily(H)!.numstates+1] do
    act := ();
    tmpl := [];
    while Length(tmpl) < Length(ElList) do
      j := 1;
      while j in tmpl do j := j+1; od;
      Add(tmpl, j);
      push := ProductEls(j, i);
      while push <> j do
        Add(tmpl, push);
        act := act*(j, push);
        push := ProductEls(push, i);
      od;
    od;
    Add(FinG, act);
  od;

  return GroupWithGenerators(FinG);
end);


InstallMethod(AG_FiniteGroupId, "for [IsAutomGroup]",
              [IsAutomGroup],
function(G)
  return AG_FiniteGroupId(G, infinity);
end);


InstallMethod(AG_FiniteGroupId, "for [IsAutomGroup, IsCyclotomic]",
              [IsAutomGroup, IsCyclotomic],
function(G, n)
  local ElList, GrList, i, j, orig_gens, gen, gens, new_gen, g, len, viewed, oldgr, New, k, ProductEls, FinG, tmpl, push, act, track_l,
        num_diff_gens, num_orig_gens, old_gens;

  ProductEls := function(i, j)
    local t;
    for t in [1..Length(ElList)] do
      if IsOne(ElList[i]*ElList[j]*ElList[t]^-1) then return t; fi;
    od;
    return fail;
  end;

  orig_gens := ShallowCopy(GeneratorsOfGroup(G));
  num_orig_gens := Length(orig_gens);
  Append(orig_gens, List(orig_gens, x -> x^-1));

  gens := [];

# select pairwise different generators and track the original ones.
# examlpe: assume b^2 = 1
# orig_gens  =     [a, e, a, b, b, c,  a^-1, e^-1, a^-1, b^-1, b^-1, c^-1]
# track_l    =     [1, 0, 1, 2, 2, 3,  4,   0,   4,   2,   2,   5   ]
# gens       =     [a, b, c, a^-1, c^-1]
# num_orig_gens =  6
# num_diff_gens =  3
  track_l := [];
  for i in [1..Length(orig_gens)] do
    if IsOne(orig_gens[i]) then
      track_l[i] := 0;
    else
      new_gen := true;
      j := 1;
      while j < i and new_gen do
        if orig_gens[i] = orig_gens[j] then
          new_gen := false;
          track_l[i] := track_l[j];
        fi;
        j := j+1;
      od;
      if new_gen then
        Add(gens, orig_gens[i]);
        track_l[i] := Length(gens);
      fi;
      if i = num_orig_gens then num_diff_gens := Length(gens); fi;
    fi;
  od;

  ElList := [One(G)]; Append(ElList, ShallowCopy(gens));
  GrList := [1, Length(gens)+1];
  len := 1;

  while len < n and GrList[len] <> GrList[len+1] do
    for i in [GrList[len]+1..GrList[len+1]] do
      oldgr := Length(ElList);
      for gen in gens do
        g := ElList[i]*gen;
#       Print("g = ", g, "\n\n");
        New := true;
        if len = 1 then k := 1; else k := GrList[len-1]; fi;
        while New and k <= oldgr do
#          Print(g*ElList[k]^-1, "\n");
          if IsOne(g*ElList[k]^-1) then New := false; fi;
          k := k+1;
        od;
        if New then Add(ElList, g); fi;
      od;
    od;
    Add(GrList, Length(ElList));
    Info(InfoAutomGrp, 3, "There are ", Length(ElList), " elements of length up to ", len+1);
    len := len+1;
  od;

  if GrList[len] <> GrList[len+1] then return fail;  fi;

  SetSize(G, GrList[len]);

# in case of finite group construct Cayley table
  FinG := [];
  for i in [2..num_diff_gens+1] do
    act := ();
    tmpl := [];
    while Length(tmpl) < Length(ElList) do
      j := 1;
      while j in tmpl do j := j+1; od;
      Add(tmpl, j);
      push := ProductEls(j, i);
      while push <> j do
        Add(tmpl, push);
        act := act*(j, push);
        push := ProductEls(push, i);
      od;
    od;
    Add(FinG, act);
  od;

# switch to the original generating set
  old_gens := [];
  for i in [1..num_orig_gens] do
    if track_l[i] = 0 then
      old_gens[i] := ();
    else
      old_gens[i] := FinG[track_l[i]];
    fi;
  od;

  return GroupWithGenerators(old_gens);
end);


InstallGlobalFunction(AG_IsOneWordSubs, function(w, subs, G)
  local i, v;
  v := [];
  for i in w do Append(v, subs[i]); od;
  return AG_IsOneList(v, G);
end);


InstallMethod(FindGroupRelations, "for [IsList and IsAutomCollection, IsList, IsCyclotomic, IsCyclotomic]", true,
              [IsList and IsAutomCollection, IsList, IsCyclotomic, IsCyclotomic],
function(subs_words, names, max_len, num_of_rels)
  local G, gens, Gi, H, rel, rels, rels0, k, track_s, track_l, AssocW, FindGroupRelationsLocal, gens_autom, i, j, subs, subs1, w_list, FindGroupRelationsSubsLocal, w_ext, w, automgens, numstates, F, cur_gen;

  AssocW := function(w)
     return Product(List(w, i  ->  gens[i]));
  end;

  FindGroupRelationsSubsLocal := function(subs, G)
    local gr, len, ElList, GrList, inv, i, j, k, oldgr, v, tmpv, New, IsNewRelS, inverse, inverseS, H, FinG, tmpl, push, ProductEls, act, rels, LongCycle, invslist, invs, origlength, w, invadded, AssocWrels;

    inverse := function(w)
      local i, iw;
      iw := [];
      for i in [1..Length(w)] do
        iw[i] := w[Length(w)-i+1]^inv;
      od;
      return iw;
    end;

    inverseS := function(w)
      local i, iw;
      iw := [];
      for i in [1..Length(w)] do
        iw[i] := w[Length(w)-i+1]^invs;
      od;
      return iw;
    end;

    ProductEls := function(i, j)
      local t, v, tmpv;
      v := StructuralCopy(ElList[i]);
      Append(v, ElList[j]);
      for t in [1..Length(ElList)] do
        tmpv := StructuralCopy(v);
        Append(tmpv, inverse(ElList[t]));
        if AG_IsOneList(tmpv, G) then return t; fi;
      od;
    end;

    LongCycle := function(n)
      local l, i;
      l := [];
      for i in [2..n] do Add(l, i); od;
      Add(l, 1);
      return PermList(l);
    end;

    IsNewRelS := function(v)
      local  tmp, i, j, cyc, cycr, v_cyc, r_cyc, r, r_cyc_inv;
      cyc := LongCycle(Length(v));
      for i in [0..Length(v)-1] do
        v_cyc := Permuted(v, cyc^i);
        if v_cyc[1] = v_cyc[Length(v)]^invs then return false; fi;
        for r in rels do
          cycr := LongCycle(Length(r));
          for j in [0..Length(r)-1] do
            r_cyc := Permuted(r, cycr^j){[1..Int(Length(r)/2)+1]};
            r_cyc_inv := inverseS(Permuted(r, cycr^j)){[1..Int(Length(r)/2)+1]};
            if PositionSublist(v_cyc, r_cyc) <> fail or PositionSublist(v_cyc, r_cyc_inv) <> fail then
              return false;
            fi;
          od;
        od;
      od;
      return true;
    end;
#************************ FindGroupRelationsSubsLocal itself ****************************************************

    rels := [];
#    G := GroupOfAutomFamily(FamilyObj(subs_words[1]));
    inv := InversePerm(G);
  #check if there are any identity elements in subs list
    for i in [1..Length(subs)] do
      if AG_IsOneList(subs[i], G) then
        Error(AssocW([i]), " = id, remove this element from a list and try again");
      fi;
    od;

    AssocWrels := [];

  #check if there are any equal elements in subs list
    invslist := [];
    for i in [1..Length(subs)] do
      for j in [i..Length(subs)] do
        if i <> j and AG_IsOneList(Concatenation(subs[i], inverse(subs[j])), G) then
          Error(AssocW([i]), " = ", AssocW([j]), ", remove one of these elements from a list and try again");
        fi;

  #      Print(AG_IsOneList(Append(StructuralCopy(subs[i]), subs[j]), G), "\n");
  #      Print(Concatenation(subs[i], subs[j]), "\n");

        if AG_IsOneList(Concatenation(subs[i], subs[j]), G) then
          invslist[i] := j; invslist[j] := i;
          Add(rels, [i, j]);
          Add(AssocWrels, AssocW([i, j]));
          Print(AssocW([i, j]), "\n");
        fi;
      od;
    od;

  # add inverses to subs list
    origlength := Length(subs);
    invadded := false;
    for i in [1..origlength] do
      if not IsBound(invslist[i]) then
        invadded := true;
        Add(subs, inverse(subs[i]));
        Add(gens, gens[i]^-1);
        invslist[i] := Length(subs);
        invslist[Length(subs)] := i;
      fi;
    od;

    invs := PermList(invslist);

    GrList := [1, Length(subs)+1];
    ElList := [];

    gr := 1; len := 1;

    for i in [1..Length(subs)] do
      Add(ElList, [i]);
    od;
    while GrList[len+1] > GrList[len] and len < max_len and Length(rels) < num_of_rels do
      for i in [GrList[len]..GrList[len+1]-1] do
        oldgr := Length(ElList);
        for j in [1..Length(subs)] do
          v := StructuralCopy(ElList[i]);
          if j <> v[Length(v)]^invs then
            Add(v, j);
            New := true;
  #          k := 1;
            if len = 1 then k := 1; else k := GrList[len-1]; fi;
            while New and k <= oldgr do
              tmpv := StructuralCopy(v);
              Append(tmpv, inverseS(ElList[k]));
              if AG_IsOneWordSubs(tmpv, subs, G) then
                New := false;
  ## show relations
                if IsNewRelS(tmpv) then
                  Add(rels, tmpv);
                  if Length(AssocW(tmpv)) > 0 then
                    Add(AssocWrels, AssocW(tmpv));
                    Print(AssocW(tmpv), "\n");
                  fi;
                fi;
              fi;
              k := k+1;
            od;
            if New then Add(ElList, v); fi;
          fi;
        od;
      od;
      Add(GrList, Length(ElList)+1);
  #    Print("ElList[", len, "] = ", ElList, "\n");
      Info(InfoAutomGrp,3,"There are ", Length(ElList) + 1, " elements of length up to ", len+1);
      len := len+1;
    od;
    return AssocWrels;
  end;


#************************ FindGroupRelationsSubs itself ****************************************************

  if Length(subs_words) <> Length(names) then
    Error("The number of names must coincide with the number of generators");
  fi;
  F := FreeGroup(names);
  G := GroupOfAutomFamily(FamilyObj(subs_words[1]));

# gens is a mutable list of generators
  gens := ShallowCopy(GeneratorsOfGroup(F));

  automgens := UnderlyingAutomFamily(G)!.automgens;
  numstates := UnderlyingAutomFamily(G)!.numstates;

#convert associative words into lists
  subs1 := List(subs_words, CONVERT_ASSOCW_TO_LIST);

  Gi := StructuralCopy(AG_MinimizedAutomatonList(G));
#  Print("Gi = ", Gi, "\n");
  H := Gi[1];

  track_s := Gi[2];
  track_l := Gi[3];

  subs := [];

  for w in subs1 do
    w_list := [];
    for i in [1..Length(w)] do Add(w_list, track_l[w[i]]); od;
    Add(subs, ShallowCopy(w_list));
  od;
  rels0 := [];

#  for k in [1..Length(AutomatonList(G))] do
#  Print("Beam\n");
#    if track_l[k] = 1 then Add(rels0, AssocW([k]));
#      elif track_s[track_l[k]] <> k then Add(rels0, AssocW([k, track_s[track_l[k]]+Length(AutomatonList(G))]));
#    fi;
#  od;


  rels := FindGroupRelationsSubsLocal(subs, AG_ChooseAutomatonList(G));
  if rels = fail then return fail; fi;
  Append(rels0, rels);
#  Print(rels0);
  return rels0;
end);

InstallMethod(FindGroupRelations, "for [IsList and IsAutomCollection, IsList, IsCyclotomic]", true,
              [IsList and IsAutomCollection, IsList, IsCyclotomic],
function(subs_words, names, max_len)
  return FindGroupRelations(subs_words, names, max_len, infinity);
end);



InstallMethod(FindGroupRelations, "for [IsList and IsAutomCollection, IsList]",
              [IsList and IsAutomCollection, IsList],
function(subs_words, names)
  return FindGroupRelations(subs_words, names, infinity, infinity);
end);


InstallMethod(FindGroupRelations, "for [IsAutomGroup, IsCyclotomic, IsCyclotomic]", true,
              [IsAutomatonGroup, IsCyclotomic, IsCyclotomic],
function(G, max_len, num_of_rels)
  local gens, Gi, H, rel, rels, rels0, k, track_s, track_l, AssocW, FindGroupRelationsLocal;

  AssocW := function(w)
     #Print(w);
     return Product(List(w, i  ->  gens[i]));
  end;


  FindGroupRelationsLocal := function(subs, G)
    local gr, len, ElList, GrList, inv, i, j, k, oldgr, v, tmpv, New, IsNewRelS, inverse, inverseS, H, FinG, tmpl, push, ProductEls, act, rels, LongCycle, invslist, invs, origlength, w, invadded, tmpv_orig, AssocWrels;

    inverse := function(w)
      local i, iw;
      iw := [];
      for i in [1..Length(w)] do
        iw[i] := w[Length(w)-i+1]^inv;
      od;
      return iw;
    end;

    inverseS := function(w)
      local i, iw;
      iw := [];
      for i in [1..Length(w)] do
        iw[i] := w[Length(w)-i+1]^invs;
      od;
      return iw;
    end;

    ProductEls := function(i, j)
      local t, v, tmpv;
      v := StructuralCopy(ElList[i]);
      Append(v, ElList[j]);
      for t in [1..Length(ElList)] do
        tmpv := StructuralCopy(v);
        Append(tmpv, inverse(ElList[t]));
        if AG_IsOneList(tmpv, G) then return t; fi;
      od;
    end;

    LongCycle := function(n)
      local l, i;
      l := [2..n];
      Add(l, 1);
      return PermList(l);
    end;

    IsNewRelS := function(v)
      local  tmp, i, j, cyc, cycr, v_cyc, r_cyc, r, r_cyc_inv;
      cyc := LongCycle(Length(v));
      for i in [0..Length(v)-1] do
        v_cyc := Permuted(v, cyc^i);
        if v_cyc[1] = v_cyc[Length(v)]^invs then return false; fi;
        for r in rels do
          cycr := LongCycle(Length(r));
          for j in [0..Length(r)-1] do
            r_cyc := Permuted(r, cycr^j){[1..Int(Length(r)/2)+1]};;
            r_cyc_inv := inverseS(Permuted(r, cycr^j)){[1..Int(Length(r)/2)+1]};;
            if PositionSublist(v_cyc, r_cyc) <> fail or PositionSublist(v_cyc, r_cyc_inv) <> fail then
              return false;
            fi;
          od;
        od;
      od;
      return true;
    end;
#************************ FindGroupRelationsLocal itself ****************************************************

    rels := [];
    AssocWrels := [];
    inv := InversePerm(G);


    invslist := [];
    for i in [1..Length(subs)] do
      for j in [i..Length(subs)] do
#        Print(AssocW([Gi[2][i+1], Gi[2][j+1]])!.word, "\n");
        if AG_IsOneList(Concatenation(subs[i], subs[j]), G) then
          invslist[i] := j; invslist[j] := i;
          if Length(AssocW([Gi[2][i+1], Gi[2][j+1]])!.word) > 0 then
            Add(rels, [i, j]);
            Add(AssocWrels, AssocW([Gi[2][i+1], Gi[2][j+1]]));
            Print( AssocW([Gi[2][i+1], Gi[2][j+1]])!.word, "\n");
          fi;
        fi;
      od;
    od;

    invs := PermList(invslist);

    GrList := [1, Length(subs)+1];
    ElList := [];

    gr := 1; len := 1;

    for i in [1..Length(subs)] do
      Add(ElList, [i]);
    od;
    while GrList[len+1] > GrList[len] and len < max_len and Length(rels) < num_of_rels do
      for i in [GrList[len]..GrList[len+1]-1] do
        oldgr := Length(ElList);
        for j in [1..Length(subs)] do
          v := StructuralCopy(ElList[i]);
          if j <> v[Length(v)]^invs then
            Add(v, j);
            New := true;
 #          k := 1;
            if len = 1 then k := 1; else k := GrList[len-1]; fi;
            while New and k <= oldgr do
              tmpv := StructuralCopy(v);
              Append(tmpv, inverseS(ElList[k]));
              if AG_IsOneWordSubs(tmpv, subs, G) then
                New := false;
## show relations
                if IsNewRelS(tmpv) then
# tmpv in the original generators
                  tmpv_orig := [];
                  for k in [1..Length(tmpv)] do
                    tmpv_orig[k] := Gi[2][tmpv[k]+1];
                  od;
                  Add(rels, tmpv);
                  if Length(AssocW(tmpv_orig)!.word) > 0 then
                    Add(AssocWrels, AssocW(tmpv_orig));
                    Print( AssocW(tmpv_orig)!.word, "\n");
                  fi;
#                 Print(tmpv, "\n");
                fi;
              fi;
              k := k+1;
            od;
            if New then Add(ElList, v); fi;
          fi;
        od;
      od;
      Add(GrList, Length(ElList)+1);
 #    Print("ElList[", len, "] = ", ElList, "\n");
      Info(InfoAutomGrp, 3, "There are ", Length(ElList) + 1, " elements of length up to ", len + 1);
      len := len+1;
    od;
    return AssocWrels;
  end;

#************************ FindGroupRelations itself ****************************************************

  gens := ShallowCopy(UnderlyingAutomFamily(G)!.automgens);

  Gi := StructuralCopy(AG_MinimizedAutomatonList(G));
#  Print("Gi = ", Gi, "\n");
  H := Gi[1];

  track_s := Gi[2];
  track_l := Gi[3];
  rels0 := [];

#  for k in [1..Length(AutomatonList(G))] do
#  Print("Beam\n");
#    if track_l[k] = 1 then Add(rels0, AssocW([k]));
#      elif track_s[track_l[k]] <> k then Add(rels0, AssocW([k, track_s[track_l[k]]+Length(AutomatonList(G))]));
#    fi;
#  od;


  rels := FindGroupRelationsLocal(List([2..Length(H)], i -> [i]), AG_ChooseAutomatonList(G));
  Append(rels0, rels);
#  Print(rels0);
  return rels0;
end);


InstallMethod(FindGroupRelations, "for [IsAutomGroup, IsCyclotomic]", true,
              [IsAutomatonGroup, IsCyclotomic],
function(G, max_len)
  return FindGroupRelations(G, max_len, infinity);
end);


InstallMethod(FindGroupRelations, "for [IsAutomGroup]",
              [IsAutomatonGroup],
function(G)
  return FindGroupRelations(G, infinity, infinity);
end);



InstallMethod(FindGroupRelations, "for [IsList and IsAutomCollection, IsCyclotomic, IsCyclotomic]", true,
              [IsList and IsAutomCollection, IsCyclotomic, IsCyclotomic],
function(subs_words, max_len, num_of_rels)
  return FindGroupRelations(GroupWithGenerators(subs_words), max_len, infinity);
end);



InstallMethod(FindGroupRelations, "for [IsList and IsAutomCollection, IsCyclotomic]", true,
              [IsList and IsAutomCollection, IsCyclotomic],
function(subs_words, max_len)
  return FindGroupRelations(subs_words, max_len, infinity);
end);


InstallMethod(FindGroupRelations, "for [IsList and IsAutomCollection]",
              [IsList and IsAutomCollection],
function(subs_words)
  return FindGroupRelations(subs_words, infinity, infinity);
end);




InstallMethod(FindGroupRelations, "for [IsGroup, IsCyclotomic, IsCyclotomic]", true,
              [IsGroup, IsCyclotomic, IsCyclotomic],
function(G, max_len, num_of_rels)
  local ElList, GrList, i, j, orig_gens, gen, gens, new_gen, g, len, oldgr, New, k, rels, rel, F, relsF, ElListF, genf, f, fgens, all_relsF, rel1, new_rel, r, orig_fgens, \
        IsNewRel, CyclicConjugates, ngens, FFhom_images, FFhom, FGhom_images, FGhom, ElList_inv, inv_gens, cur_rel;

  IsNewRel := function(rel)
    local rel1, r;
    rel1 := rel;
    repeat
      for r in all_relsF do
        if PositionWord(rel1, Subword(r,1,Int(Length(r)/2)+1), 1) <> fail then return false; fi;
      od;
      rel1 := rel1^Subword(rel1, 1, 1);
    until rel1 = rel;
    return true;
  end;


  CyclicConjugates := function(rel)
    local rel1, conjs;
    rel1 := rel;  conjs := [];
    repeat
      rel1 := rel1^Subword(rel1, 1, 1);
      Add(conjs, rel1);
    until rel1 = rel;
    return conjs;
  end;



  orig_gens := ShallowCopy(GeneratorsOfGroup(G));
  ngens := Length(orig_gens);

  F := FreeGroup(ngens);
  orig_fgens := ShallowCopy(GeneratorsOfGroup(F));
  FFhom_images := ShallowCopy(GeneratorsOfGroup(F));
  FGhom_images := ShallowCopy(GeneratorsOfGroup(G));

  Append(orig_gens, List(orig_gens, x -> x^-1));
  Append(orig_fgens, List(orig_fgens, x -> x^-1));

  gens := [];
  fgens := [];
  rels := [];
  relsF := [];
  all_relsF := [];

# select pairwise different generators
  for i in [1..Length(orig_gens)] do
    if not IsOne(orig_gens[i]) then
      new_gen := true;
      for j in [1..i-1] do
        if orig_gens[i] = orig_gens[j] then
          new_gen := false;
          if IsNewRel(orig_fgens[i]^-1*orig_fgens[j]) then
            if not IsIdenticalObj(orig_gens[i], orig_gens[j]) then
              Add(rels, orig_gens[i]^-1*orig_gens[j]);
              Print( orig_gens[i]^-1*orig_gens[j], "\n");
            fi;
            Add(relsF, orig_fgens[i]^-1*orig_fgens[j]);
            Append(all_relsF, CyclicConjugates(orig_fgens[i]^-1*orig_fgens[j]));
            if i > ngens and j <= ngens then
#              hom_images[i-ngens] := orig_gens[j+ngens];
#              hom_images[j] := orig_gens[i];
              FFhom_images[i-ngens] := orig_fgens[j+ngens];
              FFhom_images[j] := orig_fgens[i];
            fi;
          fi;
          break;
        fi;
      od;
      if new_gen then
        Add(gens, orig_gens[i]);
        Add(fgens, orig_fgens[i]);
        if i <= ngens then
          FGhom_images[i] := orig_gens[i];
        fi;
      fi;
    else
      if not IsIdenticalObj(orig_gens[i], One(orig_gens[i])) then
        Add(rels, orig_gens[i]);
        Print( orig_gens[i], "\n");
      fi;
#
#      Add(relsF, orig_fgens[i]);
    fi;
  od;


#  inv_gens := [];
#  for i in [1..Length(gens)] do
#    for j in [1..i] do
#      if IsOne(gens[i]*gens[j]) then
#        inv_gens[i] := gens[j]; inv_gens[j] := gens[i];
#      fi;
#    od;
#  od;


#  Print("gens = ", gens, "\n");
#  Print("inv_gens = ", inv_gens, "\n");

  FFhom := GroupHomomorphismByImagesNC(F, F, GeneratorsOfGroup(F), FFhom_images);
  FGhom := GroupHomomorphismByImagesNC(F, G, GeneratorsOfGroup(F), FGhom_images);
#  Print("hom = ", hom, "\n");

  ElList := [One(G)];
#  ElList_inv := [One(G)];
  ElListF := [One(F)];

  Append(ElList, ShallowCopy(gens));
#  Append(ElList_inv, ShallowCopy(inv_gens));
  Append(ElListF, ShallowCopy(fgens));

  GrList := [1, Length(gens)+1];

  len := 1;

  while GrList[len] <> GrList[len+1] and len < max_len and Length(rels) < num_of_rels  do
    for i in [GrList[len]+1..GrList[len+1]] do
      oldgr := Length(ElList);
      for j in [1..Length(gens)] do
        f := ElListF[i]*fgens[j];
        if Length(f) > Length(ElListF[i]) then
          g := ElList[i]*gens[j];
          New := true;
          if len = 1 then k := 1; else k := GrList[len-1]; fi;
          while New and k <= oldgr do
            if g = ElList[k] then
              New := false;
            fi;
            k := k+1;
          od;
          if New then
            Add(ElList, g);
#            Add(ElList_inv, inv_gens[j]*ElList_inv[i]);
            Add(ElListF, f);
          else
            new_rel := true;
            rel := CyclicallyReducedWord(Image(FFhom, f^-1)*ElListF[k-1]);
            if Length(rel) < Length(f)+Length(ElListF[k-1]) then new_rel := false; fi;


            if new_rel and IsNewRel(rel) and IsNewRel(Image(FFhom, rel^-1)) then
#              Add(rels, inv_gens[j]*ElList_inv[i]*ElList[k-1]);
              cur_rel := Image(FGhom, rel);
              Add(rels, cur_rel);
              Add(relsF, rel);
              Print( cur_rel, "\n");
              Append(all_relsF, CyclicConjugates(rel));
            fi;

          fi;
        fi;
      od;
    od;
    Add(GrList, Length(ElList));
    Info(InfoAutomGrp, 3, "There are ", Length(ElList), " elements of length up to ", len+1);
    len := len+1;
  od;
  if GrList[len] = GrList[len+1] then
    SetSize(G, GrList[len]);
  fi;
  return rels;
end);




InstallMethod(FindGroupRelations, "for [IsGroup, IsCyclotomic]", true,
              [IsGroup, IsCyclotomic],
function(G, max_len)
  return FindGroupRelations(G, max_len, infinity);
end);


InstallMethod(FindGroupRelations, "for [IsGroup]",
              [IsGroup],
function(G)
  return FindGroupRelations(G, infinity, infinity);
end);




InstallMethod(FindGroupRelations, "for [IsList, IsCyclotomic, IsCyclotomic]", true,
              [IsList, IsCyclotomic, IsCyclotomic],
function(subs_words, max_len, num_of_rels)
  return FindGroupRelations(GroupWithGenerators(subs_words), max_len, infinity);
end);



InstallMethod(FindGroupRelations, "for [IsList, IsCyclotomic]", true,
              [IsList, IsCyclotomic],
function(subs_words, max_len)
  return FindGroupRelations(subs_words, max_len, infinity);
end);


InstallMethod(FindGroupRelations, "for [IsList]",
              [IsList],
function(subs_words)
  return FindGroupRelations(subs_words, infinity, infinity);
end);





InstallMethod(FindGroupRelations, "for [IsList, IsList, IsCyclotomic, IsCyclotomic]", true,
              [IsList, IsList, IsCyclotomic, IsCyclotomic],
function(subs_words, names, max_len, num_of_rels)
  local ElList, GrList, i, j, orig_gens, gen, gens, new_gen, g, len, oldgr, New, k, rel, F, relsF, ElListF, genf, f, fgens, all_relsF, rel1, new_rel, r, orig_fgens, \
        IsNewRel, CyclicConjugates, ngens, FFhom_images, FFhom;

  IsNewRel := function(rel)
    local rel1, r;
    rel1 := rel;
    repeat
      for r in all_relsF do
        if PositionWord(rel1, Subword(r,1,Int(Length(r)/2)+1), 1) <> fail then return false; fi;
      od;
      rel1 := rel1^Subword(rel1, 1, 1);
    until rel1 = rel;
    return true;
  end;


  CyclicConjugates := function(rel)
    local rel1, conjs;
    rel1 := rel;  conjs := [];
    repeat
      rel1 := rel1^Subword(rel1, 1, 1);
      Add(conjs, rel1);
    until rel1 = rel;
    return conjs;
  end;



  if Length(subs_words) <> Length(names) then
    Error("The number of names must coincide with the number of generators");
  fi;

  orig_gens := ShallowCopy(subs_words);

  F := FreeGroup(names);
  orig_fgens := ShallowCopy(GeneratorsOfGroup(F));
  ngens := Length(orig_gens);

  FFhom_images := ShallowCopy(GeneratorsOfGroup(F));


  Append(orig_gens, List(orig_gens, x -> x^-1));
  Append(orig_fgens, List(orig_fgens, x -> x^-1));

  gens := [];
  fgens := [];
  relsF := [];
  all_relsF := [];

# select pairwise different generators
  for i in [1..Length(orig_gens)] do
    if not IsOne(orig_gens[i]) then
      new_gen := true;
      for j in [1..i-1] do
        if orig_gens[i] = orig_gens[j] then
          new_gen := false;
          if IsNewRel(orig_fgens[i]^-1*orig_fgens[j]) then
            Add(relsF, orig_fgens[i]^-1*orig_fgens[j]);
            Print(orig_fgens[i]^-1*orig_fgens[j], "\n");

            Append(all_relsF, CyclicConjugates(orig_fgens[i]^-1*orig_fgens[j]));
            if i > ngens and j <= ngens then
              FFhom_images[i-ngens] := orig_fgens[j+ngens];
              FFhom_images[j] := orig_fgens[i];
            fi;
          fi;
          break;
        fi;
      od;
      if new_gen then
        Add(gens, orig_gens[i]);
        Add(fgens, orig_fgens[i]);
      fi;
    else
      Add(relsF, orig_fgens[i]);
      Print(orig_fgens[i], "\n");
    fi;
  od;


  FFhom := GroupHomomorphismByImagesNC(F, F, GeneratorsOfGroup(F), FFhom_images);

  ElList := [One(subs_words[1])];
  ElListF := [One(F)];

  Append(ElList, ShallowCopy(gens));
  Append(ElListF, ShallowCopy(fgens));

  GrList := [1, Length(gens)+1];

  len := 1;

  while GrList[len] <> GrList[len+1] and len < max_len and Length(relsF) < num_of_rels  do
    for i in [GrList[len]+1..GrList[len+1]] do
      oldgr := Length(ElList);
      for j in [1..Length(gens)] do
        f := ElListF[i]*fgens[j];
        if Length(f) > Length(ElListF[i]) then
          g := ElList[i]*gens[j];
          New := true;
          if len = 1 then k := 1; else k := GrList[len-1]; fi;
          while New and k <= oldgr do
            if g = ElList[k] then
              New := false;
            fi;
            k := k+1;
          od;
          if New then
            Add(ElList, g);
            Add(ElListF, f);
          else
            new_rel := true;
            rel := CyclicallyReducedWord(Image(FFhom, f^-1)*ElListF[k-1]);
            if Length(rel) < Length(f)+Length(ElListF[k-1]) then new_rel := false; fi;


            if new_rel and IsNewRel(rel) and IsNewRel(Image(FFhom, rel^-1)) then
              Add(relsF, rel);
              Print( rel, "\n");
              Append(all_relsF, CyclicConjugates(rel));
            fi;

          fi;
        fi;
      od;
    od;
    Add(GrList, Length(ElList));
    Info(InfoAutomGrp, 3, "There are ", Length(ElList), " elements of length up to ", len+1);
    len := len+1;
  od;
  return relsF;
end);



InstallMethod(FindGroupRelations, "for [IsList, IsList, IsCyclotomic]", true,
              [IsList, IsList, IsCyclotomic],
function(subs_words, names, max_len)
  return FindGroupRelations(subs_words, names, max_len, infinity);
end);


InstallMethod(FindGroupRelations, "for [IsList, IsList]", true,
              [IsList, IsList],
function(subs_words, names)
  return FindGroupRelations(subs_words, names, infinity, infinity);
end);


# InstallMethod(FindSemigroupRelations, "for [IsAutomSemigroup, IsCyclotomic, IsCyclotomic]", true,
#               [IsAutomSemigroup, IsCyclotomic, IsCyclotomic],
# function(G, max_len, num_of_rels)
#   local ElList, GrList, i, j, orig_gens, gen, gens, new_gen, g, len, oldgr, New, k, has_one, rels, rel;
#
#   orig_gens := ShallowCopy(GeneratorsOfSemigroup(G));
#
#   gens := [];
#   rels := [];
#   has_one := false;
#
# # select pairwise different generators
#   for i in [1..Length(orig_gens)] do
#     if not IsOne(orig_gens[i]) then
#       new_gen := true;
#       for j in [1..i-1] do
#         if orig_gens[i] = orig_gens[j] then
#           new_gen := false;
#           if not Word(orig_gens[i]) = Word(orig_gens[j]) then
#             Add(rels, [orig_gens[i], orig_gens[j]]);
#           fi;
#           break;
#         fi;
#       od;
#       if new_gen then Add(gens, orig_gens[i]); fi;
#     else
#       if not Word(orig_gens[i]) = Word(One(orig_gens[i])) then
#         Add(rels, [orig_gens[i], One(orig_gens[i])]);
#       fi;
#       has_one := true;
#     fi;
#   od;
#
#   if has_one then
#     ElList := [One(G)];
#     GrList := [1];
#   else
#     ElList := [];
#     GrList := [0];
#   fi;
#
#   Append(ElList, ShallowCopy(gens));
#   Add(GrList, Length(gens)+GrList[1]);
#   len := 1;
#
#   while GrList[len] <> GrList[len+1] and len < max_len and Length(rels) < num_of_rels  do
#     for i in [GrList[len]+1..GrList[len+1]] do
#       oldgr := Length(ElList);
#       for gen in gens do
#         g := ElList[i]*gen;
#         New := true;
#
# #        Print("g = ", g, "\n");
# #        Print("rels = ", rels, "\n");
#
# # If g includes a longer part of some relation it can not represent
# # neither a new element, nor be involved in a new relation
#
#         for rel in rels do
#           if PositionWord(Word(g), Word(rel[1]), 1) <> fail then New := false; fi;
#         od;
#
# #        Print("New el/rel:", New, "\n");
#         if New then
#
#           k := 0;
#           while New and k < Length(ElList) do
#             k := k+1;
#             if g = ElList[k] then
#               New := false;
#             fi;
#           od;
# #          Print("New el:", New, "\n");
#           if New then
#             Add(ElList, g);
#           else
#             if not Word(g) = Word(ElList[k]) then
#               Add(rels, [g, ElList[k]]);
#               Print( g, " = ", ElList[k], "\n");
#             fi;
#           fi;
#         fi;
# #        Print("\n\n\n");
#       od;
#     od;
#     Add(GrList, Length(ElList));
#     Info(InfoAutomGrp, 3, "There are ", Length(ElList), " elements of length up to ", len+1);
#     len := len+1;
#   od;
#   if GrList[len] = GrList[len+1] then
#     SetSize(G, GrList[len]);
#   fi;
#   return rels;
# end);
#
#
#
# InstallMethod(FindSemigroupRelations, "for [IsAutomSemigroup, IsCyclotomic]", true,
#               [IsAutomSemigroup, IsCyclotomic],
# function(G, max_len)
#   return FindSemigroupRelations(G, max_len, infinity);
# end);
#
#
# InstallMethod(FindSemigroupRelations, "for [IsAutomSemigroup]",
#               [IsAutomSemigroup],
# function(G)
#   return FindSemigroupRelations(G, infinity, infinity);
# end);



InstallMethod(FindSemigroupRelations, "for [IsSemigroup, IsCyclotomic, IsCyclotomic]", true,
              [IsSemigroup, IsCyclotomic, IsCyclotomic],
function(G, max_len, num_of_rels)
  local ElList, GrList, i, j, orig_gens, gen, gens, new_gen, g, len, oldgr, New, k, has_one, rels, rel, F, relsF, ElListF, genf, f;

  orig_gens := ShallowCopy(GeneratorsOfSemigroup(G));

  gens := [];
  rels := [];
  relsF := [];
  has_one := false;

# select pairwise different generators
  for i in [1..Length(orig_gens)] do
    if not IsOne(orig_gens[i]) then
      new_gen := true;
      for j in [1..i-1] do
        if orig_gens[i] = orig_gens[j] then
          new_gen := false;
          if not IsIdenticalObj(orig_gens[i], orig_gens[j]) then
            Add(rels, [orig_gens[i], orig_gens[j]]);
          fi;
          break;
        fi;
      od;
      if new_gen then Add(gens, orig_gens[i]); fi;
    else
      if not IsIdenticalObj(orig_gens[i], One(orig_gens[i])) then
        Add(rels, [orig_gens[i], One(orig_gens[i])]);
      fi;
      has_one := true;
    fi;
  od;

  F := FreeGroup(Length(gens));

  if has_one then
    ElList := [One(G)];
    ElListF := [One(F)];
    GrList := [1];
  else
    ElList := [];
    ElListF := [];
    GrList := [0];
  fi;

  Append(ElList, ShallowCopy(gens));
  Append(ElListF, GeneratorsOfGroup(F));
  Add(GrList, Length(gens)+GrList[1]);
  len := 1;

  while GrList[len] <> GrList[len+1] and len < max_len and Length(rels) < num_of_rels  do
    for i in [GrList[len]+1..GrList[len+1]] do
      oldgr := Length(ElList);
      for j in [1..Length(gens)] do
        gen := gens[j];
        genf := GeneratorsOfGroup(F)[j];
        g := ElList[i]*gen;
        f := ElListF[i]*genf;
        New := true;

# If g includes a longer part of some relation it can not represent
# neither a new element, nor be involved in a new relation
        for rel in relsF do
          if PositionSublist(LetterRepAssocWord(f), LetterRepAssocWord(rel[1]) ) <> fail then New := false; fi;
        od;

#        Print("New = ", New, "\n\n");
        if New then

          k := 0;
          while New and k < Length(ElList) do
            k := k+1;
            if g = ElList[k] then
              New := false;
            fi;
          od;
          if New then
            Add(ElList, g);
            Add(ElListF, f);
          else
            Add(rels, [g, ElList[k]]);
            Add(relsF, [f, ElListF[k]]);
  #          if Length(AssocW(v)) > 0 then
            Print(g, " = ", ElList[k], "\n");
  #          fi;
          fi;
        fi;
      od;
    od;
    Add(GrList, Length(ElList));
    Info(InfoAutomGrp, 3, "There are ", Length(ElList), " elements of length up to ", len+1);
    len := len+1;
  od;
  if GrList[len] = GrList[len+1] then
    SetSize(G, GrList[len]);
  fi;
  return rels;
end);


InstallMethod(FindSemigroupRelations, "for [IsSemigroup, IsCyclotomic]", true,
              [IsSemigroup, IsCyclotomic],
function(G, max_len)
  return FindSemigroupRelations(G, max_len, infinity);
end);


InstallMethod(FindSemigroupRelations, "for [IsSemigroup]",
              [IsSemigroup],
function(G)
  return FindSemigroupRelations(G, infinity, infinity);
end);



InstallMethod(FindSemigroupRelations, "for [IsList, IsCyclotomic, IsCyclotomic]", true,
              [IsList, IsCyclotomic, IsCyclotomic],
function(subs_words, max_len, num_of_rels)
  return FindSemigroupRelations(SemigroupByGenerators(subs_words), max_len, num_of_rels);
end);



InstallMethod(FindSemigroupRelations, "for [IsList, IsCyclotomic]", true,
              [IsList, IsCyclotomic],
function(subs_words, max_len)
  return FindSemigroupRelations(subs_words, max_len, infinity);
end);


InstallMethod(FindSemigroupRelations, "for [IsList]",
              [IsList],
function(subs_words)
  return FindSemigroupRelations(subs_words, infinity, infinity);
end);



InstallMethod(FindSemigroupRelations, "for [IsList, IsList, IsCyclotomic, IsCyclotomic]", true,
              [IsList, IsList, IsCyclotomic, IsCyclotomic],
function(subs_words, names, max_len, num_of_rels)
  local ElList, GrList, i, j, orig_gens, orig_fgens, gen, gens, fgens, new_gen, g, len, oldgr, New, k, has_one, rel, F, relsF, ElListF, genf, f;

  if Length(subs_words) <> Length(names) then
    Error("The number of names must coincide with the number of generators");
  fi;
  F := FreeGroup(names);
  orig_fgens := GeneratorsOfGroup(F);


  orig_gens := ShallowCopy(subs_words);

  gens := [];
  fgens := [];
  relsF := [];
  has_one := false;

# select pairwise different generators
  for i in [1..Length(orig_gens)] do
    if not IsOne(orig_gens[i]) then
      new_gen := true;
      for j in [1..i-1] do
        if orig_gens[i] = orig_gens[j] then
          new_gen := false;
          Add(relsF, [orig_fgens[i], orig_fgens[j]]);
          Print( orig_fgens[i], " = ", orig_fgens[j], "\n");
          break;
        fi;
      od;
      if new_gen then
        Add(gens, orig_gens[i]);
        Add(fgens, orig_fgens[i]);
      fi;
    else
      Add(relsF, [orig_fgens[i], One(orig_fgens[i])]);
      Print( orig_fgens[i], " = ", One(F), "\n");
      has_one := true;
    fi;
  od;


  if has_one then
    ElList := [One(gens[1])];
    ElListF := [One(F)];
    GrList := [1];
  else
    ElList := [];
    ElListF := [];
    GrList := [0];
  fi;

  Append(ElList, ShallowCopy(gens));
  Append(ElListF, fgens);
  Add(GrList, Length(gens)+GrList[1]);
  len := 1;

  while GrList[len] <> GrList[len+1] and len < max_len and Length(relsF) < num_of_rels  do
    for i in [GrList[len]+1..GrList[len+1]] do
      oldgr := Length(ElList);
      for j in [1..Length(gens)] do
        gen := gens[j];
        genf := fgens[j];
        g := ElList[i]*gen;
        f := ElListF[i]*genf;
        New := true;

# If g includes a longer part of some relation it can not represent
# neither a new element, nor be involved in a new relation
        for rel in relsF do
          if PositionSublist(LetterRepAssocWord(f), LetterRepAssocWord(rel[1]) ) <> fail then New := false; fi;
        od;

        if New then
          k := 0;
          while New and k < Length(ElList) do
            k := k+1;
            if g = ElList[k] then
              New := false;
            fi;
          od;
          if New then
            Add(ElList, g);
            Add(ElListF, f);
          else
            Add(relsF, [f, ElListF[k]]);
            Print( f, " = ", ElListF[k], "\n");
          fi;
        fi;
      od;
    od;
    Add(GrList, Length(ElList));
    Info(InfoAutomGrp, 3, "There are ", Length(ElList), " elements of length up to ", len+1);
    len := len+1;
  od;
  return relsF;
end);



InstallMethod(FindSemigroupRelations, "for [IsList, IsList, IsCyclotomic]", true,
              [IsList, IsList, IsCyclotomic],
function(subs_words, names, max_len)
  return FindSemigroupRelations(subs_words, names, max_len, infinity);
end);


InstallMethod(FindSemigroupRelations, "for [IsList, IsList]", true,
              [IsList, IsList],
function(subs_words, names)
  return FindSemigroupRelations(subs_words, names, infinity, infinity);
end);




InstallMethod(OrderUsingSections, "for [IsAutom, IsCyclotomic]", true,
              [IsAutom, IsCyclotomic],
function(a, max_depth)
  local OrderUsingSections_LOCAL, cur_list, F, degs, vertex, AreConjugateUsingSmallRels, gens_ord2, CyclicallyReduce, res;

  CyclicallyReduce := function(w)
    local i, j, wtmp, reduced;

    for i in [1..Length(w)] do
      if -w[i] in gens_ord2 then w[i] := -w[i]; fi;
    od;

    repeat
      reduced := true;
      j := 1;
      while reduced  and j < Length(w) do
        if w[j] = -w[j+1] or (w[j] = w[j+1] and w[j] in gens_ord2) then
          reduced := false;
          wtmp := ShallowCopy(w{[1..j-1]});
          Append(wtmp, w{[j+2..Length(w)]});
          w := wtmp;
        fi;
        j := j+1;
      od;
    until reduced;

    repeat
      if Length(w) < 2 then return w; fi;
      reduced := true;
      if w[1] = -w[Length(w)] or (w[1] = w[Length(w)] and w[1] in gens_ord2) then
        w := w{[2..Length(w)-1]};
        reduced := false;
      fi;
    until reduced;

    return w;
  end;

  AreConjugateUsingSmallRels := function(g, h)
    local i, g_list, h_list, long_cycle, l;
    g_list := CyclicallyReduce(LetterRepAssocWord(g));
    h_list := CyclicallyReduce(LetterRepAssocWord(h));
    if Length(g_list) <> Length(h_list) then return false; fi;
    l := [2..Length(g_list)];
    Add(l, 1);
    long_cycle := PermList(l);
    for i in [0..Length(g_list)-1] do
      if h_list = Permuted(g_list, long_cycle^i) then return true; fi;
    od;
    return false;
  end;

  OrderUsingSections_LOCAL := function(g)
    local i, el, orb, Orbs, res, st, reduced_word, loc_order;
#    Print("vertex=",vertex,"\n");
#    Print("g=",g,"\n");
    if IsOne(g) then return 1; fi;

    if IsActingOnBinaryTree(g) and
       not HasContainsSphericallyTransitiveElement(GroupOfAutomFamily(FamilyObj(g))) or
       (HasContainsSphericallyTransitiveElement(GroupOfAutomFamily(FamilyObj(g))) and
       ContainsSphericallyTransitiveElement(GroupOfAutomFamily(FamilyObj(g)))) then
          if IsSphericallyTransitive(g) then
            Info(InfoAutomGrp, 3, g!.word, " acts transitively on levels and is obtained from (", a!.word, ")^", Product(degs{[1..Length(degs)]}), "\n    by taking sections and cyclic reductions at vertex ", vertex);
            return infinity;
          fi;
    fi;
    for i in [1..Length(cur_list)] do
      el := cur_list[i];
      if (AreConjugateUsingSmallRels(g!.word, el!.word) or AreConjugateUsingSmallRels((g!.word)^(-1), el!.word)) then
        if Product(degs{[i..Length(degs)]}) > 1 then
          if i > 1 then Info(InfoAutomGrp, 3, el!.word, " is obtained from (", a!.word, ")^", Product(degs{[1..i-1]}), "\n    by taking sections and cyclic reductions at vertex ", vertex{[1..i-1]}); fi;
          Info(InfoAutomGrp, 3, g!.word, " is obtained from (", el!.word, ")^", Product(degs{[i..Length(degs)]}), "\n    by taking sections and cyclic reductions at vertex ", vertex{[i..Length(degs)]});
          SetIsFinite(GroupOfAutomFamily(FamilyObj(a)), false);
          return infinity;
        else
#          Info(InfoAutomGrp, 3, "The group  <G>  might not be contracting, ", g, " has itself as a section.");
          return 1;
        fi;
      fi;
    od;
    if Length(cur_list) >= max_depth then return fail; fi;
    Add(cur_list, g);
    Orbs := OrbitsPerms([g!.perm], [1..g!.deg]);
    loc_order := 1;

    for orb in Orbs do
      Add(degs, Length(orb));
      Add(vertex, orb[1]);
#      res := OrderUsingSections_LOCAL(Autom(CyclicallyReducedWord(Section(g^Length(orb), orb[1])!.word), FamilyObj(g)));
#      Print(g^Length(orb), "\n");
      st := Section(g^Length(orb), orb[1]);
      reduced_word := AssocWordByLetterRep(FamilyObj(st!.word), CyclicallyReduce(LetterRepAssocWord(st!.word)));
#      Print(st!.word, " at ", vertex, "\n");
      res := OrderUsingSections_LOCAL(Autom(reduced_word, FamilyObj(g)));
      if res = infinity then return res;
      elif res=fail then
        loc_order:=fail;
      fi;
      if loc_order<>fail then
        loc_order := Lcm(loc_order, res*Length(orb));
      fi;
      Remove(degs);
      Remove(vertex);
    od;
    Remove(cur_list);
    return loc_order;
  end;

  F := FamilyObj(a)!.freegroup;
  gens_ord2 := GeneratorsOfOrderTwo(FamilyObj(a));
  cur_list := [];
# degs traces at what positions we raise to what power
  degs := []; vertex := [];
  res := OrderUsingSections_LOCAL(a);
  if res = infinity then
    SetIsFinite(GroupOfAutomFamily(FamilyObj(a)), false);
    SetOrder(a, infinity);
  fi;
  return res;
end);



InstallMethod(OrderUsingSections, "for [IsAutom]", true,
              [IsAutom],
function(a)
  return OrderUsingSections(a, infinity);
end);



InstallGlobalFunction(AG_SuspiciousForNoncontraction, function(arg)
  local AG_SuspiciousForNoncontraction_LOCAL, cur_list, F, vertex, print_info, a;

  AG_SuspiciousForNoncontraction_LOCAL := function(g)
  local i, res;
    if IsOne(g) or g!.perm <> () then return false; fi;

    if (g!.word in cur_list) or (g!.word^(-1) in cur_list) then
      if g = a or g = a^-1 then
        if print_info then
          Info(InfoAutomGrp, 3, a!.word, " has ", g!.word, " as a section at vertex ", vertex);
        else
          Info(InfoAutomGrp, 5, a!.word, " has ", g!.word, " as a section at vertex ", vertex);
        fi;
        return true;
      else return false;  fi;
    fi;

    Add(cur_list, g!.word);

    for i in [1..FamilyObj(a)!.deg] do
      Add(vertex, i);
      res := AG_SuspiciousForNoncontraction_LOCAL(Section(g, i));
      if res then return true; fi;
      Unbind(vertex[Length(vertex)]);
    od;
    return false;
  end;

  a := arg[1];
  print_info := false;

  if Length(arg)  >  1 then print_info := arg[2]; fi;
  if Length(arg)  >  2 then Error("invalid arguments for IsNoncontracting"); fi;

  F := FamilyObj(a)!.freegroup;
  cur_list := [];
# degs traces at what positions we raise to what power
  vertex := [];
  return AG_SuspiciousForNoncontraction_LOCAL(a);
end);



InstallMethod(FindElement, "for [IsAutomGroup, IsFunction, IsObject, IsCyclotomic]", true,
              [IsAutomGroup, IsFunction, IsObject, IsCyclotomic],
function(G, func, val, n)
  local ElList, GrList, i, j, orig_gens, gen, gens, new_gen, g, len, viewed, oldgr, New, k;

  if func(One(G)) = val then return One(G); fi;

# produce a symmetric generating set
  orig_gens := ShallowCopy(GeneratorsOfGroup(G));
  Append(orig_gens, List(orig_gens, x -> x^-1));

  gens := [];

# select pairwise different generators
  for i in [1..Length(orig_gens)] do
    if not IsOne(orig_gens[i]) then
      new_gen := true;
      for j in [1..i-1] do if orig_gens[i] = orig_gens[j] then new_gen := false; fi; od;
      if new_gen then Add(gens, orig_gens[i]); fi;
    fi;
  od;

  for g in gens do
    if func(g) = val then return g; fi;
  od;

  ElList := [One(G)]; Append(ElList, ShallowCopy(gens));
  GrList := [1, Length(gens)+1];
  len := 1;

  while len < n and GrList[len] <> GrList[len+1] do
    for i in [GrList[len]+1..GrList[len+1]] do
      oldgr := Length(ElList);
      for gen in gens do
        g := ElList[i]*gen;
        New := true;
        if len = 1 then k := 1; else k := GrList[len-1]; fi;
        while New and k <= oldgr do
          if g = ElList[k] then New := false; fi;
          k := k+1;
        od;
        if New then
          if func(g) = val then return g; fi;
          Add(ElList, g);
        fi;
      od;
    od;
    Add(GrList, Length(ElList));
    Info(InfoAutomGrp, 3, "There are ", Length(ElList), " elements of length up to ", len+1);
    len := len+1;
  od;
  if GrList[len] = GrList[len+1] then
    SetSize(G, GrList[len]);
  fi;
  return fail;
end);


InstallMethod(FindElements, "for [IsAutomGroup, IsFunction, IsObject, IsCyclotomic]", true,
              [IsGroup, IsFunction, IsObject, IsCyclotomic],
function(G, func, val, n)
  local ElList, GrList, i, j, orig_gens, gen, gens, new_gen, g, len, viewed, oldgr, New, k, cur_els;

# produce a symmetric generating set
  orig_gens := ShallowCopy(GeneratorsOfGroup(G));
  Append(orig_gens, List(orig_gens, x -> x^-1));

  gens := [];
  cur_els := [];

# select pairwise different generators
  for i in [1..Length(orig_gens)] do
    if not IsOne(orig_gens[i]) then
      new_gen := true;
      for j in [1..i-1] do if orig_gens[i] = orig_gens[j] then new_gen := false; fi; od;
      if new_gen then Add(gens, orig_gens[i]); fi;
    fi;
  od;

  if func(One(G)) = val then Add(cur_els, One(G)); fi;
  for g in gens do
    if func(g) = val then Add(cur_els, g); fi;
  od;

  ElList := [One(G)]; Append(ElList, ShallowCopy(gens));
  GrList := [1, Length(gens)+1];
  len := 1;

  while len < n and GrList[len] <> GrList[len+1] do
    for i in [GrList[len]+1..GrList[len+1]] do
      oldgr := Length(ElList);
      for gen in gens do
        g := ElList[i]*gen;
        New := true;
        if len = 1 then k := 1; else k := GrList[len-1]; fi;
        while New and k <= oldgr do
          if g = ElList[k] then New := false; fi;
          k := k+1;
        od;
        if New then
          if func(g) = val then
            Add(cur_els, g);
            Info(InfoAutomGrp, 3, g);
          fi;
          Add(ElList, g);
        fi;
      od;
    od;
    Add(GrList, Length(ElList));
    Info(InfoAutomGrp, 3, "There are ", Length(ElList), " elements of length up to ", len+1);
    len := len+1;
  od;
  if GrList[len] = GrList[len+1] then
    SetSize(G, GrList[len]);
  fi;
  return cur_els;
end);


InstallMethod(FindElement, "for [IsTreeHomomorphismSemigroup, IsFunction, IsObject, IsCyclotomic]", true,
              [IsTreeHomomorphismSemigroup, IsFunction, IsObject, IsCyclotomic],
function(G, func, val, max_len)
  local iter, g;
  iter := Iterator(G, max_len);
  while not IsDoneIterator(iter) do
    g := NextIterator(iter);
    if func(g) = val then return g; fi;
  od;
  return fail;
end);


InstallMethod(FindElements, "for [IsTreeHomomorphismSemigroup, IsFunction, IsObject, IsCyclotomic]", true,
              [IsTreeHomomorphismSemigroup, IsFunction, IsObject, IsCyclotomic],
function(G, func, val, max_len)
  local iter, g, l;
  iter := Iterator(G, max_len);
  l := [];
  while not IsDoneIterator(iter) do
    g := NextIterator(iter);
    if func(g) = val then Add(l, g); fi;
  od;
  return l;
end);



InstallMethod(FindElementOfInfiniteOrder, "for [IsTreeAutomorphismGroup, IsCyclotomic, IsCyclotomic]", true,
              [IsTreeHomomorphismSemigroup, IsCyclotomic, IsCyclotomic],
function(G, n, depth)
  local CheckOrder, res;

  if HasIsFinite(G) and IsFinite(G) then return fail; fi;

  CheckOrder := function(g) return OrderUsingSections(g, depth); end;
  res := FindElement(G, CheckOrder, infinity, n);
  if res <> fail then SetIsFinite(G, false); fi;
  return res;
end);


InstallMethod(FindElementsOfInfiniteOrder, "for [IsAutomGroup, IsCyclotomic, IsCyclotomic]", true,
              [IsAutomGroup, IsCyclotomic, IsCyclotomic],
function(G, n, depth)
  local CheckOrder, res;
  if HasIsFinite(G) and IsFinite(G) then return []; fi;

  CheckOrder := function(g) return OrderUsingSections(g, depth); end;
  res := FindElements(G, CheckOrder, infinity, n);
  if res <> [] then SetIsFinite(G, false); fi;
  return res;
end);


InstallGlobalFunction(IsNoncontracting, function(arg)
  local IsNoncontrElement, res,
        G, n, depth;

  IsNoncontrElement := function(g)
    if AG_SuspiciousForNoncontraction(g) and OrderUsingSections( g, depth )  =  infinity then
      if InfoLevel(InfoAutomGrp) > 2 then
        AG_SuspiciousForNoncontraction(g, true);
      fi;
      return true;
    fi;
    return false;
  end;

  G := arg[1];
  n := infinity;
  depth := 10;
  if Length(arg)  >  1 then n := arg[2]; fi;
  if Length(arg)  >  2 then depth := arg[3]; fi;
  if Length(arg)  >  3 then Error("invalid arguments for IsNoncontracting"); fi;

  if HasIsContracting(G) then return not IsContracting(G); fi;

  res := FindElement(G, IsNoncontrElement, true, n);
  if res <> fail then
    SetIsFinite(G, false);
    SetIsContracting(G, false);
    return true;
  fi;
  return fail;
end);



InstallMethod(IsGeneratedByAutomatonOfPolynomialGrowth, "for [IsAutomatonGroup]", true,
              [IsAutomatonGroup],
function(G)
  local i, d, ver, nstates, cycles, cycle_of_vertex, IsNewCycle, known_vertices, aut_list, HasPolyGrowth, cycle_order, next_cycles, cur_cycles, cur_path, cycles_of_level, lev;

  IsNewCycle := function(C)
    local i, l, cur_cycle, long_cycle;
    l := [2..Length(C)];
    Add(l, 1);
    long_cycle := PermList(l);

    for cur_cycle in cycles do
      if Intersection(cur_cycle, C) <> [] then
#        if Length(C) <> Length(cur_cycle) then return fail; fi;
#        for i in [0..Length(C)-1] do
#          if cur_cycle = Permuted(C, long_cycle^i) then return false; fi;
#        od;
        Info(InfoAutomGrp, 5, "cycle1 = ", cur_cycle, "cycle2 = ", C);
        return fail;
      fi;
    od;
    return true;
  end;

#  Example:
#  cycles  =  [[1, 2, 4], [3, 5, 6], [7]]
#  cur_cycles  =  [1, 3] (the first and the third cycles)
#  cycle_order  =  [[2, 3], [3], []] (means 1 -> 2 -> 3,  1 -> 3)

  HasPolyGrowth := function(v)
    local i, v_next, is_new, C, ver;
#    Print("v = ", v, "\n");
    Add(cur_path, v);
    for i in [1..d] do
      v_next := aut_list[v][i];
      if not (v_next in known_vertices or v_next = 2*nstates+1) then
        if v_next in cur_path then
          C := cur_path{[Position(cur_path, v_next)..Length(cur_path)]};
          is_new := IsNewCycle(C);
          if is_new = fail then
            return false;
          else
            Add(cycles, C);
            Add(cycle_order, []);
            for ver in C do
#              Print("next_cycles  =  ", next_cycles);
              UniteSet(cycle_order[Length(cycles)], next_cycles[ver]);
              cycle_of_vertex[ver] := Length(cycles);
              next_cycles[ver] := [Length(cycles)];
            od;
          fi;
        else
          if not HasPolyGrowth(v_next) then
            return false;
          fi;
          if cycle_of_vertex[v] = 0 then
            UniteSet(next_cycles[v], next_cycles[v_next]);
          elif cycle_of_vertex[v] <> cycle_of_vertex[v_next] then
            UniteSet(cycle_order[cycle_of_vertex[v]], next_cycles[v_next]);
            Info(InfoAutomGrp, 5, "v = ", v, "; v_next = ", v_next);
            Info(InfoAutomGrp, 5, "cycle_order (local)  =  ", cycle_order);
          fi;
        fi;
      elif v_next in known_vertices then
        if cycle_of_vertex[v] = 0 then
          UniteSet(next_cycles[v], next_cycles[v_next]);
        elif cycle_of_vertex[v] = cycle_of_vertex[v_next] then
          return false;
        else
          UniteSet(cycle_order[cycle_of_vertex[v]], next_cycles[v_next]);
        fi;

      fi;
    od;
    Remove(cur_path);
    Add(known_vertices, v);
    return true;
  end;

  nstates := UnderlyingAutomFamily(G)!.numstates;
  aut_list := AutomatonList(G);
  d := UnderlyingAutomFamily(G)!.deg;
  cycles := [];
  cycle_of_vertex := List([1..nstates], x -> 0);  #if vertex i is in cycle j, then cycle_of_vertex[i] = j
  next_cycles := List([1..nstates], x -> []); #if vertex i is not in a cycle, next_cycles[i] stores the list of cycles, that can be reached immediately (with no cycles in between) from this vertex
  known_vertices := [];
  cur_path := [];
  cycle_order := [];

  while Length(known_vertices) < nstates do
    ver := Difference([1..nstates], known_vertices)[1];
    if not HasPolyGrowth(ver) then
      SetIsGeneratedByBoundedAutomaton(G, false);
      return false;
    fi;
  od;

# Now we find the longest chain in the poset of cycles
  cycles_of_level := [[]];
  for i in [1..Length(cycles)] do
    if cycle_order[i] = [] then Add(cycles_of_level[1], i); fi;
  od;

  lev := 1;

  while cycles_of_level[Length(cycles_of_level)] <> [] do
    Add(cycles_of_level, []);
    for i in [1..Length(cycles)] do
      if Intersection(cycles_of_level[lev], cycle_order[i]) <> [] then
        Add(cycles_of_level[lev+1], i);
      fi;
    od;
    lev := lev+1;
  od;

  if lev = 2 then
    SetIsGeneratedByBoundedAutomaton(G, true);
    SetIsAmenable(G, true);
  elif lev = 1 then
    SetIsGeneratedByBoundedAutomaton(G, true);
    SetIsFinite(G, true);
  else
    SetIsGeneratedByBoundedAutomaton(G, false);
  fi;
  SetPolynomialDegreeOfGrowthOfUnderlyingAutomaton(G, lev-2);
  Info(InfoAutomGrp, 5, "Cycles  =  ", cycles);
  Info(InfoAutomGrp, 5, "cycle_order  =  ", cycle_order);
  Info(InfoAutomGrp, 5, "next_cycles  =  ", next_cycles);
  return true;
end);



InstallMethod(IsGeneratedByBoundedAutomaton, "for [IsAutomatonGroup]", true,
              [IsAutomatonGroup],
function(G)
  local res;
  res := IsGeneratedByAutomatonOfPolynomialGrowth(G);
  return IsGeneratedByBoundedAutomaton(G);
end);




InstallMethod(PolynomialDegreeOfGrowthOfUnderlyingAutomaton, "for [IsAutomatonGroup]", true,
              [IsAutomatonGroup],
function(G)
  local res;
  res := IsGeneratedByAutomatonOfPolynomialGrowth(G);
  if not res then
    Print("Error: the automaton generating  <G>  has exponenetial growth\n");
    return fail;
  fi;
  return PolynomialDegreeOfGrowthOfUnderlyingAutomaton(G);
end);




InstallMethod(IsAmenable, "for [IsAutomGroup]", true,
              [IsAutomGroup],
function(G)
  if HasIsFinite(G) and IsFinite(G) then return true; fi;
  if IsGeneratedByBoundedAutomaton(GroupOfAutomFamily(G)) then return true; fi;
  if IsAutomatonGroup(G) and IsAbelian(StabilizerOfLevel(G, 2)) then return true; fi;
  if IsAutomatonGroup(G) and IsOfSubexponentialGrowth(G)=true then return true; fi;
  TryNextMethod();
end);




InstallMethod(IsOfSubexponentialGrowth, "for [IsAutomatonGroup, IsCyclotomic, IsCyclotomic]", true,
              [IsAutomatonGroup, IsCyclotomic, IsCyclotomic],
function(G, len, depth)
  local iter, res, g, cur_length;

  if (HasIsFinite(G) and IsFinite(G)) or IsAbelian(G) then return true; fi;
  iter := Iterator(G, len);

  cur_length := 1;
  res := false;

  while not IsDoneIterator(iter) do
    g := NextIterator(iter);

    if Length(Word(g)) > cur_length then
      if res then
        return true;
        SetIsAmenable(G, true);
      fi;
      res := true;
      cur_length := cur_length + 1;
    fi;

    if res and cur_length <= Sum( List(Sections(g, depth), x -> Length(Word(x))) ) then
      Info(InfoAutomGrp, 3, g, " has sections ", Sections(g, depth));
      res := false;
    fi;

  od;

  if res then return true; fi;

  # if iterator has enumerated all (finitely many) elements of <G>
  if HasIsFinite(G) and IsFinite(G) then return true; fi;
  if IsAbelian(StabilizerOfLevel(G, 2)) then return true; fi;
  return fail;
end);





InstallMethod(IsOfSubexponentialGrowth, "for [IsSelfSimilarGroup, IsCyclotomic, IsCyclotomic]", true,
              [IsSelfSimilarGroup, IsCyclotomic, IsCyclotomic],
function(G, len, depth)
  local iter, res, g, cur_length, F;

  if (HasIsFinite(G) and IsFinite(G)) or IsAbelian(G) then return true; fi;
  F := UnderlyingFreeGroup(G);
  iter := Iterator(F);

  cur_length := 1;
  res := false;

  repeat
    g := NextIterator(iter);

    if Length(g) > cur_length then
      if res then
        return true;
        SetIsAmenable(G, true);
      fi;
      res := true;
      cur_length := cur_length + 1;
    fi;

    if res and cur_length <= Sum( List(Sections(SelfSim(g,One(G)), depth), x -> Length(Word(x))) ) then
      Info(InfoAutomGrp, 3, g, " has sections ", Sections( SelfSim(g,One(G)), depth));
      res := false;
    fi;

  until Length(g)>len;

  # if iterator has enumerated all (finitely many) elements of <G>
  if HasIsFinite(G) and IsFinite(G) then return true; fi;
  if IsAbelian(StabilizerOfLevel(G, 2)) then return true; fi;
  return fail;
end);




InstallMethod(IsOfSubexponentialGrowth, "for [IsTreeAutomorphismGroup and IsSelfSimilar]", true,
              [IsTreeAutomorphismGroup and IsSelfSimilar],
function(G)
  return IsOfSubexponentialGrowth(G, 10, 6);
end);


InstallGlobalFunction(AG_GroupHomomorphismByImagesNC,
function(G, H, gens_G, gens_H)

  local F, gens_in_freegrp, pi, pi_bar, hom_function, inv_hom_function;

  if Length(gens_G)<>Length(gens_H) then
    Error("Lengths of generating sets must coincide");
  fi;

  F := FreeGroup(Length(gens_G));


  gens_in_freegrp := List(gens_G, Word);

#        pi
#    F ------> G ----> H
#      -------------->
#            pi_bar

  pi := GroupHomomorphismByImages(F,                     Group(gens_in_freegrp),
                                  GeneratorsOfGroup(F),  gens_in_freegrp);

  pi_bar := GroupHomomorphismByImages(F,                     H,
                                      GeneratorsOfGroup(F),  gens_H);

  hom_function := function(g)
    return Image(pi_bar, PreImagesRepresentative(pi, g!.word));
  end;

  if IsAutomGroup(G) then
    inv_hom_function :=  function(b)
      return Autom(Image(pi, PreImagesRepresentative(pi_bar, b)), UnderlyingAutomFamily(G));
    end;
  elif IsSelfSimGroup(G) then
    inv_hom_function :=  function(b)
      return SelfSim(Image(pi, PreImagesRepresentative(pi_bar, b)), UnderlyingSelfSimFamily(G));
    end;
  fi;

  return GroupHomomorphismByFunction(G, H, hom_function, inv_hom_function);
end);


#E
