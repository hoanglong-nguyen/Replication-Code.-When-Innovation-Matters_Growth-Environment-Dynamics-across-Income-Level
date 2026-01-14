# Replication Package: WHEN INNOVATION MATTERS: GROWTH–ENVIRONMENT DYNAMICS ACROSS INCOME LEVELS IN ASIA AND AFRICA

**Authors:** Tu Thuy Anh, Nguyen Hoang Long, Chu Thi Mai Phuong

**Journal:** SAGE Open (In Press)

**DOI:** 10.1177/21582440251407881

---

## DISCLAIMER

This replication package is provided as a reference for the coding methodology employed in the study. The code provided here represents an updated version (January 2026) that may produce slightly different results from the published paper due to data updates from the World Bank. The original study dataset covered 63 countries, while this updated code covers 48 countries due to data availability at the time of code execution.

**Important:** This code should be used solely as a reference for coding techniques and analytical approaches of author Hoang-Long NGUYEN. It does not represent the official replication package for final published results.

---

## Overview

**Analysis Period:** 2000-2023

**Sample:** 48 countries from Asia and Africa (data availability as of January 2026)

**Software Required:** Stata 17 or higher

---

## Data Sources

### Dataset 1: World Development Indicators (WDI)

**Source:** World Bank

**Access:** Public, accessible directly from Stata using `wbopendata` command

**Variables Used:**
- GDP per capita (constant 2015 USD)
- Labor force participation rate
- Gross capital formation (% of GDP)
- Renewable energy consumption (% of total final energy consumption)

**Citation:** World Bank. World Development Indicators. Available at: https://databank.worldbank.org/source/world-development-indicators

**Note:** Data is downloaded directly via Stata. No separate file provided.

---

### Dataset 2: National Footprint and Biocapacity Accounts

**Source:** Global Footprint Network

**Access:** Public (downloadable from website)

**Variables Used:**
- Ecological Footprint per capita (global hectares)
- Biocapacity per capita (global hectares)

**Citation:** Lo, K., Miller, E., Dworatzek, P., Basnet, N., Silva, J., Van Berkum, J. L., Halldórsdóttir, R. B., & Dyck, M. D. R. (2025). National Ecological Footprint and Biocapacity Accounts, 2025 Edition. Data and metadata version 1.0. Produced for Footprint Data Foundation by researchers at York University and University of Iceland. https://footprint.info.yorku.ca/data/

**Access Instructions:** 
- Direct download: https://data.footprintnetwork.org/
- A pre-downloaded and formatted version is included in this package for convenience

**Included File:** `Footprint_Biosiversity_GFN.xlsx`

---

### Dataset 3: Total Patent Applications by Application Office

**Source:** World Intellectual Property Organization (WIPO)

**Access:** Public (downloadable from website)

**Variables Used:**
- Total patent applications (direct and PCT national phase entries)

**Citation:** World Intellectual Property Organization (WIPO). WIPO IP Statistics Data Center. Available at: https://www3.wipo.int/ipstats/

**Access Instructions:**
- Direct download: https://www3.wipo.int/ipstats/index.htm
- A pre-downloaded and formatted version is included in this package for convenience

**Included File:** `Total patent applications_WIPO.xlsx`

---

## File Structure

```
/
├── README.md                                 (This file)
├── 01_data_preparation.do                      (Data download and cleaning)
├── 02_main_analysis.do                       (Main regression analysis)
├── 03_robustness_tests.do                      (Model specification tests)
├── Footprint_Biosiversity_GFN.xlsx             (Ecological footprint data)
└── Total patent applications_WIPO.xlsx        (Patent data)
```

---

## Computational Requirements

**Software:**
- Stata 17 or higher
- Stata/MP recommended for faster execution

**Required Stata Packages:**
The code will automatically install required packages if not present. Key packages include:
- `wbopendata` (for World Bank data access)
- `estout` or `outreg2` (for table output)
- `xtset` (panel data commands - included in Stata)

**System Requirements:**
- Minimum 4GB RAM
- 500MB free disk space

## Data Availability Statement

- **World Development Indicators:** Publicly available from World Bank, accessed via Stata
- **National Footprint and Biocapacity Accounts:** Publicly available from Global Footprint Network, pre-downloaded version included
- **Patent Data:** Publicly available from WIPO, pre-downloaded version included

All data sources are freely accessible and do not require registration or fees.

---

## License

The code in this replication package is provided for academic and research purposes. 

**Data Licenses:**
- World Development Indicators: CC BY 4.0 (World Bank)
- Global Footprint Network Data: Creative Commons Attribution-ShareAlike 4.0 International License
- WIPO Patent Data: Public domain

Please cite the original paper and data sources when using this replication package.

---

## Citation

When using this replication package, please cite:

Tu Thuy Anh, Nguyen Hoang Long, & Chu Thi Mai Phuong. (2025). When Innovation Matters: Growth–Environment Dynamics Across Income Levels in Asia and Africa. *SAGE Open*. https://doi.org/10.1177/21582440251407881

---

## Contact Information

For questions about this replication package, please contact:

**Nguyen Hoang Long**
[nhlong.work@proton.me]

**Note:** This replication package is maintained by Nguyen Hoang Long and represents coding methodology only. For questions about the published paper's final results, please contact all authors.

---

## Version History

- **Version 1.0 (January 2026):** Initial release
  - Updated data from World Bank (January 2026)
  - 48 countries covered
  - Stata 17

---

## Acknowledgments

Data provided by:
- World Bank - World Development Indicators
- Global Footprint Network - National Footprint and Biocapacity Accounts
- World Intellectual Property Organization (WIPO) - Patent Statistics

---

**Last Updated:** January 2026

