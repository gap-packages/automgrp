#############################################################################
##
#W  common.g                automata package                   Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##


###############################################################################
##
#V  AUTOMATA_PARAMETERS
##
AUTOMATA_PARAMETERS := rec (
    IDENTITY_SYMBOL := "e",
    SPH_TRANS_CHECK_MAX_NUMBER_OF_LEVELS := 100,
    ORDER_COMPUTE_MAX := 2^10,
    ORDER_COMPUTE_MILESTONE := 2^5,
    MULT_TABLE_WIDTH := 1,  # cannot be less than 1
    REDUCING_TABLE_WIDTH := 0,
    USE_MULT_TABLE := "no",
    USE_REDUCING_TABLE := "no",
    REDUCE_IN_MULTIPLYING := "yes",
    LOOK_FOR_RELATORS := "yes",
    REDUCE_EVERYTHING := "no"
);

DEBUG_LEVEL := 2;





