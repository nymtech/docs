---
weight: 200
title: Performance Testing
---

# Performance testing

## Benchmarks

The benchmarks were performed on 64bit Ubuntu 18.04.1 LTS VM with 2 cores of 3.6GHz Ryzen 1600 assigned. Each individual benchmark was run single-threaded for 1 minute with `-benchtime=60s` flag.

REQUIRE RERUNNING


| Operation                        | Times run | Time per op     | Memory per op | Allocs per op     |
|----------------------------------|-----------:|-----------------:|---------------:|-------------------:|
| G1Mul                            | 30000  | 2.41 ms/op   | 0.62 kB/op  | 12416 allocs/op   |
| G2Mul                            | 20000  | 5.87 ms/op   | 1.71 kB/op  | 35368 allocs/op   |
| Pairing                          | 3000   | 24.08 ms/op  | 7.44 kB/op  | 170229 allocs/op  |
| ElGamalEncryption                | 10000  | 7.34 ms/op   | 1.88 kB/op  | 37828 allocs/op   |
| ElGamalDecryption                | 30000  | 2.48 ms/op   | 0.62 kB/op  | 12518 allocs/op   |
|                                  |        |              |             |                   |
| Setup/q=1                        | 100000 | 0.97 ms/op   | 0.08 kB/op  | 1522 allocs/op    |
| Setup/q=3                        | 50000  | 1.44 ms/op   | 0.23 kB/op  | 4204 allocs/op    |
| Setup/q=5                        | 50000  | 2.31 ms/op   | 0.47 kB/op  | 8647 allocs/op    |
| Setup/q=10                       | 20000  | 4.00 ms/op   | 0.91 kB/op  | 16541 allocs/op   |
| Setup/q=20                       | 10000  | 6.59 ms/op   | 1.80 kB/op  | 32650 allocs/op   |
|                                  |        |              |             |                   |
| Keygen/q=1                       | 10000  | 9.53 ms/op   | 3.47 kB/op  | 71764 allocs/op   |
| Keygen/q=3                       | 5000   | 18.83 ms/op  | 6.94 kB/op  | 143543 allocs/op  |
| Keygen/q=5                       | 3000   | 28.53 ms/op  | 10.41 kB/op | 215265 allocs/op  |
| Keygen/q=10                      | 2000   | 50.35 ms/op  | 19.08 kB/op | 394701 allocs/op  |
|                                  |        |              |             |                   |
| TTPKeygen/q=1/t=3/n=5            | 2000   | 51.52 ms/op  | 17.29 kB/op | 357551 allocs/op  |
| TTPKeygen/q=3/t=3/n=5            | 1000   | 94.33 ms/op  | 34.57 kB/op | 715064 allocs/op  |
| TTPKeygen/q=5/t=3/n=5            | 1000   | 141.13 ms/op | 51.86 kB/op | 1072637 allocs/op |
| TTPKeygen/q=10/t=3/n=5           | 300    | 277.17 ms/op | 95.07 kB/op | 1966284 allocs/op |
|                                  |        |              |             |                   |
| TTPKeygen/q=3/t=1/n=5            | 1000   | 105.70 ms/op | 34.30 kB/op | 709764 allocs/op  |
| TTPKeygen/q=3/t=3/n=5            | 1000   | 94.33 ms/op  | 34.57 kB/op | 715064 allocs/op  |
| TTPKeygen/q=3/t=5/n=5            | 1000   | 100.13 ms/op | 34.87 kB/op | 720879 allocs/op  |
|                                  |        |              |             |                   |
| TTPKeygen/q=3/t=1/n=1            | 5000   | 21.91 ms/op  | 6.94 kB/op  | 143605 allocs/op  |
| TTPKeygen/q=3/t=1/n=3            | 2000   | 60.60 ms/op  | 20.62 kB/op | 426695 allocs/op  |
| TTPKeygen/q=3/t=1/n=5            | 1000   | 105.70 ms/op | 34.30 kB/op | 709764 allocs/op  |
| TTPKeygen/q=3/t=1/n=10           | 500    | 188.58 ms/op | 68.51 kB/op | 1417549 allocs/op |
|                                  |        |              |             |                   |
| Sign/pubM=1                      | 30000  | 2.65 ms/op   | 0.71 kB/op  | 14206 allocs/op   |
| Sign/pubM=3                      | 30000  | 2.44 ms/op   | 0.72 kB/op  | 14614 allocs/op   |
| Sign/pubM=5                      | 30000  | 2.46 ms/op   | 0.74 kB/op  | 15029 allocs/op   |
| Sign/pubM=10                     | 30000  | 2.72 ms/op   | 0.77 kB/op  | 16051 allocs/op   |
|                                  |        |              |             |                   |
| PrepareBlindSign/pubM=1/privM=3  | 2000   | 64.42 ms/op  | 18.26 kB/op | 366447 allocs/op  |
| PrepareBlindSign/pubM=3/privM=3  | 1000   | 73.21 ms/op  | 20.79 kB/op | 417517 allocs/op  |
| PrepareBlindSign/pubM=5/privM=3  | 1000   | 82.13 ms/op  | 23.32 kB/op | 468632 allocs/op  |
| PrepareBlindSign/pubM=10/privM=3 | 1000   | 102.95 ms/op | 29.66 kB/op | 596363 allocs/op  |
|                                  |        |              |             |                   |
| PrepareBlindSign/pubM=3/privM=1  | 3000   | 35.50 ms/op  | 10.61 kB/op | 212744 allocs/op  |
| PrepareBlindSign/pubM=3/privM=3  | 1000   | 73.21 ms/op  | 20.79 kB/op | 417517 allocs/op  |
| PrepareBlindSign/pubM=3/privM=5  | 1000   | 109.91 ms/op | 30.96 kB/op | 622296 allocs/op  |
| PrepareBlindSign/pubM=3/privM=10 | 500    | 200.21 ms/op | 56.40 kB/op | 1134289 allocs/op |
|                                  |        |              |             |                   |
| BlindSign/pubM=1/privM=3         | 1000   | 80.25 ms/op  | 19.80 kB/op | 395915 allocs/op  |
| BlindSign/pubM=3/privM=3         | 1000   | 94.95 ms/op  | 23.52 kB/op | 470805 allocs/op  |
| BlindSign/pubM=5/privM=3         | 1000   | 115.88 ms/op | 27.23 kB/op | 545636 allocs/op  |
| BlindSign/pubM=10/privM=3        | 500    | 151.66 ms/op | 36.52 kB/op | 732772 allocs/op  |
|                                  |        |              |             |                   |
| BlindSign/pubM=3/privM=1         | 2000   | 50.99 ms/op  | 13.12 kB/op | 262559 allocs/op  |
| BlindSign/pubM=3/privM=3         | 1000   | 94.95 ms/op  | 23.52 kB/op | 470805 allocs/op  |
| BlindSign/pubM=3/privM=5         | 1000   | 132.86 ms/op | 33.92 kB/op | 679003 allocs/op  |
| BlindSign/pubM=3/privM=10        | 500    | 224.29 ms/op | 59.92 kB/op | 1199647 allocs/op |
|                                  |        |              |             |                   |
| Unblind                          | 50000  | 2.23 ms/op   | 0.62 kB/op  | 12520 allocs/op   |
|                                  |        |              |             |                   |
| Verify/q=1                       | 2000   | 43.74 ms/op  | 16.68 kB/op | 377329 allocs/op  |
| Verify/q=3                       | 2000   | 58.98 ms/op  | 20.13 kB/op | 448605 allocs/op  |
| Verify/q=5                       | 2000   | 72.38 ms/op  | 23.57 kB/op | 519902 allocs/op  |
| Verify/q=10                      | 1000   | 99.86 ms/op  | 32.18 kB/op | 698113 allocs/op  |
|                                  |        |              |             |                   |
| ShowBlindSignature/privM=1       | 3000   | 25.86 ms/op  | 8.30 kB/op  | 170666 allocs/op  |
| ShowBlindSignature/privM=3       | 2000   | 46.45 ms/op  | 15.26 kB/op | 314652 allocs/op  |
| ShowBlindSignature/privM=5       | 2000   | 69.42 ms/op  | 22.22 kB/op | 458565 allocs/op  |
| ShowBlindSignature/privM=10      | 1000   | 122.28 ms/op | 39.63 kB/op | 818530 allocs/op  |
|                                  |        |              |             |                   |
| BlindVerify/pubM=1               | 2000   | 72.81 ms/op  | 25.04 kB/op | 548832 allocs/op  |
| BlindVerify/pubM=3               | 1000   | 95.70 ms/op  | 28.50 kB/op | 620468 allocs/op  |
| BlindVerify/pubM=5               | 1000   | 111.46 ms/op | 31.97 kB/op | 692124 allocs/op  |
| BlindVerify/pubM=10              | 1000   | 149.02 ms/op | 40.63 kB/op | 871100 allocs/op  |
|                                  |        |              |             |                   |
| Make Pi_S/privM=1                | 10000  | 11.69 ms/op  | 3.53 kB/op  | 70166 allocs/op   |
| Make Pi_S/privM=3                | 3000   | 29.47 ms/op  | 8.71 kB/op  | 174317 allocs/op  |
| Make Pi_S/privM=5                | 2000   | 47.39 ms/op  | 13.89 kB/op | 278486 allocs/op  |
| Make Pi_S/privM=10               | 1000   | 91.94 ms/op  | 26.85 kB/op | 538835 allocs/op  |
|                                  |        |              |             |                   |
| Verify Pi_S/privM=1              | 5000   | 19.90 ms/op  | 5.49 kB/op  | 109193 allocs/op  |
| Verify Pi_S/privM=3              | 2000   | 48.99 ms/op  | 13.29 kB/op | 265404 allocs/op  |
| Verify Pi_S/privM=5              | 1000   | 81.02 ms/op  | 21.08 kB/op | 421538 allocs/op  |
| Verify Pi_S/privM=10             | 500    | 157.98 ms/op | 40.58 kB/op | 811975 allocs/op  |
|                                  |        |              |             |                   |
| Make Pi_V/privM=1                | 10000  | 13.29 ms/op  | 4.21 kB/op  | 86467 allocs/op   |
| Make Pi_V/privM=3                | 3000   | 24.83 ms/op  | 7.73 kB/op  | 159146 allocs/op  |
| Make Pi_V/privM=5                | 3000   | 34.45 ms/op  | 11.24 kB/op | 231803 allocs/op  |
| Make Pi_V/privM=10               | 2000   | 62.37 ms/op  | 20.04 kB/op | 413538 allocs/op  |
|                                  |        |              |             |                   |
| Verify Pi_V/privM=1              | 5000   | 26.46 ms/op  | 8.28 kB/op  | 170223 allocs/op  |
| Verify Pi_V/privM=3              | 2000   | 41.59 ms/op  | 11.75 kB/op | 241841 allocs/op  |
| Verify Pi_V/privM=5              | 2000   | 63.44 ms/op  | 15.21 kB/op | 313454 allocs/op  |
| Verify Pi_V/privM=10             | 1000   | 100.71 ms/op | 23.87 kB/op | 492518 allocs/op  |

