#############################################################################
##
#W  rws.gi                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


DeclareGlobalFunction("__AG_FindRelators");

# It's not an IsRewritingSytem object
DeclareCategory("IsAGRewritingSystem", IsObject);

DeclareRepresentation("IsAGRewritingSystemRep",
                      IsComponentObjectRep,
                      ["rels",    # list of relators, they are words in the family's free group
                       "kb",      # Knuth-Bendix rewriting system
                       "fam",     # the automata family
                       "fpg_fam", # family of the elements from FP group <freegroup / rels>
                       "fpm_fam", # family of the elements of FP monoid obtained from the above group
                       "mhom",    # isomorphism from the FP group to the FP monoid
                      ]);

__AG_CreateRewritingSystem := function(fam, rels)
  local grp, fr_grp, fp_grp, fp_mon, fmon,
        ord, m_gens, rws, rws_data;

  rws_data := rec(fam := fam);

  if rels = fail then
    rels := __AG_FindRelators(fam, AG_Globals.max_rws_relator_len);
  fi;
  rws_data.rels := Difference(rels, [Word(One(fam))]);

  if IsAutomFamily(fam) then
    grp := GroupOfAutomFamily(fam);
  else
    grp := GroupOfSelfSimFamily(fam);
  fi;

  fr_grp := UnderlyingFreeGroup(grp);
  fp_grp := fr_grp / rels;
  rws_data.mhom := IsomorphismFpMonoid(fp_grp);
  fp_mon := Image(rws_data.mhom);
  fmon := FreeMonoidOfFpMonoid(fp_mon);

  rws_data.fpg_fam := FamilyObj(One(fp_grp));
  rws_data.fpm_fam := FamilyObj(One(fp_mon));

  m_gens := GeneratorsOfMonoid(fmon);
#  Print("mgens1=",m_gens,"\n");
#  m_gens := Permuted(m_gens, Product(List([1..Length(m_gens)/2], k->(2*k-1, 2*k))));
#  Print("mgens2=",m_gens,"\n");
  ord := ShortLexOrdering(FamilyObj(One(fmon)), m_gens);

  rws_data.kb := KnuthBendixRewritingSystem(fp_mon, ord);
  MakeConfluent(rws_data.kb);

  rws := Objectify(NewType(NewFamily("AGRewritingSystem"),
                           IsAGRewritingSystem and IsAGRewritingSystemRep),
                   rws_data);

  return rws;
end;


__AG_ReducedForm := function(rws, word)
  local reduced, word_mon;
  word_mon := ImageElm(rws!.mhom, ElementOfFpGroup(rws!.fpg_fam, word));
  reduced := ReducedForm(rws!.kb, UnderlyingElement(word_mon));
  word_mon := ElementOfFpMonoid(rws!.fpm_fam, reduced);
  return UnderlyingElement(PreImagesRepresentative(rws!.mhom, word_mon));
end;


InstallGlobalFunction(__AG_FindRelators,
function(fam, max_len)
  local fr_grp, w, elm, rels;

  if fam!.rws = fail then
    rels := [];
  else
    rels := List(fam!.rws!.rels);
  fi;

  fr_grp := UnderlyingFreeGroup(fam);

  # XXX FindRelations?
  for w in fr_grp do
    if Length(w) > max_len then
      break;
    fi;
    if IsAutomFamily(fam) then
      elm := Autom(w, fam);
    else
      elm := SelfSim(w, fam);
    fi;
    if IsOne(elm) then
      Add(rels, w);
    fi;
  od;

  return Difference(rels, [One(fr_grp)]);
end);


__AG_UpdateRewritingSystem := function(arg)
  local fam, max_len, new_rels;

  fam := arg[1];
  if Length(arg) > 1 then
    max_len := arg[2];
  else
    max_len := AG_Globals.max_rws_relator_len;
  fi;

  new_rels := __AG_FindRelators(fam, max_len);
  if fam!.rws = fail or new_rels <> fam!.rws!.rels then
    fam!.rws := __AG_CreateRewritingSystem(fam, new_rels);
  fi;

  return fail;
end;


__AG_UseRewritingSystem := function(fam, use)
  if fam!.use_rws <> use then
    if use then
      if fam!.rws = fail then
        fam!.rws := __AG_CreateRewritingSystem(fam, fail);
      fi;
    fi;
    fam!.use_rws := use;
  fi;
end;


__AG_RewritingSystem := function(fam)
  return fam!.rws;
end;


__AG_AddRelators := function(fam, rels)
  local old_rels;
  if fam!.rws = fail then
    old_rels := [];
  else
    old_rels := fam!.rws!.rels;
  fi;
  rels := Difference(Union(old_rels, rels), [One(UnderlyingFreeGroup(fam))]);
  if rels <> old_rels then
    fam!.rws := __AG_CreateRewritingSystem(fam, rels);
  fi;
end;


InstallMethod(AG_ReducedForm, [IsAGRewritingSystem, IsAssocWord],
function(rws, w)
  return __AG_ReducedForm(rws, w);
end);

InstallMethod(AG_ReducedForm, [IsAGRewritingSystem, IsList and IsAssocWordCollection],
function(rws, words)
  return Difference(List(words, w -> __AG_ReducedForm(rws, w)), [One(words[1])]);
end);


