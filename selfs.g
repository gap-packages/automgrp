InstallOtherMethod(\^,"list^perm",true,[IsList,IsPerm],0,
function(l,p)
  local i,b;
  b:=[];
  for i in [1..Length(l)] do
    b[i^p]:=l[i];
  od;
  return b;
end);

GrigorchukGroup:=
[ [ [1,1,()],    [1,1,(1,2)], [4,2,()],    [5,2,()],    [3,1,()]     ],
  [ [1,1,(1,2)], [1,1,()],    [2,4,(1,2)], [2,5,(1,2)], [1,3,(1,2)], ],
  [ [4,2,()],    [4,2,(1,2)], [1,1,()],    [3,1,()],    [5,2,()],    ],
  [ [5,2,()],    [5,2,(1,2)], [3,1,()],    [1,1,()],    [4,2,()],    ],
  [ [3,1,()],    [3,1,(1,2)], [5,2,()],    [4,2,()],    [1,1,()]     ] ];

GG2:=[[[1,1,()], [1,1,(1,2)], [4,2,()], [5,2,()], [3,1,()],[4,2,(1,2)],[5,1,()]]];

GGAltered:=[[[1,1,()], [1,1,(1,2)], [4,2,(1,2)], [5,2,(1,2)], [3,1,(1,2)]]];

gr:=
[ [ [1,1,()],     [1,7,(1,2)], [7,1,(1,2)],  [2,4,()],     [10,5,()],
    [3,6,()],     [4,6,(1,2)], [5,11,(1,2)], [12,5,(1,2)], [7,7,()],
    [3,9,(1,2)],  [8,2,(1,2)] ] ];

gr2:=
[ [ [1,1,()], [1,4,(1,2)], [2,3,()], [3,5,(1,2)], [6,5,()], [4,1,(1,2)] ] ];

AddingMachine:=[ [ [1,1,()], [1,2,(1,2)] ] ];

mg1:=[ [ [1,1,()], [1,1,(1,2)], [2,3,(1,2)], [4,2,(1,2)] ] ];

g:=GrigorchukGroup;

a:=[[[1,2,()],[2,3,()],[1,2,()]]];

NC:=[[[1,1,()],[1,1,(1,2)],[3,2,()]]];

LL:=[[[1,1,()],[3,2,(1,2)],[3,2,()]]];

Bond:=[[[1,1,()],[1,1,(1,2)],[2,4,()],[1,5,()],[1,3,()]]];

Bond2:=[[[1,1,()],[1,3,(1,2)],[1,4,()],[1,5,()],[1,2,()]]];

Bond3:=[[ [1,1,1,()], [1,1,2,(1,2)], [1,3,1,(1,3)] ]];

Sush:=
[ [
[1,1,1,()],   [3,4,5,()],   [6,1,1,()],   [7,1,1,()],   [1,8,1,()],
[10,1,1,()],  [11,8,1,()],  [1,1,1,(1,2,3)],[1,1,1,(1,3,2)], [12,8,1,()],
[13,1,1,()],  [14,8,1,()],  [15,1,1,()],  [16,1,1,()],  [17,8,1,()],
[18,8,1,()],  [19,9,1,()],  [20,8,1,()],  [21,8,1,()],  [22,1,1,()],
[23,8,1,()],  [24,8,1,()],  [25,8,1,()],  [6,8,1,()],   [7,9,1,()],
[1,8,9,(1,2,3)]
] ];


MyAut1:=
[ [ [1,1,()],  [2,3,(1,2)],  [4,4,(1,2)],  [2,4,()] ] ];

MyAut2:=
[ [ [1,1,()],  [2,3,(1,2)],  [2,4,()],  [4,2,()] ] ];


