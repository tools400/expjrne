      /if not defined(qJob_t    )
      /define qJob_t
      // =============================================================
      //   Qualified job name
      // =============================================================

     d qJob_t          ds                  qualified           based(pDummy)
     d  name                         10a
     d  user                         10a
     d  nbr                           6a

      /endif
