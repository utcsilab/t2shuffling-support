# T2 Shuffling Demonstration Code
Demonstration code for the MRM manuscript,
__T2 Shuffling: Sharp, Multi-Contrast, Volumetric Fast Spin-Echo Imaging__ [1].

Written by Jon Tamir. Please feel free to contact me or post an issue on the repository page if there is a problem.  
Email: <jtamir@utexas.edu>

This code may be freely used and modified for educational, research, and not-for-profit purposes (See
[`LICENSE`](LICENSE) for more information).

T2 Shuffling is an MRI acquisition and reconstruction method based on 3D Fast Spin-Echo. The method accounts for temporal
dynamics during the echo trains to reduce image blur and resolve multiple image contrasts along the T2 relaxation curve.
Figure 1 provides a high level overview of the method. The echo train ordering is randomly shuffled during the
acquisition according to variable density Poisson disc sampling masks. The shuffling leads to reduced image blur at the
cost of noise-like artifacts. The artifacts are iteratively suppressed in a regularized reconstruction based on
compressed sensing and full signal dynamics are recovered.

![](doc/images/t2shuffling-overview.png?raw=true)

[1] J.I. Tamir, M. Uecker, W. Chen, P. Lai, M.T. Alley, S.S. Vasanawala, and M. Lustig, [T2 Shuffling: Sharp, multicontrast, volumetric fast spin-echo imaging][t2shuffling-paper]. *Magn Reson Med* 2016 (Early View). doi: 10.1002/mrm.26102

Multi-planar video of relaxation over time:
[[Youtube]](https://youtu.be/60FogqghOYs)
[[Direct Link]](doc/videos/t2shuffling_reformat.mov)

Same reconstruction, with a fixed window level:
[[Youtube]](https://youtu.be/nmnQjTUIeS0)
[[Direct Link]](doc/videos/t2shuffling_reformat_rescale.mov)

## Organization
* `src/`: Matlab demos, outlined below
  * `src/utils/`: Matlab utility and mex functions
* `data/`: Collection of mat and BART files used by the demos
* `doc/`: Documentation and demos

## Matlab Demos
To install the mex files and add the correct paths for the demos,
navigate to the `t2shuffling-support` base directory, and run the command
```
>> make
```
Now you can run any of the demos in the `src` directory. To list the demos, run
```
>> t2shuffling_demos
```

### T2 Shuffling reconstruction using ADMM [[Demo Webpage]](http://jtamir.github.io/t2shuffling-support/doc/html/demo_t2shuffling_recon.html)
The script [`src/demo_t2shuffling_recon.m`](src/demo_t2shuffling_recon.m) demonstrates the T2 Shuffling reconstruction on an axial slice of an
under-sampled knee.

### Simulate signal evolutions and generate a subspace [[Demo Webpage]](http://jtamir.github.io/t2shuffling-support/doc/html/demo_gen_subspace.html)
The script [`src/demo_gen_subspace.m`](src/demo_gen_subspace.m) demonstrates the T2 Shuffling reconstruction on an axial slice of an
under-sampled knee.

### Locally Low Rank degrees of freedom [[Demo Webpage]](http://jtamir.github.io/t2shuffling-support/doc/html/demo_llr_degrees_of_freedom.html)
The script [`src/demo_llr_degrees_of_freedom.m`](src/demo_llr_degrees_of_freedom.m) demonstrates the LLR degrees of freedom and k-means clustering.

### Randomly shuffled echo train ordering [[Demo Webpage]](http://jtamir.github.io/t2shuffling-support/doc/html/demo_t2shuffling_mask.html)
The script [`src/demo_t2shuffling_mask.m`](src/demo_t2shuffling_mask.m) demonstrates the echo train view ordering/sampling pattern generation.

### B_1 inhomogeneity [[Demo Webpage]](http://jtamir.github.io/t2shuffling-support/doc/html/demo_b1_and_model_error.html)
The script [`src/demo_b1_and_model_error.m`](src/demo_b1_and_model_error.m) simulates the subspace model error as a function of percent B1 inhomogeneity and T2 value,
as well as demonstrating the bias vs. noise tradeoff with subspace size.

### 1D Point Spread Function [[Demo Webpage]](http://jtamir.github.io/t2shuffling-support/doc/html/demo_psf_1d.html)
The script [`src/demo_psf_1d.m`](src/demo_psf_1d.m) simulates the 1D point spread function (PSF) for exponential decay
with both ceter-out and randomly shuffled view orderings.

### Transform Point Spread Function [[Demo Webpage]](http://jtamir.github.io/t2shuffling-support/doc/html/demo_tpsf.html)
The script [`src/demo_tpsf.m`](src/demo_tpsf.m) simulates the transform point spread function (TPSF) for a center-out
ordering and a randomly shuffled ordering.


## Acknowledgements
The extended phase graph (EPG) code
was written by Brian Hargreaves and downloaded
from http://web.stanford.edu/~bah/software/epg/
on Dec. 7, 2015.

Some Matlab utility functions were written by Michael Lustig in the ESPIRiT
Matlab reference implementation. They were downloaded from
http://people.eecs.berkeley.edu/~mlustig/Software.html
on Dec. 7, 2015.

All rights/distribution are the same as for the original code,
and should cite the original author and webpage

[t2shuffling-paper]:http://onlinelibrary.wiley.com/doi/10.1002/mrm.26102/abstract

