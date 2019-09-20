#############################################################################
##
#W  selfsim.gi               automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#R  IsSelfSimRep
##
##  This is how IsSelfSim object is stored in GAP:
##  IsSelfSim object is a thing of kind "w = (w_1, w_2, ..., w_d)\pi", where
##    deg = d - arity of tree;
##    perm = \pi - permutation on first level;
##    w, w_1, ..., w_d - elements of free group representing elements of
##      automata group;
##    word = w;
##    states = [w_1, ..., w_d].
##
DeclareRepresentation("IsSelfSimRep",
                      IsComponentObjectRep and IsAttributeStoringRep,
                      ["word", "states", "perm", "deg"]);


InstallGlobalFunction(__AG_CreateSelfSim,
function(family, word, states, perm, invertible)
  local a, cat;

  if invertible then
    cat := IsInvertibleSelfSim and IsSelfSimRep;

    if perm^-1=fail then
      Error(perm, " is not invertible");
    else
      perm := AG_PermFromTransformation(perm);
    fi;
  else
    cat := IsSelfSim and IsSelfSimRep;
  fi;

  a := Objectify(NewType(family, cat),
                 rec(word := word,
                     states := states,
                     perm := perm,
                     deg := family!.deg));

  SetIsActingOnBinaryTree(a, a!.deg = 2);

  return a;
end);

###############################################################################
##
#M  SelfSim( <word>, <fam> )
##
InstallMethod(SelfSim, "for [IsAssocWord, IsSelfSimFamily]",
              [IsAssocWord, IsSelfSimFamily],
function(w, fam)
  local exp, wstates, curstate, newstate, curletter, newletter,
        nperm, i, j, perm, a, wtmp, reduced, invertible;

  if fam!.use_rws then
    w := AG_ReducedForm(fam!.rws, w);
  fi;

  if Length(w) = 0 then
    return One(fam);
  elif Length(w) = 1 then
    if ExponentSyllable(w, 1) = 1 then
      return fam!.recurgens[GeneratorSyllable(w, 1)];
    else
      if IsBound(fam!.recurgens[GeneratorSyllable(w, 1) + fam!.numstates]) then
        return fam!.recurgens[GeneratorSyllable(w, 1) + fam!.numstates];
      else
        Error(fam!.recurgens[GeneratorSyllable(w, 1)], " is not invertible");
      fi;
    fi;
  fi;

  exp := LetterRepAssocWord(w);
  for i in [1..Length(exp)] do
    if exp[i] < 0 then
      if IsBound(fam!.recurlist[-exp[i] + fam!.numstates]) then
        exp[i] := -exp[i] + fam!.numstates;
      else
        Error(fam!.recurgens[-exp[i]], " is not invertible");
      fi;
    fi;
  od;
  wstates := [];
  nperm := ();
  for i in [1..Length(exp)] do
    nperm := nperm * fam!.recurlist[exp[i]][fam!.deg+1];
  od;

  for i in [1..fam!.deg] do
    wstates[i] := One(fam!.freegroup);
    perm := ();

    for j in [1..Length(exp)] do
      wstates[i] := wstates[i]*fam!.recurgens[exp[j]]!.states[i^perm];
      perm := perm * fam!.recurlist[exp[j]][fam!.deg+1];
    od;

#    if fam!.use_rws and Length(wstates[i]) > 0 then
#      wstates[i] := AG_ReducedForm(fam!.rws, wstates[i]);
#    fi;
  od;

  invertible := true;
  if not fam!.isgroup then
    for i in exp do
      if i <= fam!.numstates and not IsInvertibleSelfSim(fam!.recurgens[i]) then
        invertible := false;
        break;
      fi;
    od;
  fi;

  return __AG_CreateSelfSim(fam, w, wstates, nperm, invertible);
end);


###############################################################################
##
#M  SelfSim( <word>, <a> )
##
InstallMethod(SelfSim, "for [IsAssocWord, IsSelfSim]", [IsAssocWord, IsSelfSim],
function(w, a)
  return SelfSim(w, FamilyObj(a));
end);


InstallMethod(MappedWord, [IsAssocWord,
                           IsList and IsAssocWordCollection,
                           IsList and IsSelfSimCollection],
function(w, fgens, agens)
  local img;
  img := MappedWord(w, fgens, List(agens, a -> a!.word));
  return SelfSim(img, FamilyObj(agens[1]));
end);