OlGroup:=
[ [ [1,4,3,5,4,1,5,3,()],
    [2,8,7,6,8,2,6,7,()],
    [1,4,3,5,4,1,5,3,(1,7)(2,8)(3,5)(4,6)],
    [3,5,1,4,5,3,4,1,(1,2)(3,4)(5,6)(7,8)],
    [3,5,1,4,5,3,4,1,(1,8)(2,7)(3,6)(4,5)],
    [6,7,8,2,7,6,2,8,(1,5)(2,6)(3,7)(4,8)],
    [6,7,8,2,7,6,2,8,(1,3)(2,4)(5,7)(6,8)],
    [6,7,8,2,7,6,2,8,(1,7)(2,8)(3,5)(4,6)]
] ];


aut3:=
[ [ [1,1,()], [3,4,(1,2)], [4,4,()], [2,3,(1,2)] ] ];

################################################################################
##
#F ReduceWord . . . . . . . . . . . . . . . . . . . . . . .cuts 1s from the word
##
ReduceWord:=function(v)
  local i,b;
  b:=[];
  for i in [1..Length(v)] do
    if v[i]<>1 then
      Add(b,v[i]);
    fi;
  od;
  return b;
end;

################################################################################
##
#F IsOneWord . . . . . . . . . . . . . . . . . . . checks if the word is trivial
##
IsOneWord:=function(w,G)
  local i,b,l,v,c,k,res,t;
  if Length(w)=0 then return true; fi;
  if Length(w)=1 then
    if w=[1] then return true;
             else return false;
    fi;
  fi;
  if Length(w) mod 2=1 then Add(w,1); fi;
  l:=[];
  for i in [1..Length(w)/2] do
    Add(l,ShallowCopy(G[w[2*i-1]][w[2*i]]));
  od;
#  Print("l=",l);
  c:=[(),l[1][Length(l[1])]];
  t:=Length(l);
  for i in [2..t] do
#    Print("c[",i,"]=",c[i],",l[",i,"]=",l[i][Length(l[i])],";");
    Add(c,c[i]*l[i][Length(l[i])]);
    l[i][Length(l[i])]:=c[i];
  od;
  if c[Length(c)]<>() then
    return false;
  fi;
  l[1][Length(l[1])]:=();
  b:=[];
  for i in [1..Length(l)] do
    b[i]:=l[i]^l[i][Length(l[i])];
  od;
  i:=1;
  res:=true;
  while res and (i<=Length(b[1])-1) do
    v:=[];
    for k in [1..Length(b)] do
      Add(v,b[k][i]);
    od;
    v:=ReduceWord(v);
    res:=IsOneWord(v,G);
    i:=i+1;
  od;
  return res;
end;


################################################################################
##
#F OrderOfElement. . . . . . . . . . . . . . . . . .Finds the order of a periodic element
##

OrderOfElement:=function(v,G)
  local w,k;
  v:=ReduceWord(v);
  w:=ShallowCopy(v); k:=1;
  while not IsOneWord(w,G) do
    Append(w,v);
#   Print(w,";");
    k:=k+1;
  od;
  return k;
end;


################################################################################
##
#F GeneratorActionOnVertex. . . . . . . . . . . . . . . . Computes the action of
##                                             the generator on the fixed vertex

GeneratorActionOnVertex:=function(G,g,w)
  local i,v,gen,d;
  d:=Length(G[1][1])-1;
  gen:=g; v:=[];
  for i in [1..Length(w)] do
    Add(v,(w[i]+1)^G[1][gen][d+1]-1);
    gen:=G[1][gen][w[i]+1];
  od;
  return v;
end;


NumberOfWord:=function(w,d)
  local i,s;
  s:=0;
  for i in [1..Length(w)] do
    s:=s+w[i]*d^(Length(w)-i);
  od;
  return s;
end;

VertexNumber:=function(k,n,d)
  local i,l,l1,t;
  t:=k; l:=[];
  while t>0 do
    Add(l,t mod d);
    t:=(t-(t mod d))/d;
  od;
  for i in [Length(l)+1..n] do Add(l,0); od;
  l1:=[];
  for i in [1..n] do l1[i]:=l[n-i+1]; od;
  return l1;
end;


