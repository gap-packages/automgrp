#############################################################################
##
#W  rws.gi                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


DeclareRepresentation("IsAGRewritingSystemRep",
                      IsComponentObjectRep, # must not be IsAttributeStoringRep
                      ["rules",   # list of pairs [v, w] where v and w are stored as
                                  # list of exponents of free generators, e.g.
                                  # [[1, 1], []] or [[-1], [1]] if 1-st generator is an involution.
                       "ngens",   # number of free generators
                       "names"    # names of generators
                      ]);


InstallMethod(AGRewritingSystem, [IsPosInt],
function(n)
  local rws, names;

  names := List([1..n], i -> Concatenation("a", String(i)));
  rws := Objectify(NewType(NewFamily("AGRewritingSystem"),
                           IsAGRewritingSystem and IsAGRewritingSystemRep),
                   rec(rules := [],
                       ngens := n,
                       names := names));

  return rws;
end);

InstallMethod(AGRewritingSystem, [IsPosInt, IsList],
function(n, rules)
  local rws, names;

  rws := AGRewritingSystem(n);
  AddRules(rws, rules);

  return rws;
end);


InstallMethod(AddRules, [IsAGRewritingSystem, IsList],
function(rws, new_rules)
  AddRules(rws, new_rules, false);
end);

InstallMethod(AddRules, [IsAGRewritingSystem, IsList, IsBool],
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


InstallMethod(SetRwRules, [IsAGRewritingSystem, IsList],
function(rws, new_rules)
  rws!.rules := StructuralCopy(new_rules);
end);


InstallOtherMethod(AddRule, [IsAGRewritingSystem, IsList],
function(rws, rule)
  AddRules(rws, [rule], false);
end);

InstallOtherMethod(AddRule, [IsAGRewritingSystem, IsList, IsBool],
function(rws, rule, start)
  AddRules(rws, [rule], start);
end);


InstallMethod(Rules, [IsAGRewritingSystem],
function(rws)
  return rws!.rules;
end);


$FA_rws_print_word := function(rws, word)
  local s, i, j, len;

  s := "";
  len := Length(word);

  if len = 0 then
    return AG_Globals.identity_symbol;
  fi;

  i := 1;
  while i <= len do
    j := i + 1;
    while j <= len and word[j] = word[i] do j := j + 1; od;
    if i > 1 then
      Append(s, "*");
    fi;
    Append(s, rws!.names[AbsInt(word[i])]);
    if j - i > 1 or word[i] < 0 then
      Append(s, "^");
      if word[i] < 0 then
        Append(s, "-");
      fi;
      Append(s, String(j - i));
    fi;
    i := j;
  od;

  return s;
end;

InstallMethod(PrintObj, [IsAGRewritingSystem],
function(rws)
  local i;

  Print("<< ");

  for i in [1..Length(rws!.rules)] do
    if i <> 1 then
      Print(", ");
    fi;
    Print($FA_rws_print_word(rws, rws!.rules[i][1]), " -> ",
          $FA_rws_print_word(rws, rws!.rules[i][2]));
  od;

  Print(" >>");
end);

InstallMethod(ViewObj, [IsAGRewritingSystem],
function(rws)
  Print("<< ");
  if IsEmpty(rws!.rules) then
    Print("empty ");
  fi;
  Print("rewriting system on ", rws!.ngens, " generators >>");
end);


$FA_rws_mult := function(w1, w2)
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

InstallMethod(ReducedForm, [IsAGRewritingSystem and IsAGRewritingSystem, IsList],
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
          w := $FA_rws_mult($FA_rws_mult(w{[1 .. pos-1]}, r[2]), w{[pos+Length(r[1]) .. Length(w)]});
          start := pos;
          break;
        fi;
      od;
    od;
  od;

  return w;
end);

InstallMethod(ReducedForm, [IsAGRewritingSystem and IsAGRewritingSystem, IsAssocWord],
function(rws, g)
  return AssocWordByLetterRep(FamilyObj(g), ReducedForm(rws, LetterRepAssocWord(g)));
end);

InstallMethod(ReducedForm, [IsAGRewritingSystem and IsAGRewritingSystem, IsAutom],
function(rws, a)
  return Autom(ReducedForm(rws, a!.word), a);
end);

InstallOtherMethod(ReducedForm, [IsAutom],
function(a)
  local rws;
  rws := AGRewritingSystem(FamilyObj(a));
  if rws = fail then
    return fail;
  else
    return ReducedForm(rws, a);
  fi;
end);

InstallMethod(ReducedForm, [IsAGRewritingSystem and IsAGRewritingSystem, IsList and IsAutomCollection],
function(rws, list)
  if IsEmpty(list) then
    return [];
  else
    return Difference(List(list, a -> ReducedForm(rws, a)), [One(list[1])]);
  fi;
end);

InstallOtherMethod(ReducedForm, [IsList and IsAutomCollection],
function(list)
  local rws;
  rws := AGRewritingSystem(FamilyObj(list[1]));
  if rws = fail then
    return fail;
  else
    return ReducedForm(rws, list);
  fi;
end);

InstallMethod(ReducedForm, [IsAGRewritingSystem and IsAGRewritingSystem, IsAutomGroup],
function(rws, grp)
  local gens;
  gens := Difference(ReducedForm(rws, GeneratorsOfGroup(grp)), [One(grp)]);
  gens := ReducedForm(rws, AG_ReducedByNielsen(gens));
  gens := Difference(gens, [One(grp)]);
  if IsEmpty(gens) then
    return Group(One(grp));
  else
    return Group(gens);
  fi;
end);

InstallOtherMethod(ReducedForm, [IsAutomGroup],
function(grp)
  local fam, rws;
  fam := UnderlyingAutomFamily(grp);
  if fam!.use_rws then
    return ReducedForm(fam!.rws, grp);
  else
    return grp;
  fi;
end);

InstallOtherMethod(ReducedForm, [IsTreeAutomorphism],
function(a)
  return a;
end);

InstallOtherMethod(ReducedForm, [IsList and IsTreeAutomorphismCollection],
function(list)
  if not IsEmpty(list) then
    return Difference(list, One(list[1]));
  else
    return [];
  fi;
end);

InstallOtherMethod(ReducedForm, [IsTreeAutomorphismGroup],
function(grp)
  return grp;
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

BuildAGRewritingSystem :=
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
  rws := AGRewritingSystem(fam!.numstates, init_rules);
  rws!.names := ShallowCopy(fam!.names);

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


InstallMethod(AGRewritingSystem, [IsAutomFamily],
function(fam)
  if fam!.rws = fail then
    BuildAGRewritingSystem(fam);
    if fam!.rws = fail then
      fam!.rws := AGRewritingSystem(fam!.numstates);
      fam!.rws!.names := ShallowCopy(fam!.names);
    fi;
  fi;
  return fam!.rws;
end);

InstallOtherMethod(AGRewritingSystem, [IsGroupOfAutomFamily],
function(grp)
  return AGRewritingSystem(UnderlyingAutomFamily(grp));
end);


InstallMethod(UseAGRewritingSystem, [IsAutomFamily, IsBool],
function(fam, use)
  if fam!.use_rws <> use then
    if use then
      if AGRewritingSystem(fam) = fail then
        return fail;
      fi;
      fam!.use_rws := true;
    else
      fam!.use_rws := false;
    fi;
  fi;

  return fam!.use_rws;
end);

InstallOtherMethod(UseAGRewritingSystem, [IsGroupOfAutomFamily, IsBool],
function(grp, use)
  return UseAGRewritingSystem(UnderlyingAutomFamily(grp), use);
end);

InstallOtherMethod(UseAGRewritingSystem, [IsAutomFamily],
function(fam) return UseAGRewritingSystem(fam, true); end);

InstallOtherMethod(UseAGRewritingSystem, [IsGroupOfAutomFamily],
function(grp) return UseAGRewritingSystem(grp, true); end);