###############################################################################
##
#M  SelfSim( <word>, <list> )
##
InstallMethod(SelfSim, "for [IsAssocWord, IsList]",
                   [IsAssocWord, IsList],
function(w, list)
  local fam;
  fam := SelfSimFamily(list);
  if fam = fail then
    return fail;
  fi;
  return SelfSim(w, fam);
end);


###############################################################################
##
#M  PrintObj( <a> )
##
InstallMethod(PrintObj, "for [IsSelfSim]",
              [IsSelfSim],
function (a)
  local deg, printword, i;

  printword := function(w)
    if IsOne(w) then Print(AG_Globals.identity_symbol);
    else Print(w); fi;
  end;

  if true then
    View(a);
    return;
  fi;

  deg := a!.deg;
  printword(a!.word);
  Print(" = (");
  for i in [1..deg] do
    printword(a!.states[i]);
    if i <> deg then Print(", "); fi;
  od;
  Print(")");
  if not IsOne(a!.perm) then AG_PrintTransformation(a!.perm); fi;
end);


###############################################################################
##
#M  ViewObj( <a> )
##
InstallMethod(ViewObj, "for [IsSelfSim]",
              [IsSelfSim],
function (a)
  if IsOne(a!.word) then Print(AG_Globals.identity_symbol);
  else Print(a!.word); fi;
end);


###############################################################################
##
#M  String( <a> )
##
InstallMethod(String, "for [IsSelfSim]",
              [IsSelfSim],
function (a)
  if IsOne(a!.word) then return AG_Globals.identity_symbol;
  else return String(a!.word); fi;
end);


###############################################################################
##
#M  Perm( <a> )
##
InstallMethod(Perm, "for [IsSelfSim]", [IsSelfSim],
function(a)
    return a!.perm;
end);


###############################################################################
##
#M  Word(<a>)
##
InstallMethod(Word, "for [IsSelfSim]", [IsSelfSim],
function(a)
    return a!.word;
end);


###############################################################################
##
#M  <a1> * <a2>
##
InstallMethod(\*, "for [IsSelfSim, IsSelfSim]", [IsSelfSim, IsSelfSim],
function(a1, a2)
    local a, i, fam, word, states;

    fam := FamilyObj(a1);
    word := a1!.word * a2!.word;

    if fam!.use_rws then
      word := AG_ReducedForm(fam!.rws, word);
    fi;

    if IsOne(word) then
      return One(a1);
    fi;

    states := List([1..a1!.deg], i -> a1!.states[i] * a2!.states[i^(a1!.perm)]);

    if fam!.use_rws then
      for i in [1..a1!.deg] do
        states[i] := AG_ReducedForm(fam!.rws, states[i]);
      od;
    fi;

    return __AG_CreateSelfSim(FamilyObj(a1), word, states, a1!.perm * a2!.perm,
                           IsInvertibleSelfSim(a1) and IsInvertibleSelfSim(a2));
end);





###############################################################################
##
#M  a1 < a2
##
InstallMethod(\<, "for [IsSelfSim, IsSelfSim]", IsIdenticalObj, [IsSelfSim, IsSelfSim],
function(a1, a2)
  local d, checked, checked_words, p, pos, np, np_words, i, perm1, perm2, cmp, G1, G2;

  G1 := GroupOfSelfSimFamily(FamilyObj(a1));
  G2 := GroupOfSelfSimFamily(FamilyObj(a2));

  # if a1 or a2 are elements of semigroup, which is not a group, then G1 or G2 is `fail'

  if IsIdenticalObj(G1, G2) and HasIsFinite(G1) and IsFinite(G1) and a1 = a2 then
    return false;
  fi;

  d := a1!.deg;

  checked := [[a1, a2]];
  checked_words := [[a1!.word, a2!.word]];
  pos := 0;

  while Length(checked) <> pos do
    pos := pos + 1;
    p := checked[pos];
    perm1 := p[1]!.perm;
    perm2 := p[2]!.perm;
    cmp := AG_TrCmp(perm1, perm2, d);
    if cmp < 0 then
      return true;
    elif cmp > 0 then
      return false;
    fi;
    for i in [1..d] do
      np := [Section(p[1], i), Section(p[2], i)];
      np_words := List(np, x -> x!.word);
      if not np_words in checked_words then
        Add(checked, np);
        Add(checked_words, np_words);
      fi;
    od;
  od;

  return false;
end);


