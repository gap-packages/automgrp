#############################################################################
##
#W  autom.gi                 automata package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
##  automata v0.9, started 01/22/2004
##


###############################################################################
##
#R  IsFGAutomRep
##
DeclareRepresentation(  "IsFGAutomRep",
                        IsComponentObjectRep and IsAttributeStoringRep,
                        ["Word", "States", "Perm", "Degree"]);


###############################################################################
##
#M  CreateAutom(<list>, <names>, <rename>, <int>)
##
InstallOtherMethod(CreateAutom, [IsList, IsList, IsBool, IsInt],
function (list, names, rename, fictive_parameter)
    local  degree, t, trivstate , perm, nontrivstates, freegroup,
            freegens, i, j, family;

# 1. Check correctness of arguments

    if not IsCorrectAutomatonList(list) then
        Print("error: given list is not a correct list representing automaton\n");
        return fail;
    fi;

    degree := Length(list[1]) - 1;

# 2. Reduce automaton, find trivial state, permute states

    t := ReducedAutomatonInList(list);
    list := t[1];
    names := List(t[2], x->names[x]);

    trivstate := 0;
    for i in [1..Length(list)] do
        if IsTrivialStateInList(i, list) then
            trivstate := i;
        fi;
    od;
    if trivstate <> 0 then
        if Length(list) = 1 then
            Print("error: don't want to work with trivial automaton\n");
            return fail;
        fi;
        if trivstate <> Length(list) then
            perm := PermListList([1..Length(list)],
                Concatenation(  [1..(trivstate-1)],
                                [(trivstate+1)..Length(list)],
                                [trivstate] )
            );
            list := PermuteStatesInList(list, perm^-1);
            names := Permuted(names, perm^-1);
        fi;
        trivstate := Length(list);
        names[trivstate] := AutomataParameters.identity_symbol;
    fi;

    # list [1..Length(list)] or [1..Lentgh(list)-1], depending on
    # presence of trivial state
    nontrivstates := Difference([1..Length(list)], [trivstate]);

# 4. Create FreeGroup and FreeGens

    freegroup := FreeGroup(names{nontrivstates});
    freegens := FreeGeneratorsOfFpGroup(freegroup);

    for i in [1..Length(list)] do
        for j in [1..degree] do
            if list[i][j] = trivstate then
                list[i][j] := One(freegroup);
            else
                list[i][j] := freegens[list[i][j]];
            fi;
        od;
    od;

# 8. Create family

    family := NewFamily("FGAutomFamily",
                        IsFGAutom,
                        IsFGAutom,
                        IsFGAutomFamily);

    family!.Degree := degree;
    family!.Names := names{nontrivstates};
    family!.FreeGroup := freegroup;
    family!.FreeGens := freegens;
    family!.AutomatonList := list;

# 9. Create Automs

    family!.Gens := IndexedList();
    for i in [1..Length(freegens)] do
        Put(family!.Gens, freegens[i],
            Objectify(  NewType(family, IsFGAutom and IsFGAutomRep),
                        rec(    Word := freegens[i],
                                States := list[i]{[1..degree]},
                                Perm := list[i][degree+1],
                                Degree := degree   )   )
        );
        Put(family!.Gens, freegens[i]^-1,
            Value(family!.Gens, freegens[i])^-1 );

        if rename then
            if IsBoundGlobal(names[i]) then
                if IsReadOnlyGlobal(names[i]) then
                    Print("CreateAutom: can't rename ", names[i], ", read-only variable\n");
                else
                    BindGlobal(names[i], Value(family!.Gens, freegens[i]));
                    MakeReadWriteGlobal(names[i]);
                fi;
            else
                BindGlobal(names[i], Value(family!.Gens, freegens[i]));
                MakeReadWriteGlobal(names[i]);
            fi;
        fi;
    od;
    Put(family!.Gens, One(freegroup), One(Value(family!.Gens, freegens[1])));

    family!.Group := FGAutomGroup(List(family!.FreeGens, x -> Value(family!.Gens, x)));
      return family!.Group;
end);


###############################################################################
##
#M  CreateAutom(<list>, <names>)
##
InstallOtherMethod(CreateAutom, [IsList, IsList],
function (list, names)
    return CreateAutom(list, names, true, 1);
end);


