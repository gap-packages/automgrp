#############################################################################
##
#W  utilsfrgrp.gi              automata package                Yevgen Muntyan
##                                                              Dmytro Sachuk
##
##  automata v 0.91 started June 07 2004
##

Revision.utilsfrgrp_gi :=
  "@(#)$Id$";


##  TODO everything


#############################################################################
##
#F  InverseLessThanForLetters(<w1>, <w2>)
##
##  Compares w1 and w2 according to lexicografic ordering given by
##  x1 < x1^-1 < x2 < x2^-1 < ...
##
BindGlobal("InverseLessThanForLetters",
function(w1, w2)
  local i, er1, er2;

  if Length(w1) <> Length(w2) then
    return Length(w1) < Length(w2);
  fi;

  er1 := LetterRepAssocWord(w1);
  er2 := LetterRepAssocWord(w2);
  for i in [1..Length(er1)] do
    if AbsInt(er1[i]) <> AbsInt(er2[i]) then
      return AbsInt(er1[i]) < AbsInt(er2[i]);
    fi;
    if er1[i] <> er2[i] then
      return er1[i] > er2[i];
    fi;
  od;

  return false;
end);


#############################################################################
##
#M  ReduceListOfWordsByNielsen(<words_list>)
#M  ReduceListOfWordsByNielsenBack(<words_list>)
#M  ReduceListOfWordsByNielsen(<words_list>, <string>)
#M  ReduceListOfWordsByNielsenBack(<words_list>, <string>)
##
InstallMethod(ReduceListOfWordsByNielsen, [IsAssocWordCollection],
function(words)
  return ReduceListOfWordsByNielsen(words, \<);
end);

InstallMethod(ReduceListOfWordsByNielsenBack, [IsAssocWordCollection],
function(words)
  return ReduceListOfWordsByNielsen(words, \<);
end);

InstallOtherMethod(ReduceListOfWordsByNielsen, [IsAssocWordCollection, IsString],
function(words, string)
  return ReduceListOfWordsByNielsen(words, InverseLessThanForLetters);
end);

InstallOtherMethod(ReduceListOfWordsByNielsenBack, [IsAssocWordCollection, IsString],
function(words, string)
  return ReduceListOfWordsByNielsen(words, InverseLessThanForLetters);
end);


#############################################################################
##
#M  ReduceListOfWordsByNielsen(<words_list>, <lt>)
##
InstallOtherMethod(ReduceListOfWordsByNielsen, [IsAssocWordCollection,
                                                  IsFunction],
function(words_list, lt)
  local result, transform, did_something, n, i, j, try_again, tmp;

  n := Length(words_list);
  result := ShallowCopy(words_list);
  transform := ShallowCopy(FreeGeneratorsOfFpGroup(FreeGroup(n)));
  did_something := false;
  try_again := true;

  for i in [1..n] do
    if not IsAssocWord(result[i]) then
      Print("error in ReduceListOfWordsByNielsen(IsAssocWordCollection, IsFunction):\n");
      Print("  ", i, "-th element of list is not an associative word\n");
      return fail;
    fi;
  od;

  while try_again do
    try_again := false;

    for i in [1..n] do
    for j in [1..n] do

      if i = j then
        if lt(result[i]^-1, result[i]) then
          result[i] := result[i]^-1;
          transform[i] := transform[i]^-1;
          did_something := true;
          try_again := true;
        fi;
        continue;
      fi;

      if i > j and lt(result[i], result[j]) then
        tmp := result[i];
        result[i] := result[j];
        result[j] := tmp;
        tmp := transform[i];
        transform[i] := transform[j];
        transform[j] := tmp;
        did_something := true;
        try_again := true;
      fi;

      if lt(result[i]*result[j], result[i]) then
        result[i] := result[i]*result[j];
        transform[i] := transform[i]*transform[j];
        did_something := true;
        try_again := true;
      fi;
      if lt(result[i]*result[j], result[j]) then
        result[j] := result[i]*result[j];
        transform[j] := transform[i]*transform[j];
        did_something := true;
        try_again := true;
      fi;

      if lt(result[i]^-1*result[j], result[i]) then
        result[i] := result[i]^-1*result[j];
        transform[i] := transform[i]^-1*transform[j];
        did_something := true;
        try_again := true;
      fi;
      if lt(result[i]^-1*result[j], result[j]) then
        result[j] := result[i]^-1*result[j];
        transform[j] := transform[i]^-1*transform[j];
        did_something := true;
        try_again := true;
      fi;

      if lt(result[i]*result[j]^-1, result[i]) then
        result[i] := result[i]*result[j]^-1;
        transform[i] := transform[i]*transform[j]^-1;
        did_something := true;
        try_again := true;
      fi;
      if lt(result[i]*result[j]^-1, result[j]) then
        result[j] := result[i]*result[j]^-1;
        transform[j] := transform[i]*transform[j]^-1;
        did_something := true;
        try_again := true;
      fi;

      if lt(result[i]^-1*result[j]^-1, result[i]) then
        result[i] := result[i]^-1*result[j]^-1;
        transform[i] := transform[i]^-1*transform[j]^-1;
        did_something := true;
        try_again := true;
      fi;
      if lt(result[i]^-1*result[j]^-1, result[j]) then
        result[j] := result[i]^-1*result[j]^-1;
        transform[j] := transform[i]^-1*transform[j]^-1;
        did_something := true;
        try_again := true;
      fi;
    od;
    od;
  od;

  return [result, transform, did_something];
end);