###############################################################################
##
#M  InverseOp( <a> )
##
InstallMethod(InverseOp, "for [IsInvertibleSelfSim]", [IsInvertibleSelfSim],
function(a)
  local i, inv, fam, word, states;

  fam := FamilyObj(a);
  word := a!.word ^ -1;
  if fam!.use_rws then
    word := AG_ReducedForm(fam!.rws, word);
    if IsOne(word) then
      return One(a);
    fi;
  fi;

  states := List([1..a!.deg], i -> a!.states[i^(a!.perm^-1)]^-1);

  if fam!.use_rws then
    for i in [1..a!.deg] do
      states[i] := AG_ReducedForm(fam!.rws, states[i]);
    od;
  fi;

  return __AG_CreateSelfSim(FamilyObj(a), word, states, a!.perm^-1, true);
end);


###############################################################################
##
#M  OneOp( <a> )
##
InstallMethod(OneOp, "for [IsSelfSim]", [IsSelfSim],
function(a)
    return One(FamilyObj(a));
end);


###############################################################################
##
#M  StatesWords( <a> )
##
InstallMethod(StatesWords, "for [IsSelfSim]", [IsSelfSim],
function(a)
  return a!.states;
end);


###############################################################################
##
#M  Sections( <a> )
##
InstallMethod(Sections, "for [IsSelfSim]", [IsSelfSim],
function(a)
  return List(a!.states, s -> SelfSim(s, a));
end);


###############################################################################
##
#M  Section( <a>, <k>)
##
InstallMethod(Section, "for [IsSelfSim, IsPosInt]", [IsSelfSim, IsPosInt],
function(a, k)
  if k > a!.deg then
    Error("in Section(IsSelfSim, IsPosInt): invalid vertex ", k);
  fi;
  return SelfSim(a!.states[k], a);
end);


###############################################################################
##
#M  Section(a, seq)
##
## TODO
InstallMethod(Section, "for [IsSelfSim, IsList]", [IsSelfSim, IsList],
function(a, v)
  if Length(v) = 0 then
    return a;
  fi;

  if Length(v) = 1 then
    return Section(a, v[1]);
  fi;

  return Section(Section(a, v[1]), v{[2..Length(v)]});
end);


###############################################################################
##
#M  k ^ a
##
InstallMethod(\^, "for [IsPosInt, IsSelfSim]", [IsPosInt, IsSelfSim],
function(k, a)
    return k ^ Perm(a);
end);


###############################################################################
##
#M  seq ^ a
##
InstallMethod(\^, "for [IsList, IsSelfSim]", [IsList, IsSelfSim],
function(seq, a)
    local i, deg, img, cur;

    deg := DegreeOfTree(a);
    for i in seq do
      if not IsInt(i) or i < 1 or i > deg then
        Print("\^(IsList, IsFGSelfSim): ",
              i, "is out of range 1..", deg, "\n");
        return seq;
      fi;
    od;

    if Length(seq) = 0 then return []; fi;
    if Length(seq) = 1 then return [seq[1]^Perm(a)]; fi;

    return Concatenation([seq[1]^Perm(a)], seq{[2..Length(seq)]}^Section(a, seq[1]));
end);


###############################################################################
##
#M  PermOnLevelOp( <a>, <k>)
##
## TODO
InstallMethod(PermOnLevelOp, "for [IsInvertibleSelfSim, IsPosInt]",
              [IsInvertibleSelfSim, IsPosInt],
function(a, k)
  local dom, perm;

  if k = 1 then
    return a!.perm;
  fi;

  dom := AsList(Tuples([1..a!.deg], k));
  perm := List(dom, s -> s^a);
  perm := PermListList(dom, perm);

  return perm;
end);

InstallMethod(TransformationOnFirstLevel, [IsSelfSim],
function(a)
  return AsTransformation(a!.perm);
end);


###############################################################################
##
#M  IsActingOnBinaryTree( <a> )
##
InstallMethod(IsActingOnBinaryTree, "for [IsSelfSim]",
              [IsSelfSim],
function(a)
    return a!.deg = 2;
end);


###############################################################################
##
#M  IsOne( <a> )
##
InstallMethod(IsOne, "for [IsSelfSim]",
              [IsSelfSim],
function(a)
  local st, state_words, IsOneLocal, G;

  G := GroupOfSelfSimFamily(FamilyObj(a));

  if HasIsFinite(G) and IsFinite(G) then
    return IsOne(Image(IsomorphismPermGroup(G), a));
  fi;


  if HasIsContracting(G) and IsContracting(G) then
    return IsOne(Image(MonomorphismToAutomatonGroup(G), a));
  fi;

  IsOneLocal := function(s)
    local i, triv;
    if not IsOne(Perm(s)) then return false; fi;
    if s!.word in state_words then  return true; fi;

    Add(state_words, s!.word);
    triv := true;
    i := 1;
    while triv and i<=s!.deg do
      triv := IsOneLocal(Section(s, i));
      i := i+1;
    od;
    return triv;
  end;

  state_words := [];

  return IsOneLocal(a);
end);



