include { convert_pyramid } from './modules/pyramid'

workflow {
    files = channel.fromPath(params.data)
        .splitCsv(header: true)
        .map { row ->
            tuple(
                file(row.wsi)
            )
        }
    convert_pyramid(files)
}