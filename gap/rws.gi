#############################################################################
##
#W  rws.gi                  automata package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


DeclareRepresentation("IsFARewritingSystemRep",
                      IsComponentObjectRep, # must not be IsAttributeStoringRep
                      ["rules",   # list of pairs [v, w] where v and w are stored as
                                  # list of exponents of free generators, e.g.
                                  # [[1, 1], []] or [[-1], [1]] if 1-st generator is an involution.
                       "ngens",   # number of free generators
                       "names"    # names of generators
                      ]);


InstallMethod(FARewritingSystem, [IsPosInt],
function(n)
  local rws, names;

  names := List([1..n], i -> Concatenation("a", String(i)));
  rws := Objectify(NewType(NewFamily("FARewritingSystem"),
                           IsFARewritingSystem and IsFARewritingSystemRep),
                   rec(rules := [],
                       ngens := n,
                       names := names));

  SetIsBuiltFromGroup(rws,true);

  return rws;
end);

InstallMethod(FARewritingSystem, [IsPosInt, IsList],
function(n, rules)
  local rws, names;

  rws := FARewritingSystem(n);
  AddRules(rws, rules);

  return rws;
end);


InstallMethod(AddRules, [IsFARewritingSystem, IsList],
function(rws, new_rules)
  AddRules(rws, new_rules, false);
end);

InstallMethod(AddRules, [IsFARewritingSystem, IsList, IsBool],
function(rws, new_rules, start)
  local tmp;
  if start then
    tmp := rws!.rules;
    rws!.rules := StructuralCopy(new_rules);
    Append(rws!.rules, tmp);
  else
    Append(rws!.rules, StructuralCopy(new_rules));
  fi;
end);


InstallMethod(SetRwRules, [IsFARewritingSystem, IsList],
function(rws, new_rules)
  rws!.rules := StructuralCopy(new_rules);
end);


InstallOtherMethod(AddRule, [IsFARewritingSystem, IsList],
function(rws, rule)
  AddRules(rws, [rule], false);
end);

InstallOtherMethod(AddRule, [IsFARewritingSystem, IsList, IsBool],
function(rws, rule, start)
  AddRules(rws, [rule], start);
end);


InstallMethod(Rules, [IsFARewritingSystem],
function(rws)
  return rws!.rules;
end);


mult := function(w1, w2)
  local s, e, len;

  e := Length(w1);
  s := 1;
  len := Length(w2);

  while e > 0 and s <= len and w1[e] = -w2[s] do
    e := e - 1;
    s := s + 1;
  od;

  return Concatenation(w1{[1..e]}, w2{[s..len]});
end;

InstallMethod(ReducedForm, [IsFARewritingSystem and IsFARewritingSystem, IsList],
function(rws, w)
  local start, pos, r, again, reduced, n_rules, rules;

  rules := rws!.rules;
  n_rules := Length(rules);
  reduced := true;

  while reduced do
    reduced := false;
    again := true;
    start := 0;
    while again do
      again := false;
      for r in rules do
        pos := PositionSublist(w, r[1], start);
        if pos <> fail then
#           Print("found ", r[1], " in ", w, " at position ", pos, "\n");
#           Print("replacing with ", r[2], "\n");
          again := true;
          reduced := true;
          w := mult(mult(w{[1 .. pos-1]}, r[2]), w{[pos+Length(r[1]) .. Length(w)]});
          start := pos;
          break;
        fi;
      od;
    od;
  od;

  return w;
end);

InstallMethod(ReducedForm, [IsFARewritingSystem and IsFARewritingSystem, IsAssocWord],
function(rws, g)
  return AssocWordByLetterRep(FamilyObj(g), ReducedForm(rws, LetterRepAssocWord(g)));
end);

InstallMethod(ReducedForm, [IsFARewritingSystem and IsFARewritingSystem, IsAutom],
function(rws, a)
  return Autom(ReducedForm(rws, a!.word), a);
end);

InstallMethod(ReducedForm, [IsFARewritingSystem and IsFARewritingSystem, IsList and IsAutomCollection],
function(rws, list)
  return List(list, a -> ReducedForm(rws, a));
end);

InstallMethod(ReducedForm, [IsFARewritingSystem and IsFARewritingSystem, IsAutomGroup],
function(rws, grp)
  local gens;
  gens := ReducedForm(rws, ReducedByNielsen(ReducedForm(rws, GeneratorsOfGroup(grp))));
  gens := Difference(gens, [One(grp)]);
  if IsEmpty(gens) then
    return Group(One(grp));
  else
    return Group(gens);
  fi;
end);



$FA_rws_get_rels :=
function(fam, maxlen)
  local words, rels, i, j, w, nw,
        freegen, letters;

  letters := fam!.numstates;
  freegen := fam!.freegens[1];

  rels := List([1..maxlen], i->[]);
  words := List([1..maxlen], i->[]);
  words[1] := Concatenation(List([1..letters], i->[[i], [-i]]));

  for i in [1 .. maxlen-1] do
    for w in words[i] do
      if not w in rels[i] then
        for j in [1..letters] do
          if j <> -w[i] then
            nw := Concatenation(w, [j]);
            Add(words[i+1], nw);
            if IsOne(Autom(AssocWordByLetterRep(FamilyObj(freegen), nw), fam)) then
              Add(rels[i+1], nw);
            fi;
          fi;
          if j <> w[i] then
            nw := Concatenation(w, [-j]);
            Add(words[i+1], nw);
            if IsOne(Autom(AssocWordByLetterRep(FamilyObj(freegen), nw), fam)) then
              Add(rels[i+1], nw);
            fi;
          fi;
        od;
      fi;
    od;
  od;

  return [Concatenation(words), Concatenation(rels)];
end;

$FA_rws_inv := function(w)
  local len;
  len := Length(w);
  return List([1..len], i -> -w[len-i+1]);
end;

$FA_rws_add_rule := function(rws, rule)
  local new;

  new := List(rule, w -> ReducedForm(rws, w));

  if Length(new[1]) >= Length(new[2]) and new[1] <> new[2] and
     not new in rws!.rules
  then
    AddRule(rws, new);
  fi;
end;

BuildFARewritingSystem :=
function(arg)
  local limit, init_rules,
        fam, frgrp, rels, w, g, rws,
        len, i, right;

  if IsAutomFamily(arg[1]) then
    fam := arg[1];
  elif IsAutomGroup(arg[1]) then
    fam := UnderlyingAutomFamily(arg[1]);
  else
    Error();
  fi;

  limit := 4;
  init_rules := [];

  if Length(arg) > 1 then
    limit := arg[2];
  fi;
  if Length(arg) > 2 then
    init_rules := arg[3];
  fi;

  frgrp := fam!.freegroup;

  rels := $FA_rws_get_rels(fam, limit)[2];
  rws := FARewritingSystem(fam!.numstates, init_rules);

  for w in rels do
    len := Length(w);
    $FA_rws_add_rule(rws, [w, []]);

    for i in [1 .. Int(len/2)] do
      $FA_rws_add_rule(rws, [$FA_rws_inv(w{[1 .. len-i]}), w{[len-i+1 .. len]}]);
    od;
  od;

  if not IsEmpty(rws!.rules) and fam!.rws = fail then
    fam!.rws := rws;
  fi;

  return rws;
end;
