version 1.0

task DownloadNcbiReference {
    input {
        String url
        String outputFile = basename(url)
        Int cpu = 8
        String memory = "16G"
        String dockerImage = "alpine:latest"
        String dockerShell = "/bin/sh"
    }
    command <<<
        wget -q -O - \
            ~{url} | \
            gunzip -c | \
            gzip -c > ~{outputFile}
    >>>

    output {
        File referenceFasta = "~{outputFile}"
    }
    runtime {
        docker: dockerImage
        cpu: cpu
        memory: memory
        docker_shell: dockerShell
    }

    
}