################################################################################
##
#F GeneratorActionOnLevel . . . . . . . . . . . . . . . . Computes the action of
##                                               the generator on the n-th level

GeneratorActionOnLevel:=function(G,g,n)
  local l,d,i,s,v,w,k;
  s:=(); d:=Length(G[1][1])-1;
  l:=[];
  for i in [1..d^n] do Add(l,0); od;
  i:=0;
  while i<d^n do
    k:=0;
    while l[k+1]>0 do
      k:=k+1;
    od;
    w:=VertexNumber(k,n,d);
    v:=ShallowCopy(w);
    i:=i+1;
    repeat
      l[NumberOfWord(v,d)+1]:=1;
      v:=GeneratorActionOnVertex(G,g,v);
      if v<>w then
        s:=s*(k+1,NumberOfWord(v,d)+1);
        i:=i+1;
      fi;
    until v=w;
  od;
  return s;
end;

################################################################################
##
#F NthFactor  . . . . . . . . . . . . . . . . . .Computes Factor group G/St_n(G)
##

NthFactor:=function(G,n)
  local  i,l;
  l:=[];
  for i in [1..Length(G[1])] do
    Add(l,GeneratorActionOnLevel(G,i,n));
  od;
  return Group(l);
end;

################################################################################
##
#F InvestigatePairs . . . . . . . . . . . . . . . . . . . Searches out relations
##                                               in the recurent group like ab=c

InvestigatePairs:=function(G)
  local i,j,k,i1,j1,k1,Pairs,Trip,n,IsPairEq,d,res,tmp;

  IsPairEq:=function(i,j,k)
    local t,res;
    if (not IsList(Pairs[i][j])) or (IsList(Pairs[i][j])
                                     and (Pairs[i][j][1]<>k)) then
      if (not IsList(Pairs[i][j])) and (Pairs[i][j]<>-1) then
    	if Pairs[i][j]=k then return true;
                         else return false;
        fi;
      fi;
      if IsList(Pairs[i][j]) then
        if Length(Pairs[i][j])=1 then
          Trip[i][j][Pairs[i][j][1]]:=0;
        else
          Trip[i1][j1][k1]:=0;
          return true;
        fi;
      fi;
      if Trip[i][j][k]=0 then return false;
      else
        if G[1][i][d+1]*G[1][j][d+1]<>G[1][k][d+1] then
          Trip[i][j][k]:=0;
          return false;
        fi;
        Pairs[i][j]:=[k];
        t:=1; res:=true;
        while res and (t<=d) do
#          Print("i=",i,",j=",j,",k=",k,",t=",t,";   ");
          res:=IsPairEq(G[1][i][t],G[1][j][t^G[1][i][d+1]],G[1][k][t]);
          t:=t+1;
        od;
        if res then
          if Trip[i][j][k]<>0 then
            Pairs[i][j]:=[k,1];
            return true;
          else
            Pairs[i][j]:=-1;
            return false;
          fi;
        else
          Trip[i][j][k]:=0;
          Pairs[i][j]:=-1;
          return false;
        fi;
      fi;
    else
      return true;
    fi;
  end;

  Pairs:=[[]]; Trip:=[];
  n:=Length(G[1]);
  d:=Length(G[1][1])-1;
  for j in [1..n] do Add(Pairs[1],j); od;
  for i in [2..n] do
    Add(Pairs,[i]);
    Trip[i]:=[];
    for j in [2..n] do
      Pairs[i][j]:=-1;
      Trip[i][j]:=[];
      for k in [1..n] do Trip[i][j][k]:=-1; od;
    od;
  od;
#  Print(Pairs);
#  Print(Trip);
  for i1 in [2..n] do for j1 in [2..n] do
    if Pairs[i1][j1]=-1 then
      k1:=1; res:=false;
      while (not res) and (k1<=n) do
        res:=IsPairEq(i1,j1,k1);
