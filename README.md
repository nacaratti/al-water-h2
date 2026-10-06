# From Particle to Plant: a multiscale model of on-demand hydrogen from the aluminium–water reaction

Code, data and figures accompanying the manuscript

> **A Multiscale Kinetic and Techno-Economic Model of On-Demand Hydrogen Generation by the
> Aluminum–Water Reaction** — submitted to *Processes* (MDPI).
> Authors and citation details will be added on publication.

The aluminium–water reaction stores hydrogen chemically and releases it at ambient pressure,
but the literature on it is split by scale: particle kinetics, reactor demonstrations and
life-cycle energy figures have never been connected by a single model. This repository
contains a three-level model that makes that connection, implemented entirely in MATLAB,
together with every script needed to reproduce the fits, numbers and figures reported in the
paper.

---

## What was done

### Level 1 — Particle scale (`matlab/modelo/simular_particula.m`, `matlab/ajuste/`)

- The **modified shrinking-core model** of Martínez-Salazar et al. (2025), derived for a flat
  plate, was extended to **spherical geometry**. Diffusional (product-layer) and chemical
  (surface-reaction) resistances act **in series**, so the model moves continuously between
  regimes instead of switching between them.
- Product-layer densification is described through a diffusivity that falls with the
  product deposited per unit core area, *D*(Γ), and an **induction period** is fitted
  explicitly.
- The model was fitted to the published sieve series of Martínez-Vargas et al. (2026)
  (recycled Al powder, 1.0 M NaOH, 55 °C), **using only mass-independent observables**
  (apparent rate constant *k_d* and reaction time *t_r*), because the charged aluminium mass
  is not reported in the source (see `data/notes.md`).
- The residual surface is multimodal, so a **60-start global search** was used
  (`busca_multipartida.m`).
- **Identifiability** was checked by eigen-analysis of *J*ᵀ*J* and profile likelihood
  (`identificabilidade.m`): the surface rate constant *k*₁ and the densification
  coefficient κ are correlated and should be quoted as a pair.
- A **joint fit** including peak flow (`ajuste_conjunto.m`) was run under the two possible
  interpretations of the unreported mass, to show what each would imply.

### Level 2 — Reactor scale (`simular_batelada.m`, `simular_continuo.m`, `ajuste/sensibilidade.m`)

- **Population balance** over a log-normal particle-size distribution, coupled to
  **alkali (NaOH) consumption** and an **energy balance with boiling**.
- Batch and **continuous-feed** operation for a 1 kW PEM fuel-cell duty.
- Sensitivity of the water penalty to the lumped heat-loss coefficient *UA* and to the
  powder size span; derivation of the analytic threshold *UA*_crit.

### Level 3 — System scale (`energia_kg_h2.m`, `energia_com_ciclo.m`, `custo_kg_h2.m`, `ajuste/resumo_sistema.m`)

- Primary energy, CO₂ and feedstock cost per kg H₂ as a function of the **external scrap
  fraction φ** of the aluminium feedstock, against a water-electrolysis benchmark
  (53.4 kWh/kg H₂) and steam-methane reforming.
- A separate variable *r* for **closing the reaction's own loop** (recycling the Al(OH)₃
  byproduct through Bayer + Hall–Héroult), to show it is not equivalent to external scrap.
- A bottom-up **cost screening** of aluminium and NaOH, including NaOH recovery.

### Figures

Every figure is produced in MATLAB and saved as an editable `.fig` file, plus vector `.pdf`
and 300 dpi `.png` versions. The figure scripts read the data in `matlab/dados/*.mat`, which
`exportar_dados.m` recomputes from the model.

---

## Key results

