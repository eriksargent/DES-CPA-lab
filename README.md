#Lab 3
###Erik Sargent and Weston Jensen

CPA attack on DES

--

Before running this, make sure to either: 

1. Put the `secmatv1_2006_04_0809` directory of traces in this directory. This is not included to reduce the size of this assignment.
2. Change the reference to `secmatv1_2006_04_0809` in `lab3.m`, `labO2.m`, and `findGoodPlaintexts.m` to reference the `secmatv1_2006_04_0809` wherever it might be.

Open up this directory in Matlab. Make sure the `DES` and `bin2hex` directories get added to the path. 

To test the baseline implementation, run the `lab3.m` file in Matlab. 

To test the first optimization, first create the `goodTraces` directory, then run `findGoodPlaintexts.m` in Matlab, and finally run `lab3O1.m`.

To test the second optimization, run `lab3O2.m` in Matlab.

To test the combination of the two optimizations, run `lab3OC.m` in Matlab. Note that the good traces must have already been collected before this will work. 