#        Print(Pairs,"\n");
        for i in [2..n] do for j in [2..n] do
          if IsList(Pairs[i][j]) then
            if res then Pairs[i][j]:=Pairs[i][j][1];
                   else Pairs[i][j]:=-1;
            fi;
          fi;
        od; od;
        k1:=k1+1;
      od;
      if Pairs[i1][j1]=-1 then Pairs[i1][j1]:=0; fi;
    fi;
  od; od;
#  i1:=a; j1:=b; k1:=c;
#  res:=IsPairEq(i1,j1,k1);
#  Print(Pairs);
#  return res;
  return Pairs;
end;

################################################################################
##
#F ContractingLevel . . . . . . . . . . . . . . . . . . Computes the level where
##                                              all pairs contract to the kernel

ContractingLevel:=function(G)
  local i,j,res,ContPairs,d,maxlev,n,Pairs,IsPairContracts;

  IsPairContracts:=function(i,j,lev)
    local t,res;
    if lev>maxlev then maxlev:=lev; fi;
    if (ContPairs[i][j]=1) then return true; fi;
    if Pairs[i][j]<>0 then
      ContPairs[i][j]:=1;
      return true;
    fi;
    if ContPairs[i][j]=2 then return false; fi;
    t:=1; res:=true;
    ContPairs[i][j]:=2;
    while res and (t<=d) do
      res:=IsPairContracts(G[1][i][t],G[1][j][t^G[1][i][d+1]],lev+1);
      t:=t+1;
    od;
    if res then
             ContPairs[i][j]:=1;
             return true;
           else return false;
    fi;
  end;

  res:=true; maxlev:=0; ContPairs:=[];
  Pairs:=InvestigatePairs(G);
  n:=Length(G[1]);
  for i in [1..n] do
    Add(ContPairs,[1]);
    for j in [1..n-1] do
      if i=1 then Add(ContPairs[i],1);
             else Add(ContPairs[i],-1);
      fi;
    od;
  od;
#  Print(ContPairs,"\n");
  i:=1;
  d:=Length(G[1][1])-1;
  while res and (i<=n) do
    j:=1;
    while res and (j<=n) do
      if ContPairs[i][j]=0 then return -1; fi;
      if ContPairs[i][j]=-1 then res:=IsPairContracts(i,j,0); fi;
      j:=j+1;
    od;
    i:=i+1;
  od;
#  Print(ContPairs);
  if res then return maxlev;
         else return -1;
  fi;
end;

################################################################################
##
#F ContractingTable . . . . . . . . . . . . . . . . . . Computes the contracting
##                                                           table of the kernel

ContractingTable:=function(G)
  local lev,n,d,i,j, ContractingPair, Pairs, ContTable;

  ContractingPair:=function(i,j)
    local l,k,t, PairAct, TmpList, g1, g2;
    if Pairs[i][j]<>0 then PairAct:=[Pairs[i][j]];
                      else PairAct:=[[i,j]];
    fi;
    for l in [1..lev] do
      TmpList:=[];
      for t in [1..Length(PairAct)] do
        if not IsList(PairAct[t]) then
          for k in [1..d] do Add(TmpList,G[1][PairAct[t]][k]); od;
        else
          for k in [1..d] do
            g1:=G[1][PairAct[t][1]][k];
            g2:=G[1][PairAct[t][2]][k^G[1][PairAct[t][1]][d+1]];
            if Pairs[g1][g2]<>0 then Add(TmpList,Pairs[g1][g2]);
                                else Add(TmpList,[g1,g2]);
            fi;
          od;
        fi;
      od;
      PairAct:=ShallowCopy(TmpList);
    od;
    Add(PairAct,GeneratorActionOnLevel(G,i,lev)*GeneratorActionOnLevel(G,j,lev));
    return PairAct;
  end;

  lev:=ContractingLevel(G);
  if lev=-1 then return false; fi;
  Pairs:=InvestigatePairs(G);
  n:=Length(G[1]);
  d:=Length(G[1][1])-1;
  ContTable:=[];
  for i in [1..n] do
    Add(ContTable,[]);
    for j in [1..n] do Add(ContTable[i],ContractingPair(i,j)); od;
  od;
  return ContTable;