#### BLS381

| Operation                        | Times run | Time per op     | Memory per op | Allocs per op     |
|----------------------------------|-----------:|-----------------:|---------------:|-------------------:|
| G1Mul                            | 30000 | 3.14 ms/op   | 0.86 kB/op   | 12879 allocs/op   |
| G2Mul                            | 10000 | 7.43 ms/op   | 2.36 kB/op   | 35502 allocs/op   |
| Pairing                          | 2000  | 35.24 ms/op  | 12.98 kB/op  | 227295 allocs/op  |
| ElGamalEncryption                | 10000 | 9.28 ms/op   | 2.62 kB/op   | 39219 allocs/op   |
| ElGamalDecryption                | 30000 | 3.27 ms/op   | 0.87 kB/op   | 12981 allocs/op   |
|                                  |       |              |              |                   |
| Setup/q=1                        | 10000 | 6.20 ms/op   | 0.85 kB/op   | 12359 allocs/op   |
| Setup/q=3                        | 10000 | 10.03 ms/op  | 2.55 kB/op   | 37085 allocs/op   |
| Setup/q=5                        | 5000  | 15.07 ms/op  | 4.23 kB/op   | 61436 allocs/op   |
| Setup/q=10                       | 3000  | 29.58 ms/op  | 8.42 kB/op   | 122373 allocs/op  |
| Setup/q=20                       | 2000  | 58.55 ms/op  | 17.04 kB/op  | 247682 allocs/op  |
|                                  |       |              |              |                   |
| Keygen/q=1                       | 5000  | 14.22 ms/op  | 4.78 kB/op   | 72051 allocs/op   |
| Keygen/q=3                       | 3000  | 29.57 ms/op  | 9.56 kB/op   | 144087 allocs/op  |
| Keygen/q=5                       | 2000  | 43.98 ms/op  | 14.34 kB/op  | 216119 allocs/op  |
| Keygen/q=10                      | 1000  | 79.13 ms/op  | 26.29 kB/op  | 396254 allocs/op  |
|                                  |       |              |              |                   |
| TTPKeygen/q=1/t=3/n=5            | 2000  | 68.68 ms/op  | 24.09 kB/op  | 362908 allocs/op  |
| TTPKeygen/q=3/t=3/n=5            | 500   | 140.11 ms/op | 48.18 kB/op  | 725938 allocs/op  |
| TTPKeygen/q=5/t=3/n=5            | 500   | 250.20 ms/op | 72.26 kB/op  | 1088793 allocs/op |
| TTPKeygen/q=10/t=3/n=5           | 200   | 419.25 ms/op | 132.49 kB/op | 1996312 allocs/op |
|                                  |       |              |              |                   |
| TTPKeygen/q=3/t=1/n=5            | 1000  | 131.74 ms/op | 47.29 kB/op  | 712539 allocs/op  |
| TTPKeygen/q=3/t=3/n=5            | 500   | 140.11 ms/op | 48.18 kB/op  | 725938 allocs/op  |
| TTPKeygen/q=3/t=5/n=5            | 500   | 148.48 ms/op | 49.04 kB/op  | 738884 allocs/op  |
|                                  |       |              |              |                   |
| TTPKeygen/q=3/t=1/n=1            | 3000  | 27.94 ms/op  | 9.57 kB/op   | 144175 allocs/op  |
| TTPKeygen/q=3/t=1/n=3            | 1000  | 80.56 ms/op  | 28.43 kB/op  | 428325 allocs/op  |
| TTPKeygen/q=3/t=1/n=5            | 1000  | 131.74 ms/op | 47.29 kB/op  | 712539 allocs/op  |
| TTPKeygen/q=3/t=1/n=10           | 300   | 264.51 ms/op | 94.44 kB/op  | 1422807 allocs/op |
|                                  |       |              |              |                   |
| Sign/q=1                         | 10000 | 6.59 ms/op   | 1.72 kB/op   | 25457 allocs/op   |
| Sign/q=3                         | 10000 | 6.34 ms/op   | 1.75 kB/op   | 26128 allocs/op   |
| Sign/q=5                         | 10000 | 6.30 ms/op   | 1.77 kB/op   | 26731 allocs/op   |
| Sign/q=10                        | 10000 | 6.85 ms/op   | 1.84 kB/op   | 28319 allocs/op   |
|                                  |       |              |              |                   |
| PrepareBlindSign/pubM=1/privM=3  | 1000  | 99.25 ms/op  | 27.16 kB/op  | 403995 allocs/op  |
| PrepareBlindSign/pubM=3/privM=3  | 1000  | 114.68 ms/op | 30.69 kB/op  | 456865 allocs/op  |
| PrepareBlindSign/pubM=5/privM=3  | 1000  | 125.83 ms/op | 34.23 kB/op  | 509835 allocs/op  |
| PrepareBlindSign/pubM=10/privM=3 | 500   | 155.18 ms/op | 43.07 kB/op  | 642252 allocs/op  |
|                                  |       |              |              |                   |
| PrepareBlindSign/pubM=3/privM=1  | 2000  | 59.54 ms/op  | 16.42 kB/op  | 243791 allocs/op  |
| PrepareBlindSign/pubM=3/privM=3  | 1000  | 114.68 ms/op | 30.69 kB/op  | 456865 allocs/op  |
| PrepareBlindSign/pubM=3/privM=5  | 500   | 159.97 ms/op | 44.96 kB/op  | 669924 allocs/op  |
| PrepareBlindSign/pubM=3/privM=10 | 300   | 279.99 ms/op | 80.66 kB/op  | 1203099 allocs/op |
|                                  |       |              |              |                   |
| BlindSign/pubM=1/privM=3         | 1000  | 116.49 ms/op | 29.71 kB/op  | 439143 allocs/op  |
| BlindSign/pubM=3/privM=3         | 1000  | 137.48 ms/op | 34.89 kB/op  | 516775 allocs/op  |
| BlindSign/pubM=5/privM=3         | 500   | 175.99 ms/op | 40.08 kB/op  | 594434 allocs/op  |
| BlindSign/pubM=10/privM=3        | 500   | 221.57 ms/op | 53.04 kB/op  | 788480 allocs/op  |
|                                  |       |              |              |                   |
| BlindSign/pubM=3/privM=1         | 1000  | 79.49 ms/op  | 20.08 kB/op  | 297298 allocs/op  |
| BlindSign/pubM=3/privM=3         | 1000  | 137.48 ms/op | 34.89 kB/op  | 516775 allocs/op  |
| BlindSign/pubM=3/privM=5         | 500   | 198.60 ms/op | 49.70 kB/op  | 736258 allocs/op  |
| BlindSign/pubM=3/privM=10        | 200   | 360.87 ms/op | 86.72 kB/op  | 1284699 allocs/op |
|                                  |       |              |              |                   |
| Unblind                          | 30000 | 3.29 ms/op   | 0.87 kB/op   | 12981 allocs/op   |
|                                  |       |              |              |                   |
| Verify/q=1                       | 1000  | 79.75 ms/op  | 28.47 kB/op  | 492060 allocs/op  |
| Verify/q=3                       | 1000  | 101.28 ms/op | 33.21 kB/op  | 563590 allocs/op  |
| Verify/q=5                       | 1000  | 121.88 ms/op | 37.96 kB/op  | 635132 allocs/op  |
| Verify/q=10                      | 500   | 157.97 ms/op | 49.83 kB/op  | 813898 allocs/op  |
|                                  |       |              |              |                   |
| ShowBlindSignature/privM=1       | 3000  | 33.87 ms/op  | 11.49 kB/op  | 172584 allocs/op  |
| ShowBlindSignature/privM=3       | 2000  | 68.18 ms/op  | 21.08 kB/op  | 317034 allocs/op  |
| ShowBlindSignature/privM=5       | 1000  | 102.96 ms/op | 30.67 kB/op  | 461511 allocs/op  |
| ShowBlindSignature/privM=10      | 500   | 181.16 ms/op | 54.65 kB/op  | 822574 allocs/op  |
|                                  |       |              |              |                   |
| BlindVerify/pubM=1               | 1000  | 123.31 ms/op | 40.12 kB/op  | 666449 allocs/op  |
| BlindVerify/pubM=3               | 1000  | 139.62 ms/op | 44.89 kB/op  | 738303 allocs/op  |
| BlindVerify/pubM=5               | 500   | 164.23 ms/op | 49.66 kB/op  | 810116 allocs/op  |
| BlindVerify/pubM=10              | 500   | 229.97 ms/op | 61.60 kB/op  | 989803 allocs/op  |
|                                  |       |              |              |                   |
| ConstructSignerProof/privM=1     | 5000  | 19.20 ms/op  | 5.78 kB/op   | 85033 allocs/op   |
| ConstructSignerProof/privM=3     | 2000  | 43.65 ms/op  | 13.08 kB/op  | 193845 allocs/op  |
| ConstructSignerProof/privM=5     | 1000  | 67.95 ms/op  | 20.39 kB/op  | 302659 allocs/op  |
| ConstructSignerProof/privM=10    | 1000  | 129.18 ms/op | 38.65 kB/op  | 574694 allocs/op  |
|                                  |       |              |              |                   |
| VerifySignerProof/privM=1        | 3000  | 28.52 ms/op  | 8.63 kB/op   | 126866 allocs/op  |
| VerifySignerProof/privM=3        | 2000  | 67.80 ms/op  | 19.74 kB/op  | 291483 allocs/op  |
| VerifySignerProof/privM=5        | 1000  | 112.43 ms/op | 30.85 kB/op  | 456039 allocs/op  |
| VerifySignerProof/privM=10       | 500   | 215.14 ms/op | 58.63 kB/op  | 867673 allocs/op  |
|                                  |       |              |              |                   |
| ConstructVerifierProof/privM=1   | 5000  | 21.35 ms/op  | 5.85 kB/op   | 87663 allocs/op   |
| ConstructVerifierProof/privM=3   | 2000  | 41.01 ms/op  | 10.69 kB/op  | 160576 allocs/op  |
| ConstructVerifierProof/privM=5   | 2000  | 59.72 ms/op  | 15.54 kB/op  | 233515 allocs/op  |
|                                  |       |              |              |                   |
| ConstructVerifierProof/privM=10  | 1000  | 115.53 ms/op | 27.64 kB/op  | 415779 allocs/op  |
| VerifyVerifierProof/privM=1      | 2000  | 52.42 ms/op  | 11.51 kB/op  | 172606 allocs/op  |
| VerifyVerifierProof/privM=3      | 1000  | 77.37 ms/op  | 16.29 kB/op  | 244440 allocs/op  |
| VerifyVerifierProof/privM=5      | 1000  | 103.73 ms/op | 21.06 kB/op  | 316318 allocs/op  |
| VerifyVerifierProof/privM=10     | 500   | 169.76 ms/op | 32.99 kB/op  | 495936 allocs/op  |
