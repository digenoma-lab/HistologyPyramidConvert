process convert_pyramid {
    errorStrategy 'ignore'
    tag "${wsi}"
    publishDir "${params.outdir}", mode:"copy"
    input:
    path(wsi)
    output:
    path("result/${wsi}")
    script:
    //Due to a VIPS error (when using resunit cm), the resolution must be set to 1/10 of the desired resolution.
    //For x20 images (res: 20000), use a xres and yres of 2000 to obtain an MPP of 0.5.
    """
    mkdir -p result/
    vips tiffsave ${wsi} result/${wsi} \\
    --tile --pyramid --compression jpeg --tile-width 256 \\
    --tile-height 256 --bigtiff --xres 2000 --yres 2000 \\
    --resunit cm
    """
    stub:
    """
    mkdir -p result
    touch result/${wsi}
    """
}