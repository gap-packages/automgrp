#############################################################################
##
#W  utilsfrgrp.gi              automgrp package                Yevgen Muntyan
##                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
##  AG_InverseLessThanForLetters(<w1>, <w2>)
##
##  Compares w1 and w2 according to lexicografic ordering given by
##  x1 < x1^-1 < x2 < x2^-1 < ...
##
BindGlobal("AG_InverseLessThanForLetters",
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
##  AG_ReducedListOfWordsByNielsen(<words_list>)
##  AG_ReducedListOfWordsByNielsenBack(<words_list>)
##  AG_ReducedListOfWordsByNielsen(<words_list>, <string>)
##  AG_ReducedListOfWordsByNielsenBack(<words_list>, <string>)
##
InstallMethod(AG_ReducedListOfWordsByNielsen, [IsAssocWordCollection],
function(words)
  return AG_ReducedListOfWordsByNielsen(words, \<);
end);

InstallMethod(AG_ReducedListOfWordsByNielsenBack, [IsAssocWordCollection],
function(words)
  return AG_ReducedListOfWordsByNielsen(words, \<);
end);

InstallMethod(AG_ReducedListOfWordsByNielsen, [IsAssocWordCollection, IsString],
function(words, string)
  return AG_ReducedListOfWordsByNielsen(words, AG_InverseLessThanForLetters);
end);

InstallMethod(AG_ReducedListOfWordsByNielsenBack, [IsAssocWordCollection, IsString],
function(words, string)
  return AG_ReducedListOfWordsByNielsen(words, AG_InverseLessThanForLetters);
end);


#############################################################################
##
#M  AG_ReducedListOfWordsByNielsen(<words_list>, <lt>)
##
InstallMethod( AG_ReducedListOfWordsByNielsen,
                    [IsAssocWordCollection, IsFunction],
function(words_list, lt)
  local result, transform, did_something, n, i, j, try_again, tmp;

  n := Length(words_list);
  result := ShallowCopy(words_list);
  transform := ShallowCopy(FreeGeneratorsOfFpGroup(FreeGroup(n)));
  did_something := false;
  try_again := true;

  for i in [1..n] do
    if not IsAssocWord(result[i]) then
      Print("error in AG_ReducedListOfWordsByNielsen(IsAssocWordCollection, IsFunction):\n");
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
#M  AG_ReducedListOfWordsByNielsenBack(<words_list>, <lt>)
##
InstallMethod(AG_ReducedListOfWordsByNielsenBack,
                   [IsAssocWordCollection, IsFunction],
function(words_list, lt)
  local result, transform, did_something, n, i, j, try_again, tmp;

  n := Length(words_list);
  result := ShallowCopy(words_list);
  transform := ShallowCopy(FreeGeneratorsOfFpGroup(FreeGroup(n)));
  did_something := false;
  try_again := true;

  for i in [1..n] do
    if not IsAssocWord(result[i]) then
      Print("error in AG_ReducedListOfWordsByNielsenBack(IsAssocWordCollection, IsFunction):\n");
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
##  AG_ComputeMihailovaSystemPairs(<pairs_list>)
##
InstallGlobalFunction(AG_ComputeMihailovaSystemPairs,
function(pairs)
  local result, i, nie, m, n, w, tmp,
        did_smth, npairs, transform,
        generate_full_group, nielsen_mihaylov, nielsen_low, rank,
        number_of_letters;

  if not IsDenseList(pairs) then
    Print("error in AG_ComputeMihailovaSystemPairs:  \n");
    Print("  argument is not an IsDenseList\n");
    return fail;
  fi;
  if not IsList(pairs[1]) then
    Print("error in AG_ComputeMihailovaSystemPairs:  \n");
    Print("  first element of list is not an IsList\n");
    return fail;
  fi;
  if Length(pairs[1]) <> 2 then
    Print("error in AG_ComputeMihailovaSystemPairs:  \n");
    Print("  can work only with pairs\n");
    return fail;
  fi;
  if not IsAssocWord(pairs[1][1]) then
    Print("error in AG_ComputeMihailovaSystemPairs:  \n");
    Print("  <arg>[1][1] is not IsAssocWord\n");
    return fail;
  fi;


  #############################################################################
  ##
  ##  generate_full_group
  ##
  generate_full_group := function(list, rank)
    local nie, i;
    nie := AG_ReducedListOfWordsByNielsen(list)[1];
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
    return Length(Difference(AG_ReducedListOfWordsByNielsen(words)[1],
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
        transform := AG_CalculateWords(nie[2], transform);
      fi;

      nie := AG_ReducedListOfWordsByNielsen(result{[m+1..m+n]});
      if nie[3] then
        did_something := true;
        try_again := true;
        result := Concatenation(result{[1..m]}, nie[1]);
        transform := Concatenation( transform{[1..m]},
                                    AG_CalculateWords(nie[2],
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

      nie := AG_ReducedListOfWordsByNielsen(result{[1..m]});
      if nie[3] then
        result := Concatenation(AG_CalculateWords(nie[2], result{[1..m]}),
                                result{[m+1..m+n]});
        transform := Concatenation( AG_CalculateWords(nie[2], transform{[1..m]}),
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
  ##  MihailovaSystem body
  ##
  n := Length(FreeGeneratorsOfWholeGroup(Group(pairs[1][1])));
  m := Length(pairs) - n;
  npairs := StructuralCopy(pairs);
  transform := StructuralCopy(FreeGeneratorsOfFpGroup(FreeGroup(n+m)));
  did_smth := false;
  if not generate_full_group(List(pairs, p -> p[1]), n)
      or not generate_full_group(List(pairs, p -> p[2]), n)
  then
    Print("error in AG_ComputeMihailovaSystemPairs:  \n");
    Print("  projections do not generate full free group\n");
    return fail;
  fi;

  ##  if rank equals number of pairs then just make one coordinate nicer
  if m = 0 then
    nie := AG_ReducedListOfWordsByNielsen(List(npairs, p -> p[1]), "r");
    if nie[3] then
      tmp := List(npairs, p -> []);
      for i in [1..m+n] do
        tmp[i][1] := AG_CalculateWord(nie[2][i], List(npairs, p -> p[1]));
        tmp[i][2] := AG_CalculateWord(nie[2][i], List(npairs, p -> p[2]));
      od;
      npairs := StructuralCopy(tmp);
      transform := StructuralCopy(nie[2]);
      did_smth := true;
    fi;
    return [npairs, transform, did_smth];
  fi;

  ##  else try to do as much as possible

  ##  1. Apply Nielsen to first coordinate
  nie := AG_ReducedListOfWordsByNielsen(List(npairs, p -> p[1]), "r");
  if nie[3] then
    tmp := StructuralCopy(npairs);
    for i in [1..m+n] do
      tmp[i][1] := AG_CalculateWord(nie[2][i], List(npairs, p -> p[1]));
      tmp[i][2] := AG_CalculateWord(nie[2][i], List(npairs, p -> p[2]));
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
      tmp[i][1] := AG_CalculateWord(nie[2][i], List(npairs, p -> p[1]));
      tmp[i][2] := AG_CalculateWord(nie[2][i], List(npairs, p -> p[2]));
    od;
    npairs := StructuralCopy(tmp);
    tmp := StructuralCopy(transform);
    for i in [1..m+n] do
      tmp[i] := AG_CalculateWord(nie[2][i], transform);
    od;
    transform := StructuralCopy(tmp);
    did_smth := true;
  fi;

  ##  3. Try to get nice generators on first coordinate
  nie := AG_ReducedListOfWordsByNielsenBack(List(npairs{[m+1..m+n]}, p -> p[1]), "r");
  if nie[3] then
    tmp := StructuralCopy(npairs);
    for i in [1..n] do
      tmp[m+i][1] := AG_CalculateWord(nie[2][i], List(npairs{[m+1..m+n]}, p -> p[1]));
      tmp[m+i][2] := AG_CalculateWord(nie[2][i], List(npairs{[m+1..m+n]}, p -> p[2]));
    od;
    npairs := StructuralCopy(tmp);
    tmp := StructuralCopy(transform);
    for i in [1..n] do
      tmp[m+i] := AG_CalculateWord(nie[2][i], transform{[m+1..m+n]});
    od;
    transform := StructuralCopy(tmp);
    did_smth := true;
  fi;

  return [npairs, transform, did_smth];
end);


#############################################################################
##
#M  AG_ReducedByNielsen(<words_list>)
##
InstallMethod(AG_ReducedByNielsen,
              "for [IsList and IsAssocWordCollection]",
              [IsList and IsAssocWordCollection],
function(words)
  if AG_Globals.use_inv_order_in_apply_nielsen then
    return AG_ReducedListOfWordsByNielsen(words, "back")[1];
  else
    return AG_ReducedListOfWordsByNielsen(words)[1];
  fi;
end);


#############################################################################
##
#M  AG_ReducedByNielsen(<autom_list>)
##
InstallMethod(AG_ReducedByNielsen,
              "for [IsList and IsAutomCollection]",
              [IsList and IsAutomCollection],
function(automs)
  local words;
  if IsEmpty(automs) then
    return [];
  fi;
  words := AG_ReducedByNielsen(List(automs, a -> a!.word));
  return List(words, w -> Autom(w, automs[1]));
end);


#E
