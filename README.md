# T2 Shuffling Demonstration Code
Demonstration code for the MRM manuscript,
__T2 Shuffling: Sharp, Multi-Contrast, Volumetric Fast Spin-Echo Imaging__ [1].

T2 Shuffling is an MRI acquisition and reconstruction method based on 3D Fast Spin-Echo. The method accounts for temporal
dynamics during the echo trains to reduce image blur and resolve multiple image contrasts along the T2 relaxation curve.
Figure 1 provides a high level overview of the method. The echo train ordering is randomly shuffled during the
acquisition according to variable density Poisson disc sampling masks. The shuffling leads to reduced image blur at the
cost of noise-like artifacts. The artifacts are iteratively suppressed in a regularized reconstruction based on
compressed sensing and full signal dynamics are recovered.

![](doc/images/t2shuffling-overview.png?raw=true)

[1] J.I. Tamir, M. Uecker, W. Chen, P. Lai, M.T. Alley, S.S. Vasanawala, and M. Lustig, "T2 Shuffling: Sharp,
Multi-Contrast, Volumetric Fast Spin-Echo Imaging," Magn, Reson, Med., Early View (2016).

## Organization
* `src/`: Matlab demos, outlined below
  * `src/utils/'`: Matlab utility and mex functions
* `data/`: Collection of mat and BART files used by the demos
* `doc/`: Documentation support files

## Matlab Demos

### T2 Shuffling reconstruction using ADMM
The script `src/demo_t2shuffling_recon.m` demonstrates the T2 Shuffling reconstruction on an axial slice of an
under-sampled knee.
See the [Matlab published webpage](http://htmlpreview.github.io/?html/demo_t2shuffling_recon.html).

### Locally Low Rank degrees of freedom
The script `src/demo_llr_degrees_of_freedom.m` demonstrates the LLR degrees of freedom and k-means clustering.
See the [Matlab published webpage](http://htmlpreview.github.io/?html/demo_llr_degrees_of_freedom.html).

### Randomly shuffled echo train ordering

### B_1 inhomogeneity

### Transform Point Spread Function


## Acknowledgements
The extended phase graph (EPG) code
was written by Brian Hargreaves and downloaded
from http://web.stanford.edu/~bah/software/epg/
on Dec. 7, 2015.

All rights/distribution are the same as for the original code,
and should cite the original author and webpage


## TODO
* foot_basis code -- __DONE__
  * epg code
* data files -- __DONE__
  * flipangle file
  * vieworder files?
  * proton and t2 image
* B1 sim?
* admm/fista implementation -- __DONE__
* LLR degrees of freedom -- __DONE__
* TPSF calculation
* gen nmr mask -- __DONE__

