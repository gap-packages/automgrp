#############################################################################
##
#W  utilsfrgrp.gd              automata package                Yevgen Muntyan
##                                                              Dmytro Sachuk
##
##  automata v 0.91 started June 07 2004
##
##  Here are utility functions dealing with free groups, words, etc.
##

Revision.utilsfrgrp_gd :=
  "@(#)$Id$";


#############################################################################
##
#O  ReduceListOfWordsByNielsen(<words_list>)
#O  ReduceListOfWordsByNielsenBack(<words_list>)
#O  ReduceListOfWordsByNielsen(<words_list>, <any_string>)
#O  ReduceListOfWordsByNielsenBack(<words_list>, <any_string>)
##
##  It applies Nielsen transformations to <words_list>;
##  input is a list of associative words from the same family.
##
##  Returned value is either fail in case of some error or
##  triple [<result>, <transform>, <did_something>] :
##    <result> is the list of words obtained from <list> using Nielsen
##      transformations;
##    <transform> is the list of words for obtaining <result> from
##      <list> by substituting: <transform> = [w_1, ..., w_n],
##      where w_i are words on alphabet of Length(<list>) letters such that
##      w_i(<words_list>[1], ..., <words_list>[n]) = <result>[i];
##    <did_something> is true if <result> differs from <list> and is
##      false otherwise
##
##  ReduceListOfWordsByNielsenBack is almost identical to
##    ReduceListOfWordsByNielsen: the difference is in the order of
##    comparisons performed inside of main loop;
##    it makes Mihaylov feel better?
##
##  The variants with the second string argument do the same
##    except that the lexicographic ordering on set of words is generated
##    by the following ordering: x_1 < x_1^{-1} < x_2 < x_2^{-1} < ...
##    It's intended for nice output - like "a^2, b^2" instead of "a^-2, b^-2"
##
DeclareOperation("ReduceListOfWordsByNielsen", [IsAssocWordCollection]);
DeclareOperation("ReduceListOfWordsByNielsenBack", [IsAssocWordCollection]);


#############################################################################
##
#F  ComputeMihaylovSystemPairs(<pairs_list>)
##
##  For given list of pairs of free group words, it computes the Mihaylov
##    normal form.
##
##  Returned value is either fail in case of some error or
##  triple [<result>, <transform>, <did_something>] :
##    <result> is the list of pairs representing Mihaylov normal form;
##    <transform> is the list of words for obtaining <result> from
##      <list> by substituting: <transform> = [w_1, ..., w_n],
##      where w_i are words on alphabet of Length(<pairs_list>) letters
##      such that w_i(<pairs_list>[1], ..., <pairs_list>[n]) = <result>[i];
##    <did_something> is true if <result> differs from <pairs_list> and is
##      false otherwise
##
DeclareGlobalFunction("ComputeMihaylovSystemPairs");


#E
