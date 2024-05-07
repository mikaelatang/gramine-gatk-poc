<h1 align="center"> Executing GATK ValidateSamFile Command Using Gramine SGX PoC </h1>

The purpose of this proof of concept (PoC) is to demonstrate that GATK commands can be executed within a trusted execution environment through Gramine. Specifically, the GATK command ValidateSamFile was tested in this PoC with an execution time of around 16 minutes within the SGX enclave compared to the approximate 3 minute execution time outside of the enclave. This PoC provides a foundation for processing genomics data in a secure manner.<br>
Note that there are a few insecure settings in the Gramine manifest for the purpose of testing; these will need to be removed in production.

## Testing Specs
Type:   Azure confidential computing SGX virtual machine<br>
Size:   Standard DC8 v2 (8 vCPUs, 32 GiB RAM)<br>
OS:     Linux (Ubuntu 20.04)

## Pre-requisites

- Machine with Intel SGX (ideally SGX2 as it provides support for EXITINFO which is required for secure execution of java applications)
- [Install gsutil](https://cloud.google.com/storage/docs/gsutil_install) to pull input file from Google Cloud Storage (GCS) via CLI

## Running the PoC

1. Git clone this repository: `git clone  https://github.com/mikaelatang/gramine-gatk-poc.git`
2. Enter the cloned repository: `cd gramine-gatk-poc`
3. Make a new directory called 'inputs': `mkdir inputs`
4. Copy input file from GCS to local machine<br>
   a. Using gsutil: `gsutil cp gs://gatk-test-data/wgs_bam/NA12878_24RG_hg38/NA12878_24RG_small.hg38.bam inputs/`<br>
   *OR*<br>
   b. Click [here](https://storage.googleapis.com/gatk-test-data/wgs_bam/NA12878_24RG_hg38/NA12878_24RG_small.hg38.bam) to download input file to the local machine and move it into the newly created 'inputs' folder<br>
6. Run the Docker container with image containing PoC: `docker compose up`
7. Remove the Docker container once finished: `docker rm gramine-gatk`

Below are screenshots of what a successful execution of the PoC should look like:

![Docker command, Gramine enclave initiation and `./gatk list` results](https://github.com/mikaelatang/gramine-gatk-poc/blob/main/images/first-part.png)
![ValidateSameFile expected output](https://github.com/mikaelatang/gramine-gatk-poc/blob/main/images/second-part.png)

## Useful Resources

[Gramine GitHub](https://github.com/gramineproject/gramine)<br>
[GATK GitHub](https://github.com/broadinstitute/gatk)<br>
[GCS folder](https://console.cloud.google.com/storage/browser/gatk-test-data/wgs_bam/NA12878_24RG_hg38?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22))&organizationId=548622027621&project=broad-dsde-outreach&prefix=&forceOnObjectsSortingFiltering=false) for input file
