#############################################################################
##
#W  utils.gi                   automata package                Yevgen Muntyan
##                                                              Dmytro Sachuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2006 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#M  CalculateWord(<word>, <list>)
##
InstallMethod(CalculateWord, [IsAssocWord, IsList],
function(w, dom)
    local result, i;

    result := One(dom[1]);

    for i in [1..NumberSyllables(w)] do
        result := result *
                    dom[GeneratorSyllable(w, i)]^ExponentSyllable(w, i);
    od;

    return result;
end);


#############################################################################
##
#M  CalculateWords(<words_list>, <list>)
##
InstallMethod(CalculateWords, [IsList, IsList],
function(words, domain)
    local result, i;

    result := [];
    for i in [1..Length(words)] do
        result[i] := CalculateWord(words[i], domain);
    od;

    return result;
end);


###############################################################################
##
#F  ReducedSphericalIndex(<ind>)
##
InstallGlobalFunction("ReducedSphericalIndex",
function(M)
  local beg, per, beg_len, per_len, i;
  if IsEmpty(M.period) then return StructuralCopy(M); fi;
  beg := StructuralCopy(M.start);
  per := StructuralCopy(M.period);
  beg_len := Length(beg);
  per_len := Length(per);
  for i in Difference(DivisorsInt(per_len), [per_len]) do
    if per = Concatenation(List([1..per_len/i], j -> per{[1..i]})) then
      per := per{[1..i]};
      per_len := i;
      break;
    fi;
  od;
  while Length(beg) <> 0 and beg[beg_len] = per[per_len] do
    per := Concatenation([per[per_len]], per{[1..per_len-1]});
    beg := beg{[1..beg_len-1]};
    beg_len := beg_len - 1;
  od;
  return rec(start := beg, period := per);
end);


###############################################################################
##
#F  IsEqualSphericalIndex(<ind1>, <ind2>)
##
InstallGlobalFunction("IsEqualSphericalIndex",
function(M1, M2)
  return ReducedSphericalIndex(M1) = ReducedSphericalIndex(M2);
end);


###############################################################################
##
#F  TopDegreeInSphericalIndex(<ind>)
##
InstallGlobalFunction("TopDegreeInSphericalIndex",
function(M)
  if not IsEmpty(M.start) then return M.start[1];
  else return M.period[1]; fi;
end);


###############################################################################
##
#F  DegreeOfLevelInSphericalIndex(<ind>)
##
InstallGlobalFunction("DegreeOfLevelInSphericalIndex",
function(M, k)
  local i;
  if Length(M.start) >= k then return M.start[k]; fi;
  i := RemInt(k-Length(M.start), Length(M.period));
  if i = 0 then i := Length(M.period); fi;
  return M.period[i];
end);


###############################################################################
##
#F  TreeLevelTuples(<ind>)
#F  TreeLevelTuples(<ind>, <n>)
#F  TreeLevelTuples(<start>, <period>, <n>)
##
InstallGlobalFunction("TreeLevelTuples",
function(arg)
  local n, m, args, ind, start, period;

  if Length(arg) = 1 and IsList(arg[1]) then
    ind := arg[1];
    n := Length(ind);
    args := List([1..n], i -> [1..ind[i]]);
    Add(args, function(arg) return arg; end);
    return CallFuncList(ListX, args);
  elif Length(arg) = 2 and IsRecord(arg[1]) and IsPosInt(arg[2]) then
    return TreeLevelTuples(arg[1].start, arg[1].period, arg[2]);
  elif Length(arg) = 3 and IsList(arg[1]) and IsList(arg[2]) and IsPosInt(arg[3]) then
    start := arg[1];
    period := arg[2];
    n := arg[3];
    m := n;
    ind := [];
    if Length(start) <> 0 then
      if n <= Length(start) then
        ind := start{[1..n]};
        m := 0;
      else
        ind := start;
        m := n - Length(start);
      fi;
    fi;
    if m > 0 then
      # TODO: why Append doesn't work???
#       Append(ind, Concatenation(List([1..Int(m/Length(period))], i -> period)));
#       Append(ind, period{[1..m-Int(m/Length(period))]});
      ind := Concatenation(ind,
        Concatenation(List([1..Int(m/Length(period))], i -> period)));
      ind := Concatenation(ind, period{[1..m-Int(m/Length(period))]});
    fi;
    args := List([1..n], i -> [1..ind[i]]);
    Add(args, function(arg) return arg; end);
    return CallFuncList(ListX, args);
  else
    Error("in TreeLevelTuples\n  usage: TreeLevelTuples([n_1, n_2, ..., n_k])\n         TreeLevelTuples(<spher_ind>, k)\n         TreeLevelTuples(start, period, k)\n");
  fi;
end);