end;

################################################################################
##
#F AddIvverses . . . . . . . . . .Adds to the generating set of the self-similar
##                		 group inverse elements and the identity element

AddInverses:=function(H)
  local Pairs,i,j,g,id,inv,n,eq,shift,tmpG,tmpPairs,d,tmp,already,G,isId,idEl;
  shift:=function(x,y,z)
    if x<y then return x;
      elif x=y then return z;
      else return x-1;
    fi;
  end;

  G:=ShallowCopy(H);
  id:=0; d:=Length(G[1][1])-1;
  idEl:=[];

  for i in [1..Length(G[1])] do
    isId:=true;
    if G[1][i][d+1]<>() then isId:=false;fi;
    j:=1;
    while isId and j<=d do
      if G[1][i][j]<>j then
	isId:=false;
      fi;
      j:=j+1;
    od;
    if isId then id:=i; fi;
  od;

  for i in [1..d] do Add(idEl,1); od;
  Add(idEl,());

  if id=0 then
    id:=Length(G[1])+1;
    Add(G[1],idEl);
  fi;
  if id<>1 then
    G[1][id]:=G[1][1]; G[1][1]:=idEl;
    for i in [2..Length(G[1])] do
      for j in [1..Length(G[1][i])-1] do
        if G[1][i][j]=1 or G[1][i][j]=id then G[1][i][j]:=id+1-G[1][i][j]; fi;
      od;
    od;
  fi;
  n:=Length(G[1]);
#  Print("n=",n,"\n");
  for i in [2..n] do
    inv:=[];
    for j in [1..Length(G[1][i])-1] do
      if G[1][i][j]<>1 then Add(inv,G[1][i][j]+n-1);
                       else Add(inv,1);
      fi;
    od;
    Add(inv,G[1][i][Length(G[1][i])]^-1);
    Add(G[1],inv^(G[1][i][Length(G[1][i])]^-1));
  od;
#  Print("G[1] before",G[1]);
  Pairs:=InvestigatePairs(G);
#  Print(Pairs);
  eq:=[];
  for i in [2..n-1] do
    already:=false;
    for g in eq do if i=g[1] then already:=true; fi; od;
    if not already then
      for j in [i+1..n] do
        if Pairs[i][j+n-1]=1 then Add(eq,[j,i]); Add(eq,[j+n-1,i+n-1]); fi;
      od;
    fi;
  od;
#  Print("a=b",eq,"\n");
  Sort(eq,function(v,w) return v[1]>w[1]; end);
  for g in eq do
    for i in [2..2*n-1] do
      for j in [1..d] do G[1][i][j]:=shift(G[1][i][j],g[1],g[2]); od;
#      for j in [2..2*n-1] do Pairs[i][j]:=shift(Pairs[i][j],g[1],g[2]); od;
    od;
  od;
  tmp:=[];
  for g in eq do Add(tmp,g[1]); od;
  eq:=tmp;
  tmpG:=[];
  tmpPairs:=[];
  for i in [1..2*n-1] do
    if not (i in eq) then
      Add(tmpG,G[1][i]);
      tmp:=[];
      for j in [1..2*n-1] do if not (j in eq) then Add(tmp,Pairs[i][j]); fi; od;
      Add(tmpPairs,tmp);
    fi;
  od;
  Pairs:=ShallowCopy(tmpPairs); G[1]:=ShallowCopy(tmpG);
  n:=n-Length(eq)/2;
#  Print("n_after=",n);
  eq:=[];
  for i in [2..n] do
    for j in [2..n] do
      if Pairs[i][j]=1 then Add(eq,[j+n-1,i]); fi;
    od;
  od;
#  Print("a=b^-1",eq,"\n");
  Sort(eq,function(v,w) return v[1]>w[1]; end);
  for g in eq do
    for i in [2..2*n-1] do
      for j in [1..d] do G[1][i][j]:=shift(G[1][i][j],g[1],g[2]); od;
