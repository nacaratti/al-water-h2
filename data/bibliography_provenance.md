# Bibliography provenance (detailed)

Full verification notes for every entry added in the Fase D bibliography-expansion pass.
`refs.bib` keeps only short notes (to avoid bloating the printed reference list and
causing typesetting warnings); this file is the complete record.

## Corrected / previously UNVERIFIED entries

**razavitousi2016** — `Modification of the Shrinking Core Model for Hydrogen Generation
by Reaction of Aluminum Particles with Water`, IJHE 41:87–93 (2016),
DOI 10.1016/j.ijhydene.2015.11.080. Verified via publisher record (WebSearch); matches
Martínez-Salazar et al.'s ref. [23] (title, volume 41, starting page 87). This REPLACES a
previous, incorrect bib entry (`razavitousi2013`) that had a fabricated/conflated title
and no verified DOI. Paywalled (ScienceDirect abstract page only); no PDF retained.

**razavitousi2014** — `Mechanism of Corrosion of Activated Aluminum Particles by Hot
Water`, Electrochimica Acta 127:95–105 (2014), DOI 10.1016/j.electacta.2014.02.024. A
DISTINCT paper by the same authors, cited as ref. [62] by Kaur & Verma for SEM imaging
of ball-milled particles. Not to be conflated with razavitousi2016. Paywalled.

**akbar2025** — `On-Demand Hydrogen Production and Storage via the Aluminum-Water
Reaction: A Strategic Evaluation`, Chemical Papers 79:6975–6983 (2025),
DOI 10.1007/s11696-025-04238-7. Full authors: Demiral Akbar (OSTİM Technical University)
and Dogukan Unal (Industrial Project Engineering Consultancy). Verified via the openly
licensed preprint (Research Square, DOI 10.21203/rs.3.rs-6123353/v1, posted 10 April
2025, CC-BY 4.0), which confirms author affiliations and matches the published version's
abstract. **PDF retained**: `referencias/Akbar_2025_OnDemandHydrogenAluminumWaterReaction.pdf`
(the CC-BY preprint; content matches the version of record).

## Duplicate-DOI error caught in Kaur & Verma's own reference list

Kaur & Verma's refs. [39] and [251] print two DIFFERENT titles against the SAME DOI
(10.1016/j.ijhydene.2023.04.068). Independent web search resolved this:

- **kandasamy2024** (the DOI's actual paper) — `Hydrogen Production Using
  Aluminum-Water Splitting: A Combined Experimental and Theoretical Approach`, IJHE
  52:202 (2024), DOI 10.1016/j.ijhydene.2023.04.068 confirmed correct via WebSearch
  (activation barriers 7.72–61.75 kJ/mol reported for the three reaction steps).
- **mutlu2024** (Kaur & Verma's ref. [251], wrongly attached to the DOI above) —
  `Optimization of Aluminum Hydrolysis Reactions and Reactor Design for Continuous
  Hydrogen Production Using Aluminum Wire Feeding`, IJHE 52:1390 (2024). Title/
  journal/volume/starting-page independently confirmed via WebSearch (continuous
  aluminium-wire-feeding reactor, up to 350 mL/min H2, 5–30 W fuel cell demo, RSM
  optimization of temperature/NaOH concentration/wire diameter). The correct DOI for
  THIS title could not be independently confirmed (ScienceDirect blocks automated
  fetch); left blank in refs.bib rather than guessed.

## New references mined from existing sources' bibliographies

Tier A = independently verified by fresh web search (title/journal/volume/pages checked
against the DOI, not just trusted from the citing source).
Tier B = DOI taken as printed in the citing source's own reference list, not
independently re-verified beyond that. Two Tier-B entries needed a DOI suffix
reconstructed from the journal's standard article-number pattern because the source's
OCR-extracted reference list truncated it (flagged individually below).

| Key | Source list | Ref # | Tier | Note |
|---|---|---|---|---|
| razavitousi2014b | kaur2024 | [60] | B | ball milling promotion |
| yolcular2017 | kaur2024 | [176] | B | NaCl-assisted milling |
| deng2007 | kaur2024 | [144] | B | continuous reaction mechanism |
| yuan2016 | kaur2024 | [87] | B | Ga-In liquid alloy |
| xu2019 | kaur2024 | [88] | B | liquid metal + LCA |
| su2021 | kaur2024 | [166] | B | DOI suffix reconstructed (truncated in source) |
| liu2014 | kaur2024 | [183] | B | ball milled + hydride |
| liu2015rsc | kaur2024 | [185] | B | ball milled Al/CaH2 |
| jia2014 | kaur2024 | [188] | B | Al/Ni/NaCl |
| chen2020 | kaur2024 | [192] | B | Al-Bi(OH)3-NaCl |
| zhu2021 | kaur2024 | [234] | B | melting-crushing-milling |
| grjotheim1977 | kaur2024 | [260] | B | Hall-Héroult book |
| farjana2019 | kaur2024 | [262] | **A** | independently verified |
| frary1948 | kaur2024 | [263] | B | historical electrolytic Al |
| mehmeti2018 | kaur2024 | [272] | B | DOI suffix reconstructed (truncated in source) |
| gai2024 | akbar2025 (in-text) | — | B | review of Al-water strategies |
| gunathilake2024 | akbar2025 (in-text) | — | **A** | independently verified |
| osman2021 | akbar2025 (in-text) | — | B | H2 review |
| yang2023clean | akbar2025 (in-text) | — | B | H2 storage/transport review |
| akyildiz2024 | akbar2025 (in-text) | — | B | Al hydrolysis, different solutions |
| gao2023energies | akbar2025 (in-text) | — | B | Al-based fuels review |

Two candidates NOT dropped in: [191] (Al-Bi-NaCl, Mater. Res. Express, similar to
chen2020, redundant) and [197] (Al-CaH2-salt milling, similar to liu2015rsc, redundant)
were skipped as duplicative of nearby entries already included, to keep the added set at
~22 rather than padding with near-identical activation-chemistry variants.
