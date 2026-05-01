# HistologyPyramidConvert

A [Nextflow](https://www.nextflow.io/) pipeline that converts standard histology **TIFF whole-slide images (WSI)** into **tiled pyramid TIFFs** (OME-style pyramid TIFF), suitable for viewers that expect zoom levels and tiles.

## What it does

For each row in the input CSV, the `convert_pyramid` process runs [libvips](https://www.libvips.org/) (`vips tiffsave`) inside a container and writes a TIFF with:

- Multi-resolution pyramid (`--pyramid`)
- 256×256 tiles (`--tile-width`, `--tile-height`)
- JPEG compression
- Large-file support (`--bigtiff`)
- Declared resolution 20000 pixels per cm in X and Y (`--xres`, `--yres`, `--resunit cm`)

Outputs are copied to the configured output directory (`publishDir`). If a task fails, the current strategy is `ignore` (remaining samples continue).

## Requirements

- **Nextflow** (compatible with this repository’s `main.nf`)
- **Singularity** / Apptainer (the `local` and `kutral` profiles use the OCI image via Singularity)
- Image: `oras://community.wave.seqera.io/library/libvips:8.17.3--73bbb05066bc0731` (set in `nextflow.config` for `convert_pyramid`)

## Input: CSV

**`--data`** must point to a **headered** CSV that includes a **`wsi`** column: path to the input TIFF for each case.

Example:

| wsi |
|-----|
| /path/to/case1.tif |
| /path/to/case2.tif |

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `--data` | Path to CSV with `wsi` column | *(required)* |
| `--outdir` | Published output directory | `../HE_pyramid/` |
| `--debug` | Reserved in config | `false` |

Execution reports (timeline, report, trace, DAG) are written under `${params.outdir}/pipeline_info/` with a timestamp.

## Running

Minimal example (adjust profile and paths for your environment):

```bash
nextflow run main.nf \
  -profile local \
  --data samples.csv \
  --outdir ./pyramid_output
```

For the **`kutral`** profile in `nextflow.config` (Slurm, queue `ngen-ko`, site-specific mounts and cluster options), use `-profile kutral` instead of `local`.

## Output

- One pyramid TIFF per valid CSV row under `--outdir`, following the process naming (`result/<wsi_basename>` as published).
- Nextflow run metadata in `pipeline_info/`.

## Process configuration

In `nextflow.config`, `convert_pyramid` is set to **10 GB** memory and **1 CPU**. Profiles bind `/mnt/beegfs/labs/`; adjust `singularity.runOptions` if your data live elsewhere.

## License

See the `LICENSE` file in this repository.
