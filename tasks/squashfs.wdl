version 1.0

task CreateSquashfs {

    input {
        File source
        String filesystem = "fs.squashfs"

        String dockerImage = "dockerhub.moffitt.org/hpc/squashfs-tools:4.5"
        Int cpu = 8
        String memory = "16G"
    }

    command <<<

        if [ ! -z "`echo ~{source} | grep '.tar.gz$'`" ]; then
            echo "tar file detected: ~{source}."
            echo "Extracting tar file to image"
            zcat ~{source} | \
                mksquashfs - ~{filesystem} \
                    -keep-as-directory \
                    -no-strip \
                    -tar \
                    -processors ~{cpu} \
                    -mem ~{memory}
        elif [ ! -z "`echo ~{source} | grep '.tar$'`" ]; then
            echo "tar file detected: ~{source}."
            echo "Extracting tar file to image"
            cat ~{source} | \
                mksquashfs - ~{filesystem} \
                    -keep-as-directory \
                    -no-strip \
                    -tar \
                    -processors ~{cpu} \
                    -mem ~{memory}
        else
            mksquashfs ~{source} ~{filesystem} \
                -keep-as-directory \
                -processors ~{cpu} \
                -mem ~{memory}
        fi
        
    >>>

    output {
        File filesystem = "~{filesystem}"
    }
    runtime {
        docker: dockerImage
        cpu: cpu
        memory: memory
    }
}