#############################################################################
##
#M  ReduceListOfWordsByNielsenBack(<words_list>, <lt>)
##
InstallOtherMethod(ReduceListOfWordsByNielsenBack, [IsAssocWordCollection,
                                                      IsFunction],
function(words_list, lt)
  local result, transform, did_something, n, i, j, try_again, tmp;

  n := Length(words_list);
  result := ShallowCopy(words_list);
  transform := ShallowCopy(FreeGeneratorsOfFpGroup(FreeGroup(n)));
  did_something := false;
  try_again := true;

  for i in [1..n] do
    if not IsAssocWord(result[i]) then
      Print("error in ReduceListOfWordsByNielsenBack(IsAssocWordCollection, IsFunction):\n");
      Print("  ", i, "-th element of list is not an associative word\n");
      return fail;
    fi;
  od;

  while try_again do
    try_again := false;

    for i in [1..n] do
    for j in [1..n] do

      if i = j then
        if lt(result[i]^-1, result[i]) then
          result[i] := result[i]^-1;
          transform[i] := transform[i]^-1;
          did_something := true;
          try_again := true;
        fi;
        continue;
      fi;

      if i > j and lt(result[i], result[j]) then
        tmp := result[i];
        result[i] := result[j];
        result[j] := tmp;
        tmp := transform[i];
        transform[i] := transform[j];
        transform[j] := tmp;
        did_something := true;
        try_again := true;
      fi;

      if lt(result[i]^-1*result[j]^-1, result[j]) then
        result[j] := result[i]^-1*result[j]^-1;
        transform[j] := transform[i]^-1*transform[j]^-1;
        did_something := true;
        try_again := true;
      fi;
      if lt(result[i]^-1*result[j]^-1, result[i]) then
        result[i] := result[i]^-1*result[j]^-1;
        transform[i] := transform[i]^-1*transform[j]^-1;
        did_something := true;
        try_again := true;
      fi;

      if lt(result[i]*result[j]^-1, result[j]) then
        result[j] := result[i]*result[j]^-1;
        transform[j] := transform[i]*transform[j]^-1;
        did_something := true;
        try_again := true;
      fi;
      if lt(result[i]*result[j]^-1, result[i]) then
        result[i] := result[i]*result[j]^-1;
        transform[i] := transform[i]*transform[j]^-1;
        did_something := true;
        try_again := true;
      fi;

      if lt(result[i]^-1*result[j], result[i]) then
        result[i] := result[i]^-1*result[j];
        transform[i] := transform[i]^-1*transform[j];
        did_something := true;
        try_again := true;
      fi;
      if lt(result[i]^-1*result[j], result[j]) then
        result[j] := result[i]^-1*result[j];
        transform[j] := transform[i]^-1*transform[j];
        did_something := true;
        try_again := true;
      fi;

      if lt(result[i]*result[j], result[j]) then
        result[j] := result[i]*result[j];
        transform[j] := transform[i]*transform[j];
        did_something := true;
        try_again := true;
      fi;
      if lt(result[i]*result[j], result[i]) then
        result[i] := result[i]*result[j];
        transform[i] := transform[i]*transform[j];
        did_something := true;
        try_again := true;
      fi;

    od;
    od;

  od;

  return [result, transform, did_something];
end);


