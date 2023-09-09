# wdl-refdata
This is a repository for creating reference files/directories for genomics-related workflows. The creation occurs via WDL (workflow description language). The reference files are processed and wrapped into squash filesystems that can be mounted within containers when running analyses. Details on the process are below.

## Reference Data
Most genomics aligners require the genome of the organism being studied in order to align raw reads from experimental conditions into the framework of the organism. We typically use the human genome reference and align human subject sequence to this reference, in order to understand variation in the human population. However, any species could be used.

This repository attempts to encode the details and processing steps of building these reference files for use in these tools. Often these tools perform some form of indexing to make the genome easier to navigate. The directories in this repository address creating reference files for these tools. Our bias is to human reference, however the workflows are designed to be as generic as possible so that alternative genomes could be used to generate reference files.

## Workflows
Each reference file type is implemented as a WDL workflow (or workflows). WDL is designed to modularize processing tasks and enable structured implementation of multi-step processes. Here we lean heavily on a modified biowdl repository to implement the various tasks associated with building a reference file. For instance, the `snap_aligner` index requires the use of ncbi downloads, the snap aligner and a few other miscellaneous tools. 

## Output
Each workflow generates the needed reference files associated with a particular tool. To make this as portable as possible, we bundle these files together into a single 'squashfs' image. All images should end in `.squashfs` indicating this format.