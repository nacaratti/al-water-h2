# Data provenance notes and caveats

## 1. Martinez-Vargas 2026 — order of the reported values (RESOLVED)

The abstract lists "maximum hydrogen flow rates of approximately 13, 15, and 19 mL/min"
immediately after listing sizes as "180-250, 300-425, and 425-500 um". Read naively this pairs
19 mL/min with the LARGEST particles, contradicting the same sentence's claim that smaller
particles react faster.

Table 2 and Sec. 3 resolve it: the figure panels are labelled (a) 425-500, (b) 300-425,
(c) 180-250 — i.e. DESCENDING size — and the rate list follows the panel order, not the
size order given earlier in the sentence. Correct pairing:

| d_mean | Qmax (mL/min)  | tr (min)      | V_cum (mL) | kd (1/min) |
|--------|----------------|---------------|------------|------------|
| 215 um | 18.77 +/- 2.00 | 14.86 +/- 0.18| 106        | 0.137      |
| 363 um | 14.68 +/- 0.76 | 25.12 +/- 0.81| 132        | 0.064      |
| 463 um | 13.14 +/- 0.18 | 29.30 +/- 1.64| 102        | 0.050      |

## 2. Charged aluminium mass is NOT reported (UNRESOLVED — affects validation)

Sec. 2 gives reactor volume (250 mL Kitasato), NaOH concentration (1.0 M), temperature
(55 +/- 1 C), stirring (400 rpm) and replicate count (n = 3), but never the mass of aluminium
charged. This matters because two of the paper's own claims cannot both be true:

* Sec. 2: "the theoretical maximum hydrogen yield matched the integrated volume obtained"
  => conversion ~ 100%, so m_Al = V_cum/1245 = 0.085 / 0.106 / 0.082 g for the three runs.
  Under this reading the differing cumulative volumes are simply differing charged masses and
  THERE IS NO passivation trade-off.

* Sec. 3/4/5: the 132 vs 106 vs 102 mL spread is attributed to "a trade-off between surface
  area and passivation effects".
  This requires EQUAL charged mass and hence incomplete, size-dependent conversion.

These are mutually exclusive. Consequence for this work:

* Validate the particle model on kd, tr and Qmax — triplicated, with reported SEM, and
  independent of the charged mass.
* Treat the cumulative-volume optimum as a HYPOTHESIS to be tested, not as a fitting target,
  and report explicitly what m_Al would have to be for it to hold.

## 3. Stoichiometric coefficient b = 0.5

Martinez-Salazar 2025 states b = 0.5 as the "ratio of aluminum to water". This does not match
2Al + 6H2O (which gives 1/3) but does match the boehmite pathway 2Al + 4H2O -> 2AlOOH + 3H2
(b = 0.5), which is consistent with that paper modelling diffusion "through the AlOOH layer".
We adopt b = 0.5 with the boehmite intermediate and state this explicitly.

## 4. Hoopes CO2 figure is internally inconsistent — see energy_system.csv.

## 5. Akbar & Unal (2025), Chemical Papers — PDF NOT AVAILABLE
Cited by the white paper for 1.245 L H2/g Al, 96% conversion, 896 L from 600 g Al
(theoretical 933.33 L). Only the 1245 mL/g figure is independently confirmed
(Martinez-Vargas 2026, Sec. 4). The continuous-flow point cannot be verified.