#      for j in [2..2*n-1] do Pairs[i][j]:=shift(Pairs[i][j],g[1],g[2]); od;
    od;
  od;
  tmp:=[];
  for g in eq do Add(tmp,g[1]); od;
  eq:=tmp;
  tmpG:=[];
#  Print("G(1)ssss:",G[1]);
  for i in [1..2*n-1] do
    if not (i in eq) then
#      Print("1aaaa");
      Add(tmpG,G[1][i]);
    fi;
  od;
#  Print("tmpG",tmpG);
  G[1]:=ShallowCopy(tmpG);
  eq:=[];
  for i in [2..Length(G[1])] do
    if G[1][i]=[i,i,()] then Add(eq,i); fi;
  od;
  if eq<>[] then
    Sort(eq,function(v,w) return v>w; end);
    for g in eq do
      for i in [2..Length(G[1])] do
        for j in [1..d] do G[1][i][j]:=shift(G[1][i][j],g,1); od;
      od;
    od;
    tmpG:=[];
    for i in [1..Length(G[1])] do
      if not (i in eq) then
#        Print("2aaaa");
        Add(tmpG,G[1][i]);
      fi;
    od;
  fi;
  return [tmpG];
end;


################################################################################
##
#F Minimize. . . . . . . . . . . . . . . . . . . . . .Glues equivalent states of
##                                                          noninitial automaton

MinimizeAutom:=function(G)

  local AreEqualStates,i,j,Pairs,n, tmpG,d,k,l,st;

  AreEqualStates:=function(st1,st2)
    local eq,i;
    if st1=st2 or ([st1,st2] in Pairs) or ([st2,st1] in Pairs) then return true; fi;
    if G[1][st1][d+1]<>G[1][st2][d+1] then return false; fi;
    Add(Pairs, [st1,st2]);
    eq:=true;
    for i in [1..d] do
      if not AreEqualStates(G[1][st1][i],G[1][st2][i]) then eq:=false; break; fi;
    od;
    return eq;
  end;

  n:=Length(G[1]);
  d:=Length(G[1][1])-1;
  for i in [1..n-1] do
    for j in [i+1..n] do
      Pairs:=[];
      if AreEqualStates(i,j) then
        tmpG:=[];  #can be maid better by gluing all pairs from Pairs.
        for k in [1..n] do
          if k<>j then
            st:=ShallowCopy(G[1][k]);
            for l in [1..d] do
              if st[l]=j then st[l]:=i;
              elif st[l]>j then st[l]:=st[l]-1;
              fi;
            od;
            Add(tmpG,st);
          fi;
        od;
        return MinimizeAutom([tmpG]);
      fi;
    od;
  od;
  return G;
end;


################################################################################
##
#F FindNucleus. . . . . . . . . . . . . . . . . . . . .Tries to find the nucleus
##              		                       of the self-similar group