###############################################################################
##
#M  CreateAutom(<list>)
##
InstallOtherMethod(CreateAutom, [IsList],
function (list)
  local letters;
  if (Length(list) > 26) then
    Error("list is too long\n");
  fi;
  letters := ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
  return CreateAutom(list, letters{[1..Length(list)]}, true, 1);
end);


###############################################################################
##
#M  FGAutom(<word>, <fam>)
##
InstallOtherMethod(FGAutom, [IsAssocWord, IsFGAutomFamily],
function(w, fam)
    if Length(w) <= 1 then
        return Value(fam!.Gens, w);
    else
        return CalculateWord(w, List(fam!.FreeGens, x -> Value(fam!.Gens, x)));
    fi;
end);


###############################################################################
##
#M  FGAutom(<word>, <autom>)
##
InstallOtherMethod(FGAutom, [IsAssocWord, IsFGAutom],
function(w, a)
    return FGAutom(w, FamilyObj(a));
end);


###############################################################################
##
#M  InverseOp(a)
##
InstallMethod(InverseOp, [IsFGAutom],
function(a)
    return Objectify(  NewType(FamilyObj(a), IsFGAutom and IsFGAutomRep),
                        rec(    Word := a!.Word ^ -1,
                                States := List([1..a!.Degree], i -> a!.States[i^(a!.Perm^-1)] ^ -1),
                                Perm := a!.Perm ^ -1,
                                Degree := a!.Degree   )   );
end);


###############################################################################
##
#M  OneOp(a)
##
InstallMethod(OneOp, [IsFGAutom],
function(a)
    return Objectify(  NewType(FamilyObj(a), IsFGAutom and IsFGAutomRep),
                        rec(    Word := One(a!.Word),
                                States := List([1..a!.Degree], i -> One(a!.Word)),
                                Perm := (),
                                Degree := a!.Degree   )   );
end);


###############################################################################
##
#M  OneOp(fam)
##
InstallOtherMethod(OneOp, [IsFGAutomFamily],
function(fam)
    return Objectify(  NewType(fam, IsFGAutom and IsFGAutomRep),
                        rec(    Word := One(fam!.FreeGroup),
                                States := List([1..fam!.Degree], i -> One(fam!.FreeGroup)),
                                Perm := (),
                                Degree := fam!.Degree   )   );
end);


###############################################################################
##
#M  PrintObj(a)
##
InstallMethod(PrintObj, [IsFGAutom],
function (a)
    local deg, printword, i;

    printword := function(w)
        if IsOne(w) then Print(AutomataParameters.identity_symbol);
        else Print(w); fi;
    end;

    deg := a!.Degree;
    printword(a!.Word);
    Print(" = (");
    for i in [1..deg] do
        printword(a!.States[i]);
        if i <> deg then Print(", "); fi;
    od;
    Print(")");
    if not IsOne(a!.Perm) then Print(a!.Perm); fi;
end);


###############################################################################
##
#M  TopPerm(a)
##
InstallMethod(TopPerm, [IsFGAutom],
function(a)
    return a!.Perm;
end);


###############################################################################
##
#M  Perm(a)
##
InstallOtherMethod(Perm, [IsFGAutom],
function(a)
    return a!.Perm;
end);


###############################################################################
##
#M  Perm(a, k)
##
InstallMethod(Perm, [IsFGAutom, IsInt],
function(a, k)
    local dom, perm;

    if k <= 0 then
      Error("Perm(IsFGAutom, IsInt): level number is not positive\n");
    fi;

    dom := AsList(Tuples([1..Degree(a)], k));
    perm := List(dom, s -> s ^ a);
    perm := PermListList(dom, perm);

    return perm;
end);


###############################################################################
##
#M  Degree(a)
##
InstallOtherMethod(Degree, [IsFGAutom],
function(a)
    return a!.Degree;
end);


###############################################################################
##
#M  Word(a)
##
InstallOtherMethod(Word, [IsFGAutom],
function(a)
    return a!.Word;
end);


