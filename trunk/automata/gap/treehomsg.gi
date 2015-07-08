#############################################################################
##
#W  treehomsg.gi             automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.2.4
##
#Y  Copyright (C) 2003 - 2014 Yevgen Muntyan, Dmytro Savchuk
##


BindGlobal("AG_SemigroupIterator",
function(arg)
  local next_iterator, is_done_iterator, shallow_copy,
        create_iter_rec, G, max_len;

  max_len := infinity;
  G := arg[1];
  if Length(arg) > 1 then
    max_len := arg[2];
    if not IsMonoid(G) and IsInt(max_len) then
      max_len := max_len - 1;
    fi;
  fi;

  create_iter_rec := function(G)
    local record, gens;

    record := rec(
      NextIterator := next_iterator,
      IsDoneIterator := is_done_iterator,
      ShallowCopy := shallow_copy,

      group := G,
      done := false,
      max_len := max_len,

      gens_ptr := [1, 1],

      ptr := 1,
    );

    if IsGroup(G) then
      # GAP is smart, it knows that a semigroup generated by group
      # generators of a finite group is in fact the whole group
      gens := GeneratorsOfGroup(G);
      record.gens := Difference(Concatenation(gens, List(gens, g->g^-1)), [One(G)]);
      record.elms := Concatenation([One(G)], record.gens);
      record.levels := [[1], [2..1+Length(record.gens)], []];
    elif IsMonoid(G) then
      record.gens := Difference(GeneratorsOfSemigroup(G), [One(G)]);
      record.elms := Concatenation([One(G)], record.gens);
      record.levels := [[1], [2..1+Length(record.gens)], []];
    else
      record.gens := ShallowCopy(GeneratorsOfSemigroup(G));
      record.elms := ShallowCopy(record.gens);
      record.levels := [[1..Length(record.gens)], []];
    fi;
    record.n_gens := Length(record.gens);

    if record.n_gens = 0 then
      record.is_list := true;
    elif IsMonoid(G) then
      if max_len = 0 then
        record.is_list := true;
        record.elms := [One(G)];
      else
        record.is_list := max_len = 1;
      fi;
    else
      if max_len = -1 then
        record.is_list := true;
        record.elms := [];
      else
        record.is_list := max_len = 0;
      fi;
    fi;

    return record;
  end;

  next_iterator := function(iter)
    local elm;

    if is_done_iterator(iter) then
      Error("<iter> is exhausted");
    fi;

    elm := iter!.elms[iter!.ptr];
    iter!.ptr := iter!.ptr + 1;

    return elm;
  end;

  is_done_iterator := function(iter)
    local gens_ptr, gens, elm, elm_list, levels, n_levels, added;

    if iter!.done then
      return true;
    fi;

    if iter!.ptr <= Length(iter!.elms) then
      return false;
    fi;

    if iter!.is_list then
      iter!.done := true;
      return true;
    fi;

    gens_ptr := iter!.gens_ptr;
    gens := iter!.gens;
    elm_list := iter!.elms;
    levels := iter!.levels;
    n_levels := Length(levels);
    added := false;

    while not added do
      if gens_ptr[1] > Length(levels[n_levels-1]) then
        if IsEmpty(levels[n_levels]) then
          iter!.done := true;
          SetIsFinite(iter!.group, true);
          SetSize(iter!.group, Length(elm_list));
          break;
        elif n_levels > iter!.max_len then
          iter!.done := true;
          break;
        fi;

        Add(levels, []);
        n_levels := n_levels + 1;
        gens_ptr[1] := 1;
      fi;

      elm := elm_list[levels[n_levels-1][gens_ptr[1]]] * gens[gens_ptr[2]];

      if IsGroup(iter!.group) then
        if not elm in elm_list{levels[n_levels-2]} and
           not elm in elm_list{levels[n_levels-1]} and
           not elm in elm_list{levels[n_levels]}
        then
          if elm in elm_list then
            Print("elm: ", elm, "\n");
            Print("elm_list: ", elm_list, "\n");
            Print("levels: ", levels, "\n");
            Print("n_levels: ", n_levels, "\n");
            Error("WTF");
          fi;
          Add(elm_list, elm);
          Add(levels[n_levels], Length(elm_list));
          added := true;
        fi;
      elif not elm in elm_list then
        Add(elm_list, elm);
        Add(levels[n_levels], Length(elm_list));
        added := true;
      fi;

      gens_ptr[2] := gens_ptr[2] + 1;
      if gens_ptr[2] > Length(gens) then
        gens_ptr[2] := 1;
        gens_ptr[1] := gens_ptr[1] + 1;
      fi;
    od;

    return iter!.done;
  end;

  shallow_copy := function(iter)
    return create_iter_rec(iter!.G);
  end;

  return IteratorByFunctions(create_iter_rec(G));
end);


