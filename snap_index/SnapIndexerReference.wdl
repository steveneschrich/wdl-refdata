version 1.0

import "../biowdl_tasks/snap_aligner.wdl" as snapAligner
import "../tasks/squashfs.wdl" as squashfs
import "../tasks/download.wdl" as download

workflow SnapIndexerReference {
    input {
        String referenceFasta
    }

    # Download reference fa file from web
    call download.DownloadNcbiReference as dl {
        input:
            url = referenceFasta
    }

    # snap aligner has indexer option
    call snapAligner.SnapIndexer as snapIndexer {
        input:
            inputFasta = dl.referenceFasta
    }

    # Create two reference filesystems: reference_fa and snap_index
    call squashfs.CreateSquashfs as squashFasta {
        input:
            source = dl.referenceFasta,
            filesystem = basename(referenceFasta, ".gz") + ".squashfs"
    }
    call squashfs.CreateSquashfs as squashSnapIndex {
        input:
            source = snapIndexer.snapIndex,
            filesystem = basename(referenceFasta, ".fa.gz") + "_snap.squashfs"
    }

    output {    
        File filesystemFasta = squashFasta.filesystem
        File filesystemSnap = squashSnapIndex.filesystem
    }


}

