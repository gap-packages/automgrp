InstallOtherMethod(\^,"list^perm",true,[IsList,IsPerm],0,
function(l,p)
  local i,b;
  b:=[];
  for i in [1..Length(l)] do
    b[i^p]:=l[i];
  od;
  return b;
end);


file:="c:/gap4r3/pkg/automata/data/savchuk/list.dat";

################################################################################
##
#F AutNum. . . . . . . . . . . . . . . . . . . . . . . . .generates automaton #n
##

AutNum:=function(n)
  local i,col,row,aut,m;
  m:=n-1;
  aut:=[[[,,],[,,],[,,]]];
  row:=(m-(m mod 729))/729;
  col:=m-row*729;
  for i in [1..3] do
    aut[1][i][3]:=(1,2)^(row mod 2);
    row:=(row-(row mod 2))/2;
  od;
  for i in [1..3] do
    aut[1][i][1]:=(col mod 3)+1;
    col:=(col-(col mod 3))/3;
    aut[1][i][2]:=(col mod 3)+1;
    col:=(col-(col mod 3))/3;
  od;
  return aut;
end;


################################################################################
##
#F NumOfAut. . . . . . . . . . . . . . . . . . . . .computes the number of given
##                                                         automaton in the list

NumOfAut:=function(A)
  local i,col,row,n;
  row:=0; col:=0;
  for i in [0..2] do
    row:=row+((2^A[1][i+1][3]) mod 2)*2^i;
  od;
  for i in [0..2] do
    col:=col+3^(2*i)*(A[1][i+1][1]-1);
    col:=col+3^(2*i+1)*(A[1][i+1][2]-1);
  od;
  n:=col+729*row+1;
  return n;
end;


################################################################################
##
#F EquivList. . . . . . . . . . . . . . . . . . . . finds automata equivalent to
##                                                                 the given one

EquivList:=function(A)
  local list,i,n,tmp,pi,S3,t,l,j,B;
  list:=[];
  S3:=SymmetricGroup(3);
  for pi in S3 do
#    Print("pi=",pi,"\n");
    tmp:=StructuralCopy(A[1]);
    tmp:=tmp^pi;
#    Print("tmp=",tmp,"\n");
    for i in [1..3] do
      tmp[i][1]:=tmp[i][1]^pi;
      tmp[i][2]:=tmp[i][2]^pi;
    od;
    if not [tmp] in list then Add(list,[tmp]); fi;
  od;

  #inverse automata
  l:=Length(list);
  for i in [1..l] do
    tmp:=StructuralCopy(list[i][1]);
    for j in [1..3] do
      if tmp[j][3]=(1,2) then
        t:=tmp[j][1];
        tmp[j][1]:=tmp[j][2];
        tmp[j][2]:=t;
      fi;
    od;
    if not [tmp] in list then Add(list,[tmp]); fi;
  od;

  #swap 0/1
  l:=Length(list);
  for i in [1..l] do
    tmp:=StructuralCopy(list[i][1]);
    for j in [1..3] do
      t:=tmp[j][1];
      tmp[j][1]:=tmp[j][2];
      tmp[j][2]:=t;
    od;
    if not [tmp] in list then Add(list,[tmp]); fi;
  od;
#  Print("A=",A,"\n");
  return list;
end;

################################################################################
##
#F EditList. . . . . . . . . . . . . . . . . . . . .
##

EditList:=function(list)
  local i,j,eq;
  for i in [1..Length(list)] do
    if list[i][2]=i then
      eq:=EquivList(list[i][1]);
      for j in eq do
        list[NumOfAut(j)][2]:=i;
      od;
    fi;
  od;
#  PrintTo(file,"list:=",list,";");
  return list;
end;


################################################################################
##
#F SaveList. . . . . . . . . . . . . . . . . . . . . . . .saves list to the file
##

SaveList:=function(list)
  PrintTo(file,"list:=",list,";");
end;


################################################################################
##
#F IsErgodic. . . . . . . . . . . . . . . . . . . . .checks whether automaton is
##                                                                       ergodic

IsErgodic:=function(A)
  local state,i,stlist,erg,prleft,prright;
  erg:=true;
  for state in [1..3] do
    prleft:=A[1][state][1];
    prright:=A[1][state][2];
    stlist:=[state,prleft,prright,A[1][prleft][1],A[1][prleft][2],A[1][prright][1],A[1][prright][2]];
    if not IsEqualSet(stlist,[1,2,3]) then erg:=false; fi;
  od;
  return erg;
