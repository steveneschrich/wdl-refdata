version 1.0

task download_ncbi_reference {
    input {
        String url
        String output_file = basename(url)
        Int cpu = 8
        String memory = "16G"
        String dockerImage = "alpine:latest"
        String dockerShell = "/bin/sh"
    }
    command <<<
        wget -q -O - \
            ~{url} | \
            gunzip -c | \
            gzip -c > ~{output_file}
    >>>

    output {
        File reference_fa = "~{output_file}"
    }
    runtime {
        docker: dockerImage
        cpu: cpu
        memory: memory
        docker_shell: dockerShell
    }

    
}