###############################################################################
##
#M  a1 = a2
##
##
InstallMethod(\=, "for [IsSelfSim, IsSelfSim]", IsIdenticalObj, [IsSelfSim, IsSelfSim],
function(a1, a2)
  local areequalstates, d, checked_pairs, G1, G2;

  G1 := GroupOfSelfSimFamily(FamilyObj(a1));
  G2 := GroupOfSelfSimFamily(FamilyObj(a2));

  # if a1 or a2 are elements of semigroup, which is not a group, then G1 or G2 is `fail'

  if IsIdenticalObj(G1, G2) and HasIsFinite(G1) and IsFinite(G1) then
    return IsOne(Image(IsomorphismPermGroup(G1), a1*a2^-1));
  fi;

  d := a1!.deg;

  areequalstates := function(a, b)
    local j;

    if a!.word = b!.word then
      return true;
    fi;

    if [a!.word, b!.word] in checked_pairs then
      return true;
    else
      if a!.perm <> b!.perm then
        return false;
      fi;
      AddSet(checked_pairs, [a!.word, b!.word]);
      for j in [1..d] do
        if not areequalstates(Section(a, j), Section(b, j)) then
          return false;
        fi;
      od;
      return true;
    fi;
  end;

  checked_pairs := [];
  return areequalstates(a1, a2);
end);



InstallMethod(OrderUsingSections, "[IsSelfSim, IsCyclotomic]", true,
              [IsSelfSim, IsCyclotomic],
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
      while reduced  and j<Length(w) do
        if w[j]=-w[j+1] or (w[j]=w[j+1] and w[j] in gens_ord2) then
          reduced := false;
          wtmp := ShallowCopy(w{[1..j-1]});
          Append(wtmp, w{[j+2..Length(w)]});
          w := wtmp;
        fi;
        j := j+1;
      od;
    until reduced;

    repeat
      if Length(w)<2 then return w; fi;
      reduced := true;
      if w[1]=-w[Length(w)] or (w[1]=w[Length(w)] and w[1] in gens_ord2) then
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
    if Length(g_list)<>Length(h_list) then return false; fi;
    l := [2..Length(g_list)];
    Add(l, 1);
    long_cycle := PermList(l);
    for i in [0..Length(g_list)-1] do
      if h_list=Permuted(g_list, long_cycle^i) then return true; fi;
    od;
    return false;
  end;

  OrderUsingSections_LOCAL := function(g)
    local i, el, orb, Orbs, res, st, reduced_word, loc_order;
    if IsOne(g) then return 1; fi;

    if IsActingOnBinaryTree(g) and IsSphericallyTransitive(g) then
      Info(InfoAutomGrp, 3, g!.word, " acts transitively on levels and is obtained from (", a!.word, ")^", Product(degs{[1..Length(degs)]}), "\n    by taking sections and cyclic reductions at vertex ", vertex);
      return infinity;
    fi;

    for i in [1..Length(cur_list)] do
      el := cur_list[i];
      if (AreConjugateUsingSmallRels(g!.word, el!.word) or AreConjugateUsingSmallRels((g!.word)^(-1), el!.word)) then
        if Product(degs{[i..Length(degs)]})>1 then
          if i>1 then Info(InfoAutomGrp, 3, "(", a!.word, ")^", Product(degs{[1..i-1]}), " has ", el!.word, " as a section at vertex ", vertex{[1..i-1]}); fi;
          Info(InfoAutomGrp, 3, "(", el!.word, ")^", Product(degs{[i..Length(degs)]}), " has conjugate of ", g!.word, " as a section at vertex ", vertex{[i..Length(degs)]});
          SetIsFinite(GroupOfSelfSimFamily(FamilyObj(a)), false);
          return infinity;
        else
#          Info(InfoAutomGrp, 3, "The group <G> might not be contracting, ", g, " has itself as a section.");
          return 1;
        fi;
      fi;
    od;
    if Length(cur_list)>=max_depth then return fail; fi;
    Add(cur_list, g);
    Orbs := OrbitsPerms([g!.perm], [1..g!.deg]);
    loc_order := 1;

    for orb in Orbs do
      Add(degs, Length(orb));
      Add(vertex, orb[1]);
      st := Section(g^Length(orb), orb[1]);
      reduced_word := AssocWordByLetterRep(FamilyObj(st!.word), CyclicallyReduce(LetterRepAssocWord(st!.word)));
#      Print(st!.word, " at ", vertex, "\n");
      res := OrderUsingSections_LOCAL(SelfSim(reduced_word, FamilyObj(g)));
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
  if IsObviouslyFiniteState(FamilyObj(a)) then
    gens_ord2 := GeneratorsOfOrderTwo(FamilyObj(a));
  else
    gens_ord2 := [];
  fi;
  cur_list := [];
# degs traces at what positions we raise to what power
  degs := []; vertex := [];
  res := OrderUsingSections_LOCAL(a);
  if res=infinity then
    SetIsFinite(GroupOfSelfSimFamily(FamilyObj(a)), false);
    SetOrder(a, infinity);
  fi;
  return res;
end);