| Quantity | Value |
|---|---|
| Fit to published apparent rate constants *k_d* | R² = 0.97 |
| Fit to published reaction times *t_r* | R² = 0.94 |
| Induction period | 9.7 ± 1.4 min |
| Size exponent of *k_d* over 180–500 µm (model / measured) | −1.60 / −1.34 |
| Chemical ↔ diffusion crossover | ≈ 10–100 µm |
| Reported cumulative-yield optimum (363 µm) | **not reproduced** by any particle-scale mechanism tested |
| Continuous feed for 1 kW (d₅₀ = 6.8 µm) | ≈ 8.9 g Al/min |
| Boil-off / stoichiometric water at *UA* = 25 W/K | ≈ 2.6× |
| Heat-rejection threshold *UA*_crit | ≈ 51 W/K |
| Break-even external scrap fraction φ* vs electrolysis | 0.74 |
| CO₂ at φ* | ≈ 30 kg CO₂ / kg H₂ |
| Bayer-loop closure beyond which no φ reaches break-even, *r*_crit | 0.46 |
| Al-only feedstock cost (φ = 0) vs literature top-down estimate | US$ 20.0 vs 21 /kg H₂ (within 5 %) |
| Unrecovered NaOH cost | ≈ US$ 372 /kg H₂ (≈ 37× the aluminium cost at φ*) |

In short: the particle kinetics are well described, but **system viability is governed by
supply-chain composition (external scrap) and alkali recovery**, not by further gains in
intrinsic kinetics. All thresholds are screening values under the stated literature inputs
and need reactor-scale and process data to be confirmed.

---

## Repository layout

```
.
├── matlab/
│   ├── gerar_todas.m            # draws every figure -> matlab/fig/*.fig, *.pdf, *.png
│   ├── exportar_dados.m         # recomputes the data behind every figure -> matlab/dados/*.mat
│   ├── fig1_scales.m ... figS1_designmap.m   # one script per figure
│   ├── modelo/                  # the model
│   │   ├── constantes.m             # all physical, design and literature constants
│   │   ├── simular_particula.m      # Level 1: spherical shrinking core, series resistances, densification
│   │   ├── taxa_u.m, raio_casca.m   # Level 1 right-hand side and shell geometry
│   │   ├── kd_aparente.m, F_difusao.m, tempo_reacao.m   # observables as defined in the source
│   │   ├── prever_particula.m, residuos_particula.m     # predictions and weighted residuals
│   │   ├── simular_batelada.m       # Level 2: population balance, alkali activity, energy balance
│   │   ├── simular_continuo.m       # Level 2: continuous feed, boiling and make-up water
│   │   ├── regime_permanente.m      # feed rate for 1 kW, boil-off ratio, peak temperature
│   │   ├── energia_kg_h2.m, co2_kg_h2.m, energia_com_ciclo.m   # Level 3: energy and CO2
│   │   ├── phi_equilibrio.m, phi_equilibrio_ciclo.m            # break-even scrap fractions
│   │   ├── custo_kg_h2.m, dimensionar_reator.m                 # cost and 1 kW sizing
│   │   └── parametros_ajuste.m      # loads the fitted parameters
│   ├── ajuste/                  # parameter estimation and analysis scripts
│   │   ├── busca_multipartida.m     # 60-start global search -> dados/parametros_ajuste.mat
│   │   ├── ajustar_particula.m      # local fit and parameter standard errors
│   │   ├── identificabilidade.m     # eigen-analysis of J^T J and profile likelihood
│   │   ├── ajuste_conjunto.m        # joint fit under the two mass interpretations
│   │   ├── resultados_nivel1.m      # consolidates Level 1 -> dados/resultados_nivel1.json
│   │   ├── sensibilidade.m          # Level 2 sensitivity to UA and size span
│   │   └── resumo_sistema.m         # Level 3 energy, CO2, sizing and cost numbers
│   ├── auxiliares/              # shared plotting helpers (style, colours, saving)
│   ├── dados/                   # figure data (*.mat), fitted parameters, Level 1 results
│   └── fig/                     # generated figures (.fig editable, .pdf, .png)
├── data/                        # literature data, each value traced to its source
│   ├── notes.md                 # data provenance and caveats -- read this first
│   ├── bibliography_provenance.md
│   └── *.csv
├── figures/                     # PDF figures as used in the manuscript
└── LICENSE
```