###############################################################################
##
#F  ParseAutomatonString(<str>)
##
InstallGlobalFunction("ParseAutomatonString",
function(string)
    local parse_states, strstates, states, ids, nstates, need_trivial,
          alph, s, p, i, j, perm;

    parse_states := function (string)
        local strip, tokenize, isletter, isdigit, isspace, isseparator,
              aux, input, tokens, c, i, remove_punct, split, pointer,
              state, states, is_identifier, is_number, perm;

        isletter := function (c)
            return ('a' <= c and c < 'z') or
                ('A' <= c and c <= 'Z') or
                c = '_';
        end;

        isdigit := function (c)
            return '0' <= c and c < '9';
        end;

        isspace := function (c)
            return c = ' ' or c = '\n' or c = '\t';
        end;

        isseparator := function (c)
            return isspace (c) or
                c = ',' or c = ';';
        end;

        strip := function (string)
            local add, c, i, result;

            result := "";
            for c in string do
                if not isspace (c) then add := true;
                elif IsEmpty (result) then add := false;
                elif isseparator (result[Length (result)]) then add := false;
                else add := true;
                fi;

                if add then Add (result, c); fi;
            od;

            if IsEmpty (result) then return result; fi;
            i := Length (result) + 1;
            while isspace (result[i - 1]) do
                i := i - 1;
            od;
            result := result{[1..i-1]};
            if IsEmpty (result) then return result; fi;

            string := ShallowCopy (result);
            result := "";
            for i in [1..Length (string)] do
                if not isspace (string[i]) then add := true;
                elif IsEmpty (result) then add := false;
                elif isseparator (result[Length (result)]) then add := false;
                elif i < Length (string) and isseparator (string[i+1]) then add := false;
                else add := true;
                fi;

                if add then Add (result, string[i]); fi;
            od;

            return result;
        end;

        remove_punct := function (string)
            local result, c;
            result := "";
            for c in string do
                if isseparator (c) then
                    Add (result, ' ');
                else
                    Add (result, c);
                fi;
            od;
            return result;
        end;

        split := function (string)
            local result, s, i, len, split_braces;
            result := [];
            len := Length (string);

            if len = 0 then
                return result;
            fi;

            split_braces := function (string)
                local result, s, i, len;

                result := [];
                len := Length (string);
                i := 1;
                while i <= len do
                    s := "";
                    if string[i] = '(' then
                        s := "(";
                        i := i + 1;
                    elif string[i] = ')' then
                        s := ")";
                        i := i + 1;
                    else
                        while i <= len and string[i] <> '(' and string[i] <> ')' do
                            Add (s, string[i]);
                            i := i + 1;
                        od;
                    fi;
                    if Length (s) > 0 then
                        Add (result, s);
                    fi;
                od;

                return result;
            end;

            i := 1;
            while true do
                while i <= len and isspace (string[i]) do
                    i := i + 1;
                od;
                if i > len then break; fi;
                s := "";
                while i <= len and not isspace (string[i]) do
                    Add (s, string[i]);
                    i := i + 1;
                od;
                if Length (s) > 0 then
                    Append (result, split_braces (s));
                else
                    break;
                fi;
            od;

            return result;
        end;

        is_identifier := function (string)
            local c;
            if IsEmpty (string) then return false; fi;
            if not isletter (string[1]) then return false; fi;
            for c in string do
                if not isletter (c) and not isdigit (c) then
                    return false;
                fi;
            od;
            return true;
        end;

        is_number := function (string)
            local c;
            if IsEmpty (string) then return false; fi;
            for c in string do
                if not isdigit (c) then
                    return false;
                fi;
            od;
            return true;
        end;

        string := remove_punct (string);
        string := strip (string);
        tokens := split (string);

        pointer := 1;
        states := [];

        while pointer <= Length (tokens) do
            state := [];
            Add (states, state);

            if not is_identifier (tokens[pointer]) then
                Error ("expected identifier, got ", tokens[pointer]);
            else
                Add (state, tokens[pointer]);
                Add (state, []);
                pointer := pointer + 1;
            fi;

            if pointer > Length (tokens) then break; fi;
            if tokens[pointer] <> "=" then
                Error ("expected '=', got ", tokens[pointer]);
            else
                pointer := pointer + 1;
            fi;
            if tokens[pointer] <> "(" then
                Error ("expected '(', got ", tokens[pointer]);
            else
                pointer := pointer + 1;
            fi;

            while pointer <= Length (tokens) do
                if is_identifier (tokens[pointer]) or tokens[pointer] = "1" then
                    Add (state[2], tokens[pointer]);
                elif tokens[pointer] = ")" then
                    pointer := pointer + 1;
                    break;
                else
                    Error ("expected state identifier or ')', got ", tokens[pointer]);
                fi;
                pointer := pointer + 1;
            od;

            if pointer > Length (tokens) then break; fi;
            if tokens[pointer] = "(" then
                pointer := pointer + 1;
                perm := [];
                while pointer <= Length (tokens) do
                    if is_number (tokens[pointer]) then
                        Add (perm, tokens[pointer]);
                    elif tokens[pointer] = ")" then
                        pointer := pointer + 1;
                        break;
                    else
                        Error ("expected number or ')', got ", tokens[pointer]);
                    fi;
                    pointer := pointer + 1;
                od;
                Add (state, perm);
            fi;
        od;

        return states;
    end;

    strstates := parse_states (string);
    ids := List (strstates, i->i[1]);
    if Length (ids) <> Length (strstates) then
        Error ();
    fi;

    alph := Length (strstates[1][2]);
    if alph = 0 then
        Error ();
    fi;
    for s in strstates do
        if Length (s[2]) <> alph then
            Error ("number of states in ", s, "is different from the first state");
        fi;
    od;

    for s in strstates do
        if not IsBound (s[3]) then s[3] := (); fi;
        perm := s[3];
        if not IsPerm (perm) then
            if IsList (perm) and IsEmpty (perm) then
                perm := ();
            elif IsList (perm) then
                p := "(";
                for i in [1..Length(perm)] do
                    if i <> 1 then Append (p, ", "); fi;
                    Append (p, perm[i]);
                od;
                Append (p, ")");
                perm := EvalString (p);
            else
                Error ("could not parse permutation '", perm, "'");
            fi;
        fi;
        if not perm in SymmetricGroup (alph) then
            Error ("permutation ", perm, " is not in Sym(", alph, ")");
        fi;
        s[3] := perm;
    od;

    nstates := Length (ids);
    need_trivial := false;
    states := [];

    for i in [1..nstates] do
        states[i] := [];
        states[i][alph + 1] := strstates[i][3];
        for j in [1..alph] do
            s := strstates[i][2][j];
            if IsEmpty (s) or s = "1" or
               (s = "e" and not s in ids)
            then s := nstates + 1; need_trivial := true;
            elif s in ids then s := Position (ids, s);
            else Error ("unknown state '", s, "' in ", strstates[i]);
            fi;
            states[i][j] := s;
        od;
    od;

    if need_trivial then
        states[nstates + 1] := List([1..alph], i -> nstates + 1);
        states[nstates + 1][alph + 1] := ();
        ids[nstates + 1] := "";
    fi;

    return [ids, states];
end);


#E