FindNucleus:=function(H)
  local G,Pairs,i,j,PairsToAdd,res,ContPairs,n,d,found,num,IsPairContracts,AddPairs,lev,maxlev,tmp,Nucl,IsElemInNucleus;

  IsPairContracts:=function(i,j,lev)
    local t,res;
    if lev>maxlev then maxlev:=lev; fi;
    if (ContPairs[i][j]=1) then return true; fi;
    if Pairs[i][j]<>0 then
      ContPairs[i][j]:=1;
      return true;
    fi;
    if ContPairs[i][j]=2 then return false; fi;
    t:=1; res:=true;
    ContPairs[i][j]:=2;
    while res and (t<=d) do
      res:=IsPairContracts(G[1][i][t],G[1][j][t^G[1][i][d+1]],lev+1);
      t:=t+1;
    od;
    if res then
             ContPairs[i][j]:=1;
             return true;
           else return false;
    fi;
  end;

  AddPairs:=function(i,j)
    local tmp,l,CurNum;
    if Pairs[i][j]>0 then return Pairs[i][j]; fi;
    Pairs[i][j]:=num;
    CurNum:=num;
    Add(PairsToAdd,[]);
    num:=num+1;
    tmp:=[];
    for l in [1..d] do
      Add(tmp,AddPairs(G[1][i][l],G[1][j][l^G[1][i][d+1]]));
    od;
    Add(tmp,G[1][i][d+1]*G[1][j][d+1]);
    Append(PairsToAdd[CurNum-n],tmp);
    return CurNum;
  end;

  IsElemInNucleus:=function(g)
    local i,res;
    if g in tmp then
      for i in [Position(tmp,g)..Length(tmp)] do
        if not (tmp[i] in Nucl) then Add(Nucl,tmp[i]); fi;
      od;
      return g=tmp[1];
    fi;
    Add(tmp,g);
    res:=false; i:=1;
    while (not res) and i<=d do
      res:=IsElemInNucleus(G[1][g][i]);
      i:=i+1;
    od;
    tmp:=tmp{[1..Length(tmp)-1]};
    return res;
  end;

  found:=false; G:=ShallowCopy(H);
  G:=AddInverses(G);
  while not found do
    res:=true; maxlev:=0; ContPairs:=[];
    Pairs:=InvestigatePairs(G);
    n:=Length(G[1]);
    Print("n=",n,"\n");
    for i in [1..n] do
      Add(ContPairs,[1]);
      for j in [1..n-1] do
        if i=1 then Add(ContPairs[i],1);
               else Add(ContPairs[i],-1);
        fi;
      od;
    od;
    i:=1;
    d:=Length(G[1][1])-1;
    while res and (i<=n) do
      j:=1;
      while res and (j<=n) do
        #Print("i=",i,",j=",j,"\n");
        if ContPairs[i][j]=-1 then res:=IsPairContracts(i,j,0); fi;
        if not res then
          PairsToAdd:=[];
          num:=n+1;
          AddPairs(i,j);
          Print("Pairs to Add:",PairsToAdd,"\n");
          Append(G[1],PairsToAdd);
          G:=AddInverses(G);
        fi;
        j:=j+1;
      od;
      i:=i+1;
    od;
    if res then
      found:=true;
    fi;
  od;
  Nucl:=[];
  for i in [1..Length(G[1])] do
    tmp:=[];
    if not (i in Nucl) then IsElemInNucleus(i); fi;
  od;
  for g in Nucl do
    for i in [1..d] do
      if not (G[1][g][i] in Nucl) then Add(Nucl,G[1][g][i]); fi;
    od;
  od;
  Print("Nucleus:",Nucl,"\n");
  return [G[1]];
end;



################################################################################
##
#F InverseTableContr. . . . . . . . . Gives permutation on the set of generators
##              		        which pushes each element to its inverse

InverseTableContr:=function(G)
  local i,j,viewed,inv,found;
  viewed:=[]; inv:=();
  for i in [1..Length(G[1])] do
    if not (i in viewed) then
      j:=1; found:=false;
      while j<=Length(G[1]) and not found do
        #Print("[",i,",",j,"]\n");
	if IsOneWord([i,j],G) then
          found:=true;
	  if i<>j then
	    inv:=inv*(i,j);
            Add(viewed,i);
	    Add(viewed,j);
	  else
	    Add(viewed,i);
	  fi;
	fi;
	j:=j+1;
      od;
    fi;
  od;
  return inv;
end;


################################################################################
##
#F PortraitOfWord. . . . . . . . . . . . . . . Finds the portrait boundary of an
##              		               	  element in a contracting group

PortraitOfWord:=function(w,G)
  local PortraitIter, bndry,inv,d,PermList;

  PortraitIter:=function(v,lev,plist)
    local i,j,tmpv,sigma;
    for i in [1..Length(G[1])] do
      tmpv:=ShallowCopy(v);
      Add(tmpv,i);
      if IsOneWord(tmpv,G) then
	Add(bndry,[lev,i^inv]);
	return;
      fi;
    od;

    for i in [1..d] do
      tmpv:=[]; sigma:=();
      for j in v do
        Add(tmpv,G[1][j][i^sigma]);
	sigma:=sigma*G[1][j][d+1];
      od;
      if i=1 then Add(plist,sigma);fi;
      Add(plist,[]);
      PortraitIter(tmpv,lev+1,plist[i+1]);
    od;
  end;

  d:=Length(G[1][1])-1;
  bndry:=[d];
  PermList:=[];
  inv:=InverseTableContr(G);
  PortraitIter(w,0,PermList);
  return [bndry,PermList];