InstallMethod(OrderUsingSections, "for [IsSelfSim]", true,
              [IsSelfSim],
function(a)
  return OrderUsingSections(a, infinity);
end);



InstallMethod(SphericalIndex, "for [IsSelfSim]", [IsSelfSim],
function(a)
  # XXX check uses of SphericalIndex everywhere
  return rec(start := [], period := [a!.deg]);
end);

# XXX check uses of this everywhere
InstallMethod(DegreeOfTree, "for [IsSelfSim]", [IsSelfSim],
function(a)
  return a!.deg;
end);

# XXX check uses of this everywhere
InstallMethod(TopDegreeOfTree, "for [IsSelfSim]", [IsSelfSim],
function(a)
  return a!.deg;
end);


###############################################################################
##
#M  CanEasilyTestSphericalTransitivity( <a> )
##
InstallTrueMethod(CanEasilyTestSphericalTransitivity,
                  IsActingOnBinaryTree and IsSelfSim and IsFiniteState);


###############################################################################
##
#M  IsSphericallyTransitive( <a> )
##
InstallMethod(IsSphericallyTransitive, "for [IsInvertibleSelfSim]",
              [IsInvertibleSelfSim],
function(a)
  local w, i, ab, abs;

  if IsOne(Word(a)) then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(a): false");
    Info(InfoAutomGrp, 3, "  IsOne(Word(a)): a = ", a);
    return false;
  fi;

  TryNextMethod();
end);


#########################################################################
##
#M  Order( <a> )
##
InstallMethod(Order, "for [IsInvertibleSelfSim]", true,
                   [IsInvertibleSelfSim],
function(a)
  local ord_loc;
  if HasIsFiniteState(GroupOfSelfSimFamily(FamilyObj(a))) and IsFiniteState(GroupOfSelfSimFamily(FamilyObj(a))) then
    if IsGeneratedByBoundedAutomaton(UnderlyingAutomatonGroup(GroupOfSelfSimFamily(FamilyObj(a)))) then
      return OrderUsingSections(a, infinity);
    fi;
  fi;
  if IsActingOnBinaryTree(a) and IsSphericallyTransitive(a) then
    return infinity;
  fi;
  ord_loc := OrderUsingSections(a, 10);
  if ord_loc <> fail then
    return ord_loc;
  fi;
  return OrderUsingSections(a, infinity);
end);


#########################################################################
##
#M  IsTransitiveOnLevel( <a>, <lev> )
##
InstallMethod(IsTransitiveOnLevel, "for [IsInvertibleSelfSim, IsPosInt]",
              [IsInvertibleSelfSim, IsPosInt],
function(a, lev)
  return Length(OrbitPerms([PermOnLevel(a, lev)], 1)) = a!.deg^lev;
end);


#########################################################################
##
#M  IsFiniteState( <a> )
##
InstallMethod(IsFiniteState, "for [IsSelfSim]", [IsSelfSim],
function(a)
  local st, state_words, find_all_sections;

  find_all_sections := function(s)
    local i;
    if not s!.word in state_words then
      Add(state_words, s!.word);
      for i in [1..s!.deg] do find_all_sections(Section(s, i)); od;
    fi;
  end;

  state_words := [];
  find_all_sections(a);
  SetAllSections(a, List(state_words, x -> SelfSim(x, FamilyObj(a))));
  return true;
end);


#########################################################################
##
#M  AllSections( <a> )
##
InstallMethod(AllSections, "for [IsSelfSim]", [IsSelfSim],
function(a)
  if IsFiniteState(a) then return AllSections(a); fi;
end);



#E
