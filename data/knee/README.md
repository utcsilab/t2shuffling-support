## Knee Data
The files here are from an axial slice of a T2 Shuffling scan on an adult volunteer's knee.
The main imaging parameters were the following:

* ETL = 82
* Initial skipped echoes = 2
* Echo spacing = 6.168 ms
* Number of echo trains = 291
* Number of sampling masks to generate = 8
* TR = 1400 ms
* Scan time = 291 * 1.4 / 60 = 6.8 minutes

Each pair of `cfl` and `hdr` files is a BART-formatted data file. The `hdr` file specifies the dimensions of the
data. the `cfl` file is the actual contents, and can be read/written by the Matlab helper functions `readcfl.m` and
`writecfl.m` located under `src/utils`.

The data files are the following:
* `alpha`: example of reconstructed temporal coefficients
* `bas`: temporal basis used for reconstruction
* `sens`: ESPIRiT sensitivity maps
* `mask`: sampling pattern over time (randomly shuffled)
* `recon`: example of the reconstructed time series of images
* `ksp.wavg`: first two echo times of k-space, used for ESPIRiT calibration
* `ksp.te`: raw k-t space data at each echo time

