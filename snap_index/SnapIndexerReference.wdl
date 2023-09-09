version 1.0

import "../biowdl_tasks/snap_aligner.wdl" as snap_aligner
import "../tasks/squashfs.wdl" as squashfs
import "../tasks/download.wdl" as download

workflow SnapIndexerReference {
    input {
        String reference_fa
    }

    # Download reference fa file from web
    call download.download_ncbi_reference as dl {
        input:
            url = reference_fa
    }

    # snap aligner has indexer option
    call snap_aligner.snap_indexer as snap_indexer {
        input:
            fa = dl.reference_fa
    }

    # Create two reference filesystems: reference_fa and snap_index
    call squashfs.create_squashfs as squash_fa {
        input:
            f = dl.reference_fa,
            fs = basename(reference_fa, ".gz") + ".squashfs"
    }
    call squashfs.create_squashfs as squash_snap_index {
        input:
            f = snap_indexer.snap_index,
            fs = basename(reference_fa, ".fa.gz") + "_snap.squashfs"
    }

    output {
        File fs_fa = squash_fa.filesystem
        File fs_snap = squash_snap_index.filesystem
    }


}

