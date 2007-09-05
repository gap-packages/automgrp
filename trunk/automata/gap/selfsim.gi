#############################################################################
##
#W  selfsim.gi               automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
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


InstallGlobalFunction($AG_CreateSelfSim,
function(family, word, states, perm, invertible)
  local a, cat;

  if invertible then
    cat := IsInvertibleSelfSim and IsSelfSimRep;

    if not AG_IsInvertibleTransformation(perm) then
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
#M  SelfSim(<word>, <fam>)
##
InstallMethod(SelfSim, "method for IsAssocWord and IsSelfSimFamily",
              [IsAssocWord, IsSelfSimFamily],
function(w, fam)
  local exp, wstates, curstate, newstate, curletter, newletter,
        nperm, i, j, perm, a, wtmp, reduced, invertible;

  if fam!.use_rws then
    w := ReducedForm(fam!.rws, w);
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
    perm:=();

    for j in [1..Length(exp)] do
      wstates[i] := wstates[i]*fam!.recurgens[exp[j]]!.states[i^perm];
      perm := perm * fam!.recurlist[exp[j]][fam!.deg+1];
    od;

#    if fam!.use_rws and Length(wstates[i]) > 0 then
#      wstates[i] := ReducedForm(fam!.rws, wstates[i]);
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

  return $AG_CreateSelfSim(fam, w, wstates, nperm, invertible);
end);


###############################################################################
##
#M  SelfSim(<word>, <a>)
##
InstallMethod(SelfSim, "method for IsAssocWord and IsSelfSim", [IsAssocWord, IsSelfSim],
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
#M  SelfSim(<word>, <list>)
##
InstallOtherMethod(SelfSim, "method for IsAssocWord and IsList",
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
#M  PrintObj(<a>)
##
InstallMethod(PrintObj, "method for IsSelfSim",
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
#M  ViewObj(<a>)
##
InstallMethod(ViewObj, "method for IsSelfSim",
              [IsSelfSim],
function (a)
  if IsOne(a!.word) then Print(AG_Globals.identity_symbol);
  else Print(a!.word); fi;
end);


###############################################################################
##
#M  String(<a>)
##
InstallMethod(String, "method for IsSelfSim",
              [IsSelfSim],
function (a)
  if IsOne(a!.word) then return AG_Globals.identity_symbol;
  else return String(a!.word); fi;
end);


###############################################################################
##
#M  Perm(<a>)
##
InstallOtherMethod(Perm, "method for IsSelfSim", [IsSelfSim],
function(a)
    return a!.perm;
end);


###############################################################################
##
#M  Word(<a>)
##
InstallMethod(Word, "method for IsSelfSim", [IsSelfSim],
function(a)
    return a!.word;
end);


###############################################################################
##
#M  <a1> * <a2>
##
InstallMethod(\*, "\*(IsSelfSim, IsSelfSim)", [IsSelfSim, IsSelfSim],
function(a1, a2)
    local a, i, fam, word, states;

    fam := FamilyObj(a1);
    word := a1!.word * a2!.word;

    if fam!.use_rws then
      word := ReducedForm(fam!.rws, word);
    fi;

    if IsOne(word) then
      return One(a1);
    fi;

    states := List([1..a1!.deg], i -> a1!.states[i] * a2!.states[i^(a1!.perm)]);

    if fam!.use_rws then
      for i in [1..a1!.deg] do
        states[i] := ReducedForm(fam!.rws, states[i]);
      od;
    fi;

    return $AG_CreateSelfSim(FamilyObj(a1), word, states, a1!.perm * a2!.perm,
                           IsInvertibleSelfSim(a1) and IsInvertibleSelfSim(a2));
end);





###############################################################################
##
#M  a1 < a2
##
InstallMethod(\<, "\<(IsSelfSim, IsSelfSim)", IsIdenticalObj, [IsSelfSim, IsSelfSim],
function(a1, a2)
  local d, checked, checked_words, p, pos, np, np_words, i, exp, exp_words, perm1, perm2, cmp;

  d := a1!.deg;
  exp := [a1, a2];
  exp_words := [a1!.word, a2!.word];


  checked := [exp];
  checked_words := [exp_words];
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
      np := [Section(p[1],i), Section(p[2],i)];
      np_words := List(np, x->x!.word);
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
#M  InverseOp(<a>)
##
InstallMethod(InverseOp, "InverseOp(IsInvertibleSelfSim)", [IsInvertibleSelfSim],
function(a)
  local i, inv, fam, word, states;

  fam := FamilyObj(a);
  word := a!.word ^ -1;
  if fam!.use_rws then
    word := ReducedForm(fam!.rws, word);
    if IsOne(word) then
      return One(a);
    fi;
  fi;

  states := List([1..a!.deg], i -> a!.states[i^(a!.perm^-1)]^-1);

  if fam!.use_rws then
    for i in [1..a!.deg] do
      states[i] := ReducedForm(fam!.rws, states[i]);
    od;
  fi;

  return $AG_CreateSelfSim(FamilyObj(a), word, states, a!.perm^-1, true);
end);


###############################################################################
##
#M  OneOp(<a>)
##
InstallMethod(OneOp, "OneOp(IsSelfSim)", [IsSelfSim],
function(a)
    return One(FamilyObj(a));
end);


###############################################################################
##
#M  StatesWords(<a>)
##
InstallMethod(StatesWords, "StatesWords(IsSelfSim)", [IsSelfSim],
function(a)
  return a!.states;
end);


###############################################################################
##
#M  Sections(a)
##
InstallMethod(Sections, "Sections(IsSelfSim)", [IsSelfSim],
function(a)
  return List(a!.states, s -> SelfSim(s, a));
end);


###############################################################################
##
#M  Section(a, k)
##
InstallOtherMethod(Section, "Section(IsSelfSim, IsPosInt)", [IsSelfSim, IsPosInt],
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
InstallMethod(Section, "Section(IsSelfSim, IsList)", [IsSelfSim, IsList],
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
InstallOtherMethod(\^, "\^(IsPosInt, IsSelfSim)", [IsPosInt, IsSelfSim],
function(k, a)
    return k ^ Perm(a);
end);


###############################################################################
##
#M  seq ^ a
##
InstallOtherMethod(\^, "\^(IsList, IsSelfSim)", [IsList, IsSelfSim],
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

    return Concatenation([seq[1]^Perm(a)], seq{[2..Length(seq)]}^Section(a,seq[1]));
end);


###############################################################################
##
#M  PermOnLevelOp(a, k)
##
## TODO
InstallMethod(PermOnLevelOp, "PermOnLevelOp(IsSelfSim, IsPosInt)",
              [IsInvertibleSelfSim, IsPosInt],
function(a, k)
  local dom, perm;

  if k = 1 then
    return a!.perm;
  fi;

  dom := AsList(Tuples([1.. a!.deg], k));
  perm := List(dom, s -> s ^ a);
  perm := PermListList(dom, perm);

  return perm;
end);

InstallMethod(TransformationOnFirstLevel, [IsSelfSim],
function(a)
  return a!.perm;
end);


###############################################################################
##
#M  IsActingOnBinaryTree(<a>)
##
InstallMethod(IsActingOnBinaryTree, "IsActingOnBinaryTree(IsSelfSim)",
              [IsSelfSim],
function(a)
    return a!.deg = 2;
end);


###############################################################################
##
#M  IsOne(<a>)
##
InstallMethod(IsOne, "IsOne(IsSelfSim)",
              [IsSelfSim],
function(a)
  local st,state_words, IsOneLocal;

  IsOneLocal:=function(s)
    local i, triv;
    if not IsOne(Perm(s)) then return false; fi;
    if s!.word in state_words then  return true; fi;

    Add(state_words,s!.word);
    triv:=true;
    i:=1;
    while triv and i<=s!.deg do
      triv:=IsOneLocal(Section(s,i));
      i:=i+1;
    od;
    return triv;
  end;

  state_words:=[];

  return IsOneLocal(a);
end);



###############################################################################
##
#M  a1 = a2
##
##
InstallMethod(\=, "\=(IsSelfSim, IsSelfSim)", IsIdenticalObj, [IsSelfSim, IsSelfSim],
function(a1, a2)
  local areequalstates, d, checked_pairs;
  d := a1!.deg;

  areequalstates := function(a,b)
    local j;

    if a!.word = b!.word then
      return true;
    fi;

    if [a!.word,b!.word] in checked_pairs then
      return true;
    else
      if a!.perm <> b!.perm then
        return false;
      fi;
      AddSet(checked_pairs, [a!.word, b!.word]);
      for j in [1..d] do
        if not areequalstates(Section(a,j),Section(b,j)) then
          return false;
        fi;
      od;
      return true;
    fi;
  end;

  checked_pairs:=[];
  return areequalstates(a1,a2);
end);



###############################################################################
##
#M  AbelImage(<a>)
##
InstallMethod(AbelImage, "AbelImage(IsSelfSim)",
              [IsSelfSim],
function(a)
  local abels, w, i;
  w := LetterRepAssocWord(Word(a));
  for i in [1..Length(w)] do
    if w[i] < 0 then w[i] := -w[i]+FamilyObj(a)!.numstates; fi;
  od;
  abels := AG_AbelImagesGenerators(FamilyObj(a));
  if not IsEmpty(w) then
    return Sum(List(w, x -> abels[x]));
  else
    return Zero(abels[1]);
  fi;
end);


InstallMethod(SphericalIndex, "SphericalIndex(IsSelfSim)", [IsSelfSim],
function(a)
  # XXX check uses of SphericalIndex everywhere
  return rec(start := [], period := [a!.deg]);
end);

# XXX check uses of this everywhere
InstallMethod(DegreeOfTree, "DegreeOfTree(IsSelfSim)", [IsSelfSim],
function(a)
  return a!.deg;
end);

# XXX check uses of this everywhere
InstallMethod(TopDegreeOfTree, "TopDegreeOfTree(IsSelfSim)", [IsSelfSim],
function(a)
  return a!.deg;
end);


###############################################################################
##
#M  CanEasilyTestSphericalTransitivity(<a>)
##
InstallTrueMethod(CanEasilyTestSphericalTransitivity,
                  IsActingOnBinaryTree and IsSelfSim);


###############################################################################
##
#M  IsSphericallyTransitive(<a>)
##
InstallMethod(IsSphericallyTransitive, "IsSphericallyTransitive(IsSelfSim)",
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
#M  Order(<a>)
##
InstallOtherMethod(Order, "Order(IsInvertibleSelfSim)", true,
                   [IsInvertibleSelfSim],
function(a)
  local ord_loc;
  if IsGeneratedByBoundedAutomaton(GroupOfSelfSimFamily(FamilyObj(a))) then
    return OrderUsingSections(a,infinity);
  fi;
  if IsActingOnBinaryTree(a) and IsSphericallyTransitive(a) then
    return infinity;
  fi;
  ord_loc := OrderUsingSections(a,10);
  if ord_loc <> fail then
    return ord_loc;
  fi;
  TryNextMethod();
end);


#########################################################################
##
#M  IsTransitiveOnLevel( <a>, <lev> )
##
InstallMethod(IsTransitiveOnLevel, "IsTransitiveOnLevel(IsInvertibleSelfSim,IsPosInt)",
              [IsInvertibleSelfSim, IsPosInt],
function(a,lev)
  return Length(OrbitPerms([PermOnLevel(a, lev)], 1)) = a!.deg^lev;
end);


#########################################################################
##
#M  IsFiniteState( <a> )
##
InstallMethod(IsFiniteState, "for [IsSelfSim]", [IsSelfSim],
function(a)
  local st,state_words, find_all_sections;

  find_all_sections:=function(s)
    local i;
    if not s!.word in state_words then
      Add(state_words,s!.word);
      for i in [1..s!.deg] do find_all_sections(Section(s,i)); od;
    fi;
  end;

  state_words:=[];
  find_all_sections(a);
  SetAllSections(a,List(state_words,x->SelfSim(x,FamilyObj(a))));
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