end;


################################################################################
##
#F EditList2states. . . . . . . . . . . . . . . . . . . . .
##

EditList2states:=function(list)
  local i,eq,A,comm;
  for i in [1..Length(list)] do
    comm:="";
    if list[i][1][1][2]=[2,2,()] and (not 2 in list[i][1][1][1]) and (not 2 in list[i][1][1][3]) and (list[i][1][1][1][3]=(1,2)) then
      if list[i][1][1][3][3]=(1,2) then
        comm:="Z/2Z";
      elif list[i][1][1][1]=[1,1,(1,2)] or list[i][1][1][1]=[3,3,(1,2)] then
        if list[i][1][1][3]=[1,1,()] then comm:="Klein Group";
        elif list[i][1][1][3]=[3,3,()] then comm:="Z/2Z";
        else comm:="Infinite Dihedral Group";
        fi;
      elif list[i][1][1][3][1]=list[i][1][1][3][2] then comm:="Z";
      else comm:="Lamplighter group";
      fi;
    elif list[i][1][1][2]=[2,2,(1,2)] and (not 2 in list[i][1][1][1]) and (not 2 in list[i][1][1][3]) and (list[i][1][1][1][3]=(1,2)) then
      if list[i][1][1][3][3]=(1,2) then
        comm:="Z/2Z";
      elif list[i][1][1][1]=[1,1,(1,2)] then
        if list[i][1][1][3]=[1,1,()] then comm:="Klein Group";
        elif list[i][1][1][3]=[3,3,()] then comm:="Z/2Z";
        else comm:="Infinite Dihedral Group";
        fi;
      elif list[i][1][1][1]=[3,3,(1,2)] then
        if list[i][1][1][3]=[1,1,()] then comm:="Mark: Klein Group";
        elif list[i][1][1][3]=[3,3,()] then comm:="Klein Group";
        else comm:="Mark: Infinite Dihedral Group";
        fi;
      elif list[i][1][1][3][1]=list[i][1][1][3][2] then comm:="Mark: Z";
      else comm:="Mark: Lamplighter group";
      fi;
    fi;
    if comm<>"" then
      for A in EquivList(list[i][1]) do
        list[NumOfAut(A)][4]:=comm;
      od;
    fi;
  od;
  return list;
end;


################################################################################
##
#F SmallAutomGroup(automaton) . . . . . . . . . . . .computes group generated by
##                                                  2-state or 1-state automaton

SmallAutomGroup:= function(A)
  local i,j,M;
  M:=MinimizeAutom(A);

  #if there is the only state
  if Length(M[1])=1 then
    if M[1][1][3]=(1,2) then return "Z/2Z";
    else return "trivial group";
    fi;

  #if there are 2 states
  elif Length(M[1])=2 then
    #swap states so that the first one is active
    if M[1][1][3]=() then
      M[1]:=M[1]^(1,2);
      for i in [1..2] do for j in [1..2] do
        M[1][i][j]:=M[1][i][j]^(1,2);
      od; od;
    fi;


    if M[1][2][3]=(1,2) then
      return "Z/2Z";
    elif M[1][1]=[1,1,(1,2)] or M[1][1]=[2,2,(1,2)] then
      if M[1][2]=[1,1,()] then return "Klein Group";
      elif M[1][2]=[2,2,()] then return "Z/2Z";
      else return "Infinite Dihedral Group";
      fi;
    elif M[1][2][1]=M[1][2][2] then return "Z";
    else return "Lamplighter group";
    fi;

  fi;
  return fail;
end;


################################################################################
##
#F SynchronizeByLabel . . . . . . . . . . . .synchronizes list using given label
##

SynchronizeByLabel:=function(list,label)
  local i,tmp;
  tmp:=[];
  for i in [1..Length(list)] do
    if list[i][4]=label then Add(tmp,i); fi;
  od;
  Print(tmp);
  for i in tmp do
    list[i][2]:=tmp[1];
  od;
  return list;
end;

################################################################################
##
#F NumberOfClasses . . . . . . . . . . .gives nuber of different classes in list
##

NumberOfClasses:=function(list)
  local n,i;
  n:=0;
  for i in [1..Length(list)] do
    if list[i][2]=i then n:=n+1; fi;
  od;
  return n;
end;
