# TNT CTB Export

Source CTB: `0.RELEASE\TNT_PLOT_STYLE_2026.ctb`

Generated files:

- TNT_PLOT_STYLE_2026.raw.txt: decompressed CTB text for full inspection.
- TNT_PLOT_STYLE_2026.ctb.csv: one row per CTB color style.
- TNT_LAYER_STANDARD.csv: layer standard parsed from `0.RELEASE\TNT_PACKAGE_00_SYSTEM_ALL.lsp`.
- TNT_LAYER_CTB_SYNC.csv: layer table joined with CTB by ACI color.

Counts:

- CTB styles: 255
- TNT layers: 51
- TNT layer colors used: 21

Notes:

- CTB is color-dependent. Layer synchronization is checked through each layer's ACI color.
- CtbLineweightCode is the raw CTB lineweight index.
- CtbLineweightMm maps that index to AutoCAD valid lineweight values in mm.
- CtbColorPolicy, CtbLinetypeCode, and other code columns are kept raw so we do not hide CTB internals behind an uncertain label.