###############################################################################
##
#M  a1 * a2
##
InstallMethod(\*, [IsFGAutom, IsFGAutom],
function(a1, a2)
    return Objectify(
        NewType(FamilyObj(a1), IsFGAutom and IsFGAutomRep),
        rec(    Word := a1!.Word * a2!.Word,
                States := List([1..a1!.Degree], i -> a1!.States[i] * a2!.States[i^(a1!.Perm)]),
                Perm := a1!.Perm * a2!.Perm,
                Degree := a1!.Degree   )   );
end);


###############################################################################
##
#M  Projection(a, k)
##
InstallOtherMethod(Projection, [IsFGAutom, IsInt],
function(a, k)
    if k < 1 or k > a!.Degree then
        Error("Projection(IsFGAutom, IsInt): wrong vertex number\n");
    fi;

    return FGAutom(a!.States[k], a);
end);


###############################################################################
##
#M  Projection(a, seq)
##
InstallOtherMethod(Projection, [IsFGAutom, IsList],
function(a, v)
  if Length(v) = 0 then
    return a;
  fi;

  if v[1]^a <> v[1] then
    Error("Projection(IsFGAutom, IsList): given autmaton does not stabilize given vertex\n");
  fi;

  if Length(v) = 1 then
    return Projection(a, v[1]);
  fi;

  return Projection(Projection(a, v[1]), v{[2..Length(v)]});
end);


###############################################################################
##
#M  k ^ a
##
InstallOtherMethod(\^, [IsInt, IsFGAutom],
function(k, a)
    return k ^ Perm(a);
end);


###############################################################################
##
#M  \^(seq, a)
##
InstallOtherMethod(\^, [IsList, IsFGAutom],
function(seq, a)
    local i, deg, img, cur;

    deg := a!.Degree;
    for i in seq do
    if not IsInt(i) or i < 1 or i > deg then
        Print("\^(IsList, IsFGAutom): ",
            i, "is out of range 1..", deg, "\n");
    fi; od;

    if Length(seq) = 1 then return [seq[1]^a]; fi;

    cur := a;
    img := [];
    for i in [1..Length(seq)] do
        img[i] := seq[i]^Perm(cur);
        cur := FGAutom(cur!.States[seq[i]], a);
    od;

    return img;
end);


###############################################################################
##
#M  IsOne(a)
##
InstallOtherMethod(IsOne, [IsFGAutom],
function(a)
    local i, w, aw, d, to_check, checked;

    d := a!.Degree;

    to_check := [a!.Word];
    checked := [];

    while Length(to_check) <> 0 do
        for w in to_check do
            aw := FGAutom(w, a);
            for i in [1..d] do
                if Perm(aw) <> () then
                    return false;
                fi;
                if (not aw!.States[i] in checked) and (not aw!.States[i] in to_check)
                then
                    to_check := Union(to_check, [aw!.States[i]]);
                fi;
            od;
            checked := Union(checked, [w]);
            to_check := Difference(to_check, [w]);
        od;
    od;

    return true;
end);


###############################################################################
##
#M  a1 = a2
##
InstallMethod(\=, [IsFGAutom, IsFGAutom],
function(a1, a2)
  local d, checked_pairs, pos, aw1, aw2, np, i;

  d := a1!.Degree;
  checked_pairs := [[a1!.Word, a2!.Word]];
  pos := 0;

  while Length(checked_pairs) <> pos do
    pos := pos + 1;
    aw1 := FGAutom(checked_pairs[pos][1], a1);
    aw2 := FGAutom(checked_pairs[pos][2], a2);

    if Perm(aw1) <> Perm(aw2) then
      return false;
    fi;

    for i in [1..d] do
      np := [aw1!.States[i], aw2!.States[i]];
      if not np in checked_pairs then
        checked_pairs := Concatenation(checked_pairs, [np]);
      fi;
    od;
  od;

  return true;
end);


###############################################################################
##
#M  a1 < a2
##
InstallMethod(\<, [IsFGAutom, IsFGAutom],
function(a1, a2)
  local d, checked_pairs, pos, aw1, aw2, np, i;

  d := a1!.Degree;
  checked_pairs := [[a1!.Word, a2!.Word]];
  pos := 0;

  while Length(checked_pairs) <> pos do
    pos := pos + 1;
    aw1 := FGAutom(checked_pairs[pos][1], a1);
    aw2 := FGAutom(checked_pairs[pos][2], a2);

    if Perm(aw1) < Perm(aw2) then
      return true;
    elif Perm(aw1) > Perm(aw2) then
      return false;
    fi;

    for i in [1..d] do
      np := [aw1!.States[i], aw2!.States[i]];
      if not np in checked_pairs then
        checked_pairs := Concatenation(checked_pairs, [np]);
      fi;
    od;
  od;

  return false;
end);