end;


################################################################################
##
#F WritePortraitInFile. . . . . . . . . . .Writes portrait in a file in the form
## 							 understandable by Maple

WritePortraitInFile:=function(p,file,add)
  local WritePerm;

  WritePerm:=function(perm)
    local j;
    AppendTo(file,"[ ");
    if Length(perm)>0 then
      AppendTo(file,"`",perm[1],"`");
      for j in [2..Length(perm)] do
	AppendTo(file,", ");
	WritePerm(perm[j]);
      od;
    fi;
    AppendTo(file," ]");
  end;


  if add then AppendTo(file,"[ ",p[1],", ");
    else PrintTo(file,"[ ",p[1],", ");
  fi;
  WritePerm(p[2]);
  AppendTo(file, " ]");
end;


################################################################################
##
#F WritePortraitsInFile. . . . . . . . . . . . .Writes portraitso of elements of
##		       	    a list in a file in the form understandable by Maple

WritePortraitsInFile:=function(lst,G,file,add)
  local WritePerm,i,p;

  if add then AppendTo(file,"[ ");
    else PrintTo(file,"[ ");
  fi;

  for i in [1..Length(lst)] do
    if i=1 then
	AppendTo(file,"[ ",lst[i],", ");
    else
	AppendTo(file,", [ ",lst[i],", ");
    fi;
    p:=PortraitOfWord(lst[i],G);
    WritePortraitInFile(p,file,true);
    AppendTo(file,"]");

  od;
end;


################################################################################
##
#F PortraitsOfWordPowers. . . . . . Finds the sequence of portrait boundaries of
##              		            word's powers in a contracting group

PortraitsOfWordPowers:=function(w,G)
  local list,d,v;
  v:=ShallowCopy(w);
  d:=Length(G[1][1])-1;
  list:=[ShallowCopy(w),PortraitOfWord(v,G)];
  while list[Length(list)]<>[d,[0,1]] do
    Append(v,w);
    Add(list, PortraitOfWord(v,G));
  od;
  return list;
end;


################################################################################
##
#F Growth. . . . . . . . . . . . . . . . . . . . . . . .Finds number of elements
##              		            		   of the length up to n

Growth:=function(n,G)
  local gr,len, ElList, GrList,inv,i,j,k,oldgr,v,tmpv,New,inverse;

  inverse:=function(w)
    local i, iw;
    iw:=[];
    for i in [1..Length(w)] do
      iw[i]:=w[Length(w)-i+1]^inv;
    od;
    return iw;
  end;

  gr:=1; len:=1;
#  G:=AddInverses(G);
  inv:=InverseTableContr(G);
  GrList:=[1,Length(G[1])];
  ElList:=[];
  for i in [1..Length(G[1])] do
    Add(ElList,[i]);
  od;

  while len<n do
    for i in [GrList[len]+1..GrList[len+1]] do
      oldgr:=Length(ElList);
      for j in [2..Length(G[1])] do
        v:=ShallowCopy(ElList[i]);
	Add(v,j);
	New:=true;
 	k:=1;
	while New and k<=oldgr do
	  tmpv:=ShallowCopy(v);
	  Append(tmpv,inverse(ElList[k]));
	  if IsOneWord(tmpv,G) then New:=false; fi;
	  k:=k+1;
	od;
	if New then Add(ElList,v); fi;
      od;
    od;
    Add(GrList,Length(ElList));
    Print("Length not greater than ",len+1,": ",Length(ElList),"\n");
    len:=len+1;
  od;

  return GrList;
end;