### File ↔ figure number in the paper

| File | Paper | Content |
|---|---|---|
| `fig1_scales` | Figure 1 | The three model scales |
| `fig2_fit` | Figure 2 | Fit to the three sieve cuts |
| `fig3_size` | Figure 3 | Size scaling, regime crossover, absent yield optimum |
| `fig4_designcurve` | Figure 4 | Residence time vs particle size |
| `fig5_design` | Figure 5 | Continuous feed and the water penalty |
| `fig5b_sensitivity` | Figure 6 | Water penalty as a threshold in *UA* |
| `fig6_energy` | Figure 7 | Energy break-even and carbon intensity |
| `fig7_bayerloop` | Figure 8 | Bayer-loop closure vs external scrap |
| `fig8_cost` | Figure 9 | Feedstock cost and NaOH recovery |
| `figS1_designmap` | Supplementary | Conversion design map |

---

## Reproducing the results

Requires MATLAB R2019b or newer (`tiledlayout`, `xline`/`yline`). The model, the figure data
and the figures need no toolboxes. The parameter-estimation scripts in `ajuste/`
(`busca_multipartida`, `ajustar_particula`, `identificabilidade`, `ajuste_conjunto`,
`resultados_nivel1`) use `lsqnonlin` from the **Optimization Toolbox**.

### Figures

```matlab
cd matlab
gerar_todas                     % saves fig/*.fig (editable), fig/*.pdf and fig/*.png
openfig('fig/fig3_size.fig')    % open any figure later for editing
```

Each `figX_*.m` can also be run on its own. Colours and fonts are defined once in
`auxiliares/estilo_graficos.m` and `auxiliares/nova_figura.m`.

### Recomputing the figure data from the model

```matlab
cd matlab
exportar_dados                  % all figures (well under a minute)
exportar_dados('fig3_size')     % or a single one
gerar_todas
```

All figures use the fitted parameters stored in `dados/parametros_ajuste.mat`.

### Parameter estimation and analysis

```matlab
cd matlab/ajuste
busca_multipartida              % global search (slow); overwrites dados/parametros_ajuste.mat
resultados_nivel1               % Level 1 summary and blind tests -> dados/resultados_nivel1.json
identificabilidade
ajuste_conjunto
sensibilidade                   % Level 2 sensitivity table
resumo_sistema                  % Level 3 numbers
```

The random starting points of the global search are seeded (`rng(20260902)`), so a rerun is
repeatable; the stored parameters are the global optimum used in the paper.

---

## Data sources and caveats

All input data come from published literature; each value in `data/*.csv` is traced to its
source, and `data/notes.md` documents the provenance issues found, in particular:

- **Martínez-Vargas et al. (2026), *Hydrogen* 7, 55** — particle-size series used for the fit.
  The charged aluminium mass is not reported, which is why only mass-independent observables
  were fitted and why the cumulative-yield optimum is treated as a hypothesis, not a target.
- **Martínez-Salazar et al. (2025), *Processes* 13, 798** — the flat-plate modified
  shrinking-core model extended here; stoichiometric coefficient *b* = 0.5 (boehmite route).
- **Kaur & Verma (2024)** — energy, CO₂ and cost anchors for the system scale; one printed
  CO₂ figure is internally inconsistent and is recomputed in
  `matlab/modelo/co2_hoopes_recalculado.m`.

Known limitations (discussed in the paper): the activation energy is fixed rather than
fitted; *UA* is not identifiable from the data (but only its threshold matters); powder
activation energy and consumables are not included; the cost model covers aluminium and NaOH
only and is a feedstock floor, not a levelized cost of hydrogen.

---

## License

Released under the [MIT License](LICENSE).

## Citation

If you use this code, please cite the paper (reference to be added on publication).