################################################################################
##
#M  Iterator( <G>[, <max_len>] )
##
##  Provides a possibility to loop over elements of a group (semigroup, monoid)
##  generated by automata. If <max_len>  is given stops after enumerating all elements
##  of length up to <max_len>.
##  \beginexample
##  gap> GrigorchukGroup := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> iter := Iterator(GrigorchukGroup,5);
##  <iterator>
##  gap> l := [];;
##  gap> for g in iter do
##  >      if Order(g) = 16 then Add(l,g); fi;
##  >    od;
##  gap> l;
##  [ b*a, a*b, d*a*c, c*a*d, d*a*c*a, d*a*b*a, c*a*d*a, b*a*d*a, a*d*a*c,
##    a*d*a*b, a*c*a*d, a*b*a*d, c*a*c*a*b, c*a*b*a*b, b*a*c*a*c, b*a*b*a*c,
##    a*d*a*c*a, a*c*a*d*a ]
##  \endexample
##
InstallMethod(Iterator, [IsTreeHomomorphismSemigroup],
function(G)
  return AG_SemigroupIterator(G, infinity);
end);

InstallOtherMethod(Iterator, [IsTreeHomomorphismSemigroup, IsCyclotomic],
function(G, max_len)
  return AG_SemigroupIterator(G, max_len);
end);


###############################################################################
##
#M  TransformationSemigroupOnLevelOp (<G>, <k>)
##
InstallMethod(TransformationSemigroupOnLevelOp, "for [IsTreeHomomorphismSemigroup, IsPosInt]",
              [IsTreeHomomorphismSemigroup, IsPosInt],
function(G, k)
  local pgens, psemigroup, i;
  pgens := List(GeneratorsOfSemigroup(G), g -> TransformationOnLevel(g, k));

  # if there are Permutations and transformations convert all to transformations
  if Position(List(pgens,IsPerm),false) <> fail and Position(List(pgens,IsPerm),true) <> fail then
    for i in [1..Length(pgens)] do
      if IsPerm(pgens[i]) then pgens[i]:=AsTransformation(pgens[i]); fi;
    od;
  fi;

  psemigroup := SemigroupByGenerators(pgens);
  return psemigroup;
end);


###############################################################################
##
#M  MarkovOperator(<G>, <lev>, <weights>)
##
InstallMethod(MarkovOperator, "for [IsTreeHomomorphismSemigroup, IsCyclotomic, IsList]",
              [IsTreeHomomorphismSemigroup, IsCyclotomic, IsList],
function(G, n, weights)
  local gens,R,indet;
  gens := ShallowCopy(GeneratorsOfSemigroup(G));
  if Length(weights)<>Length(gens) then Error("The number of weights must match the number of generators"); fi;
  if IsString(weights[1]) then
    R:=PolynomialRing(Integers,weights);
    indet:=IndeterminatesOfPolynomialRing(R);
    return Sum(List([1..Length(gens)], x -> indet[x]*TransformationOnLevelAsMatrix(gens[x], n)));
  else
    return Sum(List([1..Length(gens)], x -> weights[x]*TransformationOnLevelAsMatrix(gens[x], n)));
  fi;
end);


###############################################################################
##
#M  MarkovOperator(<G>, <lev>)
##
InstallMethod(MarkovOperator, "for [IsTreeHomomorphismSemigroup, IsCyclotomic]",
              [IsTreeHomomorphismSemigroup, IsCyclotomic],
function(G, n)
  return MarkovOperator(G,n,List([1..Length(GeneratorsOfGroup(G))],x->1/(2*Length(GeneratorsOfGroup(G)))));
end);


###############################################################################
##
#M  Section(<G>, <v>)
##
InstallMethod(Section, "for [IsTreeHomomorphismSemigroup, IsList]",
              [IsTreeHomomorphismSemigroup, IsList],
function(G, v)
  local gens, g, sec_gens;
  gens:=GeneratorsOfSemigroup(G);
  for g in gens do
    if v^g<>v then
      Error("Section([IsTreeHomomorphismSemigroup, IsList]): <G> does not fix <v>");
      return fail;
    fi;
  od;

  if not IsAutomSemigroup(G) then
    return Semigroup(List(gens,x->Section(x,v)));
  else
    sec_gens:=[];
    for g in List(gens,x->Section(x,v)) do
      if not IsOne(g) and not g in sec_gens then
        Add(sec_gens, g);
      fi;
    od;
    if Length(sec_gens)>0 then
      return Semigroup(sec_gens);
    else
      return Semigroup([One(FamilyObj(Section(gens[1],v)))]);
    fi;
  fi;
end);


###############################################################################
##
#M  Section(<G>, <n>)
##
InstallMethod(Section, "for [IsTreeHomomorphismSemigroup, IsPosInt]",
              [IsTreeHomomorphismSemigroup, IsPosInt],
function(G, n)
  return Section(G,[n]);
end);


#E