#############################################################################
##
#F  ComputeMihaylovSystemPairs(<pairs_list>)
##
InstallGlobalFunction(ComputeMihaylovSystemPairs,
function(pairs)
  local result, i, nie, m, n, w, tmp,
        did_smth, npairs, transform,
        generate_full_group, nielsen_mihaylov, nielsen_low, rank,
        number_of_letters;

  if not IsDenseList(pairs) then
    Print("error in ComputeMihaylovSystemPairs:  \n");
    Print("  argument is not an IsDenseList\n");
    return fail;
  fi;
  if not IsList(pairs[1]) then
    Print("error in ComputeMihaylovSystemPairs:  \n");
    Print("  first element of list is not an IsList\n");
    return fail;
  fi;
  if Length(pairs[1]) <> 2 then
    Print("error in ComputeMihaylovSystemPairs:  \n");
    Print("  can work only with pairs\n");
    return fail;
  fi;
  if not IsAssocWord(pairs[1][1]) then
    Print("error in ComputeMihaylovSystemPairs:  \n");
    Print("  <arg>[1][1] is not IsAssocWord\n");
    return fail;
  fi;


  #############################################################################
  ##
  ##  generate_full_group
  ##
  generate_full_group := function(list, rank)
    local nie, i;
    nie := ReduceListOfWordsByNielsen(list)[1];
    if Length(Difference(nie, [One(nie[1])])) <> rank then
      return false;
    fi;
    for i in [1..Length(nie)] do
      if Length(nie[i]) > 1 then return false; fi;
    od;
    return true;
  end;


  #############################################################################
  ##
  ##  rank
  ##
  rank := function(words)
    return Length(Difference(ReduceListOfWordsByNielsen(words)[1],
                              [One(words[1])]));
  end;


  #############################################################################
  ##
  ##  number_of_letters
  ##
  number_of_letters := function(list)
    local letters, i, j;
    letters := [];
    for i in [1..Length(list)] do
      for j in [1..NumberSyllables(list[i])] do
        AddSet(letters, GeneratorSyllable(list[i], j));
      od;
    od;
    return Length(letters);
  end;


  #############################################################################
  ##
  ##  nielsen_mihaylov
  ##
  nielsen_mihaylov := function(words_list, m, n)
    local result, transform, did_something, try_again, nie, i, j, tf, pair,
          good_tf, good_pair, tmp;

    result := StructuralCopy(words_list);
    transform := ShallowCopy(FreeGeneratorsOfFpGroup(FreeGroup(m+n)));
    did_something := false;
    try_again := true;

    while try_again do
      try_again := false;

      nie := nielsen_low(result, m, n, \<);
      if nie[3] then
        did_something := true;
        try_again := true;
        result := nie[1];
        transform := CalculateWords(nie[2], transform);
      fi;

      nie := ReduceListOfWordsByNielsen(result{[m+1..m+n]});
      if nie[3] then
        did_something := true;
        try_again := true;
        result := Concatenation(result{[1..m]}, nie[1]);
        transform := Concatenation( transform{[1..m]},
                                    CalculateWords(nie[2],
                                    transform{[m+1..m+n]}));
      fi;

      if rank(result{[m+1..m+n]}) = n then
        if List(result{[m+1..m+n]}, w -> Length(w)) = List([1..n], i -> 1) then
          ## ok
          try_again := false;
        else
          ##  try to minimize sum of lengths
          good_pair := false;
          for pair in ListX([m+1..m+n], [1..m], function(i,j) return [i,j]; end) do
            good_tf := false;
            for tf in [  [1,1,2,1],[2,1,1,1],[1,-1,2,1],[2,-1,1,1],
                        [1,1,2,-1],[2,1,1,-1],[1,-1,2,-1],[2,-1,1,-1]  ] do
              tmp := StructuralCopy(result);
              tmp[pair[1]] := tmp[pair[tf[1]]]^tf[2] * tmp[pair[tf[3]]]^tf[4];
              if  rank(tmp{[m+1..m+n]}) = n and
                  number_of_letters(tmp{[m+1..m+n]}) =
                    number_of_letters(result{[m+1..m+n]}) and
                  Sum(List(tmp{[m+1..m+n]}, w -> Length(w))) <
                    Sum(List(result{[m+1..m+n]}, w -> Length(w)))
              then
                good_tf := true;
                break;
              fi;
            od;
            if good_tf then
              good_pair := true;
              break;
            fi;
          od;
          if not good_pair then
            ##  give up
            return [result, transform, did_something];
          else
            result[pair[1]] :=  result[pair[tf[1]]]^tf[2] *
                                result[pair[tf[3]]]^tf[4];
            transform[pair[1]] := transform[pair[tf[1]]]^tf[2] *
                                  transform[pair[tf[3]]]^tf[4];
            try_again := true;
            did_something := true;
          fi;
        fi;
      else
        ##  try to make rank bigger
        for i in [1..m] do
          good_tf := false;
          pair := [m+1, i];
          for tf in [  [1,1,2,1],[2,1,1,1],[1,-1,2,1],[2,-1,1,1],
                      [1,1,2,-1],[2,1,1,-1],[1,-1,2,-1],[2,-1,1,-1]  ] do
            tmp := StructuralCopy(result);
            tmp[pair[1]] := tmp[pair[tf[1]]]^tf[2] * tmp[pair[tf[3]]]^tf[4];
            if   rank(tmp{[m+1..m+n]}) > rank(result{[m+1..m+n]}) and
                number_of_letters(tmp{[m+1..m+n]}) >=
                  number_of_letters(result{[m+1..m+n]})
            then
              good_tf := true;
              break;
            fi;
          od;
          if good_tf then
            good_pair := true;
            break;
          fi;
        od;
        if not good_pair then
          ##  give up
          return [result, transform, did_something];
        else
          result[pair[1]] :=  result[pair[tf[1]]]^tf[2] *
                              result[pair[tf[3]]]^tf[4];
          transform[pair[1]] := transform[pair[tf[1]]]^tf[2] *
                                transform[pair[tf[3]]]^tf[4];
          try_again := true;
          did_something := true;
        fi;
      fi;

    od;

    return [result, transform, did_something];
  end;


  #############################################################################
  ##
  ##  nielsen_low
  ##
  nielsen_low := function(words_list, m, n, lt)
    local result, transform, did_something, i, j, try_again, tmp, nie;

    result := ShallowCopy(words_list);
    transform := ShallowCopy(FreeGeneratorsOfFpGroup(FreeGroup(m+n)));
    did_something := false;
    try_again := true;

    while try_again do
      try_again := false;

      nie := Nielsen(result{[1..m]});
      if nie[3] then
        result := Concatenation(CalculateWords(nie[2], result{[1..m]}),
                                result{[m+1..m+n]});
        transform := Concatenation( CalculateWords(nie[2], transform{[1..m]}),
                                    transform{[m+1..m+n]} );
        did_something := true;
        try_again := true;
      fi;

      for i in [1..m] do
        for j in [m+1..m+n] do
          if lt(result[i]^result[j], result[i]) then
            result[i] := result[i]^result[j];
            transform[i] := transform[i]^transform[j];
            did_something := true;
            try_again := true;
          fi;
          if lt(result[i]^(result[j]^-1), result[i]) then
            result[i] := result[i]^(result[j]^-1);
            transform[i] := transform[i]^(transform[j]^-1);
            did_something := true;
            try_again := true;
          fi;
          if lt((result[i]^-1)^result[j], result[i]) then
            result[i] := (result[i]^-1)^result[j];
            transform[i] := (transform[i]^-1)^transform[j];
            did_something := true;
            try_again := true;
          fi;
          if lt((result[i]^-1)^(result[j]^-1), result[i]) then
            result[i] := (result[i]^-1)^(result[j]^-1);
            transform[i] := (transform[i]^-1)^(transform[j]^-1);
            did_something := true;
            try_again := true;
          fi;
        od;
      od;
    od;

    return [result, transform, did_something];
  end;

  #############################################################################
  ##
  ##  MihaylovSystem body
  ##
  n := Length(FreeGeneratorsOfWholeGroup(Group(pairs[1][1])));
  m := Length(pairs) - n;
  npairs := StructuralCopy(pairs);
  transform := StructuralCopy(FreeGeneratorsOfFpGroup(FreeGroup(n+m)));
  did_smth := false;
  if not generate_full_group(List(pairs, p -> p[1]), n)
      or not generate_full_group(List(pairs, p -> p[2]), n)
  then
    Print("error in ComputeMihaylovSystemPairs:  \n");
    Print("  projections do not generate full free group\n");
    return fail;
  fi;

  ##  if rank equals number of pairs then just make one coordinate nicer
  if m = 0 then
    nie := ReduceListOfWordsByNielsen(List(npairs, p -> p[1]), "r");
    if nie[3] then
      tmp := List(npairs, p -> []);
      for i in [1..m+n] do
        tmp[i][1] := CalculateWord(nie[2][i], List(npairs, p -> p[1]));
        tmp[i][2] := CalculateWord(nie[2][i], List(npairs, p -> p[2]));
      od;
      npairs := StructuralCopy(tmp);
      transform := StructuralCopy(nie[2]);
      did_smth := true;
    fi;
    return [npairs, transform, did_smth];
  fi;

  ##  else try to do as much as possible

  ##  1. Apply Nielsen to first coordinate
  nie := ReduceListOfWordsByNielsen(List(npairs, p -> p[1]), "r");
  if nie[3] then
    tmp := StructuralCopy(npairs);
    for i in [1..m+n] do
      tmp[i][1] := CalculateWord(nie[2][i], List(npairs, p -> p[1]));
      tmp[i][2] := CalculateWord(nie[2][i], List(npairs, p -> p[2]));
    od;
    npairs := StructuralCopy(tmp);
    transform := StructuralCopy(nie[2]);
    did_smth := true;
  fi;

  ##  2. Now apply nielsen_mihaylov to the second coordinate
  nie := nielsen_mihaylov(List(npairs, p -> p[2]), m, n);
  if nie[3] then
    tmp := StructuralCopy(npairs);
    for i in [1..m+n] do
      tmp[i][1] := CalculateWord(nie[2][i], List(npairs, p -> p[1]));
      tmp[i][2] := CalculateWord(nie[2][i], List(npairs, p -> p[2]));
    od;
    npairs := StructuralCopy(tmp);
    tmp := StructuralCopy(transform);
    for i in [1..m+n] do
      tmp[i] := CalculateWord(nie[2][i], transform);
    od;
    transform := StructuralCopy(tmp);
    did_smth := true;
  fi;

  ##  3. Try to get nice generators on first coordinate
  nie := ReduceListOfWordsByNielsenBack(List(npairs{[m+1..m+n]}, p -> p[1]), "r");
  if nie[3] then
    tmp := StructuralCopy(npairs);
    for i in [1..n] do
      tmp[m+i][1] := CalculateWord(nie[2][i], List(npairs{[m+1..m+n]}, p -> p[1]));
      tmp[m+i][2] := CalculateWord(nie[2][i], List(npairs{[m+1..m+n]}, p -> p[2]));
    od;
    npairs := StructuralCopy(tmp);
    tmp := StructuralCopy(transform);
    for i in [1..n] do
      tmp[m+i] := CalculateWord(nie[2][i], transform{[m+1..m+n]});
    od;
    transform := StructuralCopy(tmp);
    did_smth := true;
  fi;

  return [npairs, transform, did_smth];
end);



#E
