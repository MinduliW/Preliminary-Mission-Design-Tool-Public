function state = spice_sgp4(et,active)


         CENTER =   399;

         %
         % Local variables.
         %
         geophs = zeros(8,1);

         %
         % These are the variables that will hold the constants
         % required by cspice_evsgp4. These constants are available
         % from the loaded PCK file, which provides the actual
         % values and units as used by NORAD propagation model.
         %
         %    Constant   Meaning
         %    --------   ------------------------------------------
         %    J2         J2 gravitational harmonic for Earth.
         %    J3         J3 gravitational harmonic for Earth.
         %    J4         J4 gravitational harmonic for Earth.
         %    KE         Square root of the GM for Earth.
         %    QO         High altitude bound for atmospheric model.
         %    SO         Low altitude bound for atmospheric model.
         %    ER         Equatorial radius of the Earth.
         %    AE         Distance units/earth radius.
         %
         noadpn = {'J2','J3','J4', 'KE','QO','SO','ER','AE'};

         %
         if active == true
             tle = [ '1 33492U 009002A  21244.25373181  .00000140'            ...
                 '  00000-0  33254-4 0  9991',
                 '2 33492  98.0939  355.0787 0001606 99.4261 '            ...
                 '260.7125 14.67537568 67480' ];
         else
             tle = [ '1 33500U 009002J  21244.37733068  .00000335'            ...
                 '  00000-0  42552-4 0  9995',
                 '2 33500  98.0969 171.2530 0049984 145.9783 '            ...
                 '214.4654 14.87601870 68312' ];

         end

         %
         % Load the MK file that includes the PCK file that provides
         % the geophysical constants required for the evaluation of
         % the two-line elements sets and the LSK, as it is required
         % by cspice_getelm to perform time conversions.
         %
         %cspice_furnsh( 'kernel.txt' );

         %
         % Retrieve the data from the kernel, and place it on
         % the `geophs' array.
         %
         for i=1:8

            [geophs(i)] = cspice_bodvcd( CENTER, noadpn(i), 1 );

         end

         %
         % Convert the Two Line Elements lines to the element sets.
         % Set the lower bound for the years to be the beginning
         % of the space age.
         %
         [epoch, elems] = cspice_getelm( 1957, tle );

         
         %
         % Now propagate the state using cspice_evsgp4 to the epoch
         % of interest.
         %
         [state] = cspice_evsgp4( et, geophs, elems );

         %
         % Display the results.
         %
%         fprintf( 'Epoch   : %s\n', TIMSTR )
%          fprintf( 'Position: %15.8f %15.8f %15.8f\n',                     ...
%                          state(1), state(2), state(3) )
%          fprintf( 'Velocity: %15.8f %15.8f %15.8f\n',                     ...
%                          state(4), state(5), state(6) )

         %
         % It's always good form to unload kernels after use,
         % particularly in Matlab due to data persistence.
         %
         cspice_kclear