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


## Acknowledgements
The extended phase graph (EPG) code
was written by Brian Hargreaves and downloaded
from http://web.stanford.edu/~bah/software/epg/
on Dec.\ 7, 2015.

All rights/distribution are the same as for the original code,
and should cite the original author and webpage


## TODO
* foot_basis code
  * epg code
* data files
  * flipangle file
  * vieworder files?
  * proton and t2 image
* B1 sim?
* admm/fista implementation
* LLR degrees of freedom
* TPSF calculation
* gen nmr mask

