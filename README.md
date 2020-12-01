# EDCTP-Ghana
EDCTP-Ghana SARS-CoV2-Sequencing Project

See the wiki for more details!





Workflow steps:






### Upload Data to Shared Google Drive 

Using `rclone` the last step in the pipeline is uploading files to google drive. We upload the raw fastq, the mapped bam, the fasta and some other files.

We use the shared drive `EDCTP-Ghana` and upload results into the folder `RESULTS`

The directory structure is as follows:

`EDCTP-Ghana/RESULTS/<nanopore_run_id>/`

Commands:

`rclone copy <SAMPLE>.sorted.mapped.bam edctp-ghana:RESULTS/<nanopore_run_id>/`
