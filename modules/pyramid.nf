process convert_pyramid {
    errorStrategy 'ignore'
    tag "${wsi}"
    publishDir "${params.outdir}", mode:"copy"
    input:
    path(wsi)
    output:
    path("result/${wsi}")
    script:
    """
    mkdir -p result/
    vips tiffsave ${wsi} result/${wsi} \\
    --tile --pyramid --compression jpeg --tile-width 256 \\
    --tile-height 256 --bigtiff --xres 20000 --yres 20000 \\
    --resunit cm
    """
    stub:
    """
    mkdir -p result
    touch result/${wsi}
    """
}