__AG_ReducedFormOfGroup := function(group, fam, construct)
  local gens, rws;

  if not fam!.use_rws then
    return group;
  fi;

  gens := GeneratorsOfGroup(group);
  gens := List(AG_ReducedForm(fam!.rws, List(gens, a -> Word(a))), w -> construct(w, fam));
  gens := Difference(gens, [One(group)]);
  if IsEmpty(gens) then
    return Group(One(group));
  else
    return GroupWithGenerators(gens);
  fi;
end;

InstallMethod(AG_ReducedForm, [IsAutomGroup],
function(group)
  return __AG_ReducedFormOfGroup(group, UnderlyingAutomFamily(group), Autom);
end);

InstallMethod(AG_ReducedForm, [IsSelfSimGroup],
function(group)
  return __AG_ReducedFormOfGroup(group, UnderlyingSelfSimFamily(group), SelfSim);
end);

__AG_ReducedFormOfElm := function(g, construct)
  local fam;

  fam := FamilyObj(g);

  if not fam!.use_rws then
    return g;
  else
    return construct(AG_ReducedForm(fam!.rws, Word(g)), fam);
  fi;
end;

InstallMethod(AG_ReducedForm, [IsAutom],
function(g)
  return __AG_ReducedFormOfElm(g, Autom);
end);

InstallMethod(AG_ReducedForm, [IsSelfSim],
function(g)
  return __AG_ReducedFormOfElm(g, SelfSim);
end);


InstallMethod(AG_UseRewritingSystem, [IsObject],
function(obj)
  AG_UseRewritingSystem(obj, true);
end);

InstallMethod(AG_UseRewritingSystem, [IsAutomFamily, IsBool],
function(fam, use)
  __AG_UseRewritingSystem(fam, use);
end);

InstallMethod(AG_UseRewritingSystem, [IsAutomGroup, IsBool],
function(grp, use)
  AG_UseRewritingSystem(UnderlyingAutomFamily(grp), use);
end);

InstallMethod(AG_UseRewritingSystem, [IsSelfSimFamily, IsBool],
function(fam, use)
  __AG_UseRewritingSystem(fam, use);
end);

InstallMethod(AG_UseRewritingSystem, [IsSelfSimGroup, IsBool],
function(grp, use)
  AG_UseRewritingSystem(UnderlyingSelfSimFamily(grp), use);
end);


InstallMethod(AG_UpdateRewritingSystem, [IsObject],
function(obj)
  AG_UpdateRewritingSystem(obj, AG_Globals.max_rws_relator_len);
end);

InstallMethod(AG_UpdateRewritingSystem, [IsAutomFamily, IsPosInt],
function(fam, max_len)
  __AG_UpdateRewritingSystem(fam, max_len);
end);

InstallMethod(AG_UpdateRewritingSystem, [IsAutomGroup, IsPosInt],
function(grp, max_len)
  AG_UpdateRewritingSystem(UnderlyingAutomFamily(grp), max_len);
end);

InstallMethod(AG_UpdateRewritingSystem, [IsSelfSimFamily, IsPosInt],
function(fam, max_len)
  __AG_UpdateRewritingSystem(fam, max_len);
end);

InstallMethod(AG_UpdateRewritingSystem, [IsSelfSimGroup, IsPosInt],
function(grp, max_len)
  AG_UpdateRewritingSystem(UnderlyingSelfSimFamily(grp), max_len);
end);


InstallMethod(AG_RewritingSystem, [IsAutomFamily],
function(fam)
  return __AG_RewritingSystem(fam);
end);

InstallMethod(AG_RewritingSystem, [IsAutomGroup],
function(grp)
  return AG_RewritingSystem(UnderlyingAutomFamily(grp));
end);

InstallMethod(AG_RewritingSystem, [IsSelfSimFamily],
function(fam)
  return __AG_RewritingSystem(fam);
end);

InstallMethod(AG_RewritingSystem, [IsSelfSimGroup],
function(grp)
  return AG_RewritingSystem(UnderlyingSelfSimFamily(grp));
end);


InstallMethod(AG_RewritingSystemRules, [IsObject],
function(obj)
  return Rules(AG_RewritingSystem(obj)!.kb);
end);


InstallMethod(AG_AddRelators, [IsAutomGroup, IsList and IsAssocWordCollection],
function(obj, rels) __AG_AddRelators(UnderlyingAutomFamily(obj), rels); end);

InstallMethod(AG_AddRelators, [IsAutomFamily, IsList and IsAssocWordCollection],
function(obj, rels) __AG_AddRelators(obj, rels); end);

InstallMethod(AG_AddRelators, [IsSelfSimGroup, IsList and IsAssocWordCollection],
function(obj, rels) __AG_AddRelators(UnderlyingSelfSimFamily(obj), rels); end);

InstallMethod(AG_AddRelators, [IsSelfSimFamily, IsList and IsAssocWordCollection],
function(obj, rels) __AG_AddRelators(obj, rels); end);

InstallMethod(AG_AddRelators, [IsObject, IsList and IsAutomCollection],
function(obj, list)
  AG_AddRelators(obj, List(list, g -> Word(g)));
end);

InstallMethod(AG_AddRelators, [IsObject, IsList and IsSelfSimCollection],
function(obj, list)
  AG_AddRelators(obj, List(list, g -> Word(g)));
end);
