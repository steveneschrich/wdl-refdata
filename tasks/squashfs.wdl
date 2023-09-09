version 1.0

task create_squashfs {

    input {
        File f
        String fs = "fs.squashfs"

        String dockerImage = "dockerhub.moffitt.org/hpc/squashfs-tools:4.5"
        Int cpu = 8
        String memory = "16G"
    }

    command <<<

        if [ ! -z "`echo ~{f} | grep '.tar.gz$'`" ]; then
            echo "tar file detected: ~{f}."
            echo "Extracting tar file to image"
            zcat ~{f} | \
                mksquashfs - ~{fs} \
                    -keep-as-directory \
                    -no-strip \
                    -tar \
                    -processors ~{cpu} \
                    -mem ~{memory}
        elif [ ! -z "`echo ~{f} | grep '.tar$'`" ]; then
            echo "tar file detected: ~{f}."
            echo "Extracting tar file to image"
            cat ~{f} | \
                mksquashfs - ~{fs} \
                    -keep-as-directory \
                    -no-strip \
                    -tar \
                    -processors ~{cpu} \
                    -mem ~{memory}
        else
            mksquashfs ~{f} ~{fs} \
                -keep-as-directory \
                -processors ~{cpu} \
                -mem ~{memory}
        fi
        
    >>>

    output {
        File filesystem = "~{fs}"
    }
    runtime {
        docker: dockerImage
        cpu: cpu
        memory: memory
    }
}
