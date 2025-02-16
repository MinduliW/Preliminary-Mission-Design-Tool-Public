 This meta-kernel is intended to support operation of SPICE
         example programs. The kernels shown here should not be
         assumed to contain adequate or correct versions of data
         required by SPICE-based user applications.

         In order for an application to use this meta-kernel, the
         kernels referenced here must be present in the user's
         current working directory.

         The names and contents of the kernels referenced
         by this meta-kernel are as follows:

            File name           Contents
            ---------           ------------------------------------
            naif0012.tls        Leapseconds
            geophysical.ker     geophysical constants for evaluation
                                of two-line element sets.

         The geophysical.ker is a PCK file that is provided with the
         Mice toolkit under the "/data" directory.

\begindata
  PATH_VALUES  = ( 
  		     '/Users/minduli/Astroscale_ADR/Main/SGP4routines_NAIF'
  		  )
  PATH_SYMBOLS = ( 'A' )
  
  KERNELS_TO_LOAD = (
                     '$A/kernels/NAIF0012.tls'
                     '$A/kernels/pck00010.tpc'
                     '$A/kernels/gm_de431.tpc'
                     '$A/kernels/EARTH_000101_220307_211213.bpc'
                     '$A/kernels/de432s.bsp'
                     '$A/kernels/ECLIPJ2000_DE405.tf',
                     '$A/kernels/SPK33492.bsp',
                     '$A/kernels/SPK33500.bsp',
                     '$A/kernels/SPK39766.bsp',
                     '$A/kernels/geophysical.ker'
                    )    

\begintext