###############################################################################
##
#M  Projection(a, k)
##
InstallMethod(Projection, [IsFGAutom, IsInt],
function(a, k)
    if k < 1 or k > a!.Degree then
        Error("Projection(IsFGAutom, IsInt): wrong vertex number\n");
    fi;

    return FGAutom(a!.States[k], a);
end);


###############################################################################
##
#M  IsActingOnBinaryTree(fam)
##
InstallMethod(IsActingOnBinaryTree, [IsFGAutomFamily],
function(fam)
    return fam!.Degree = 2;
end);


###############################################################################
##
#M  Expand(a)
##
InstallMethod(Expand, [IsFGAutom],
function(a)
  local deg, listrep, list, names, i, j, pf;

  listrep := ListRep(a);
  deg := Degree(a);
  names := listrep.names;
  list := listrep.list;

  pf := function(w)
    if IsOne(w) then
      Print(AutomataParameters.identity_symbol);
    else
      Print(w);
    fi;
  end;

  for i in [1..Length(list)] do
    pf(names[i]);
    Print(" = (");
    for j in [1..deg] do
      pf(names[list[i][j]]);
      if j <> deg then
        Print(", ");
      fi;
    od;
    if not IsOne(list[i][deg+1]) then
      Print(")", list[i][deg+1], "\n");
    else
      Print(")\n");
    fi;
  od;
end);


###############################################################################
##
#M  ExpandRen(a)
##
InstallMethod(ExpandRen, [IsFGAutom],
function(a)
  local letters, deg, listrep, list, states, names, i, j, pf;

  listrep := ListRep(a);
  deg := Degree(a);
  states := listrep.names;
  list := listrep.list;
  names := [];
  for i in [1..Length(list)] do
    names[i] := Concatenation("s", String(i));
  od;

  pf := function(w)
    if IsOne(w) then
      Print(AutomataParameters.identity_symbol);
    else
      Print(w);
    fi;
  end;

  for i in [1..Length(list)] do
    Print(names[i]);
    Print(" = (");
    for j in [1..deg] do
      Print(names[list[i][j]]);
      if j <> deg then
        Print(", ");
      fi;
    od;
    if not IsOne(list[i][deg+1]) then
      Print(")", list[i][deg+1], "\n");
    else
      Print(")\n");
    fi;
  od;
  for i in [1..Length(list)] do
    Print(names[i], " = "); pf(states[i]); Print("\n");
  od;
end);


###############################################################################
##
#M  ListRep(a)
##
InstallMethod(ListRep, [IsFGAutom],
function(a)
  local deg, pos, states, list_comp, word, aut, i;

  deg := Degree(a);
  states := [a!.Word];
  pos := 0;
  list_comp := [];

  while pos <> Length(states) do
    pos := pos + 1;
    word := states[pos];
    aut := FGAutom(word, FamilyObj(a));
    for i in [1..deg] do
      if not aut!.States[i] in states then
        Add(states, aut!.States[i]);
      fi;
    od;

    Add(list_comp, Concatenation(List(aut!.States, w -> Position(states, w)), [aut!.Perm]));
  od;

  return rec(  list   := list_comp,
              names := states  );
end);


###############################################################################
##
#M  StabilizesPath(a, path)
##
InstallMethod(StabilizesPath, [IsFGAutom, IsList],
function(a, path)
  local len, checked_words, cur_state, cur_pos;

  checked_words := [];
  cur_state := a;
  cur_pos := 1;
  len := Length(path);

##  TODO: error checking

  while true do
    if cur_pos = 1 and Word(cur_state) in checked_words then
        return true;
    fi;

    if path[cur_pos]^cur_state <> path[cur_pos] then
      return false;
    fi;

    if cur_pos = 1 then
      Add(checked_words, Word(cur_state)); fi;

    cur_state := Projection(cur_state, path[cur_pos]);

    if cur_pos < len then
      cur_pos := cur_pos + 1;
    else cur_pos := 1; fi;
  od;
end);












