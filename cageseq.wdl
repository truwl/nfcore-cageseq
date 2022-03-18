version 1.0

workflow cageseq {
	input{
		File samplesheet = "data/*R1.fastq.gz"
		String outdir = "./results"
		String? email
		Boolean? bigwig
		String aligner = "star"
		Int min_aln_length = 15
		String? genome
		File? fasta
		String igenomes_base = "s3://ngi-igenomes/igenomes/"
		Boolean? igenomes_ignore
		String? gtf
		String? star_index
		String? bowtie_index
		Boolean? save_reference
		Boolean? save_trimmed
		Boolean? trim_ecop
		Boolean? trim_linker
		Boolean? trim_5g
		Boolean? trim_artifacts
		String eco_site = "CAGCAG"
		String linker_seq = "TCGTATGCCGTCTTC"
		String artifacts_5end = "$projectDir/assets/artifacts_5end.fasta"
		String artifacts_3end = "$projectDir/assets/artifacts_3end.fasta"
		Boolean? remove_ribo_rna
		Boolean? save_non_ribo_reads
		String ribo_database_manifest = "$projectDir/assets/rrna-db-defaults.txt"
		Int min_cluster = 30
		Float tpm_cluster_threshold = 0.2
		Boolean? skip_initial_fastqc
		Boolean? skip_trimming
		Boolean? skip_trimming_fastqc
		Boolean? skip_alignment
		Boolean? skip_samtools_stats
		Boolean? skip_ctss_generation
		Boolean? skip_ctss_qc
		Boolean? help
		String publish_dir_mode = "copy"
		String? name
		String? email_on_fail
		Boolean? plaintext_email
		String max_multiqc_email_size = "25.MB"
		Boolean? monochrome_logs
		String? multiqc_config
		String tracedir = "./results/pipeline_info"
		String clusterOptions = "false"
		Int max_cpus = 16
		String max_memory = "128.GB"
		String max_time = "240.h"
		String custom_config_version = "master"
		String custom_config_base = "https://raw.githubusercontent.com/nf-core/configs/master"
		String? hostnames
		String? config_profile_description
		String? config_profile_contact
		String? config_profile_url

	}

	call make_uuid as mkuuid {}
	call touch_uuid as thuuid {
		input:
			outputbucket = mkuuid.uuid
	}
	call run_nfcoretask as nfcoretask {
		input:
			samplesheet = samplesheet,
			outdir = outdir,
			email = email,
			bigwig = bigwig,
			aligner = aligner,
			min_aln_length = min_aln_length,
			genome = genome,
			fasta = fasta,
			igenomes_base = igenomes_base,
			igenomes_ignore = igenomes_ignore,
			gtf = gtf,
			star_index = star_index,
			bowtie_index = bowtie_index,
			save_reference = save_reference,
			save_trimmed = save_trimmed,
			trim_ecop = trim_ecop,
			trim_linker = trim_linker,
			trim_5g = trim_5g,
			trim_artifacts = trim_artifacts,
			eco_site = eco_site,
			linker_seq = linker_seq,
			artifacts_5end = artifacts_5end,
			artifacts_3end = artifacts_3end,
			remove_ribo_rna = remove_ribo_rna,
			save_non_ribo_reads = save_non_ribo_reads,
			ribo_database_manifest = ribo_database_manifest,
			min_cluster = min_cluster,
			tpm_cluster_threshold = tpm_cluster_threshold,
			skip_initial_fastqc = skip_initial_fastqc,
			skip_trimming = skip_trimming,
			skip_trimming_fastqc = skip_trimming_fastqc,
			skip_alignment = skip_alignment,
			skip_samtools_stats = skip_samtools_stats,
			skip_ctss_generation = skip_ctss_generation,
			skip_ctss_qc = skip_ctss_qc,
			help = help,
			publish_dir_mode = publish_dir_mode,
			name = name,
			email_on_fail = email_on_fail,
			plaintext_email = plaintext_email,
			max_multiqc_email_size = max_multiqc_email_size,
			monochrome_logs = monochrome_logs,
			multiqc_config = multiqc_config,
			tracedir = tracedir,
			clusterOptions = clusterOptions,
			max_cpus = max_cpus,
			max_memory = max_memory,
			max_time = max_time,
			custom_config_version = custom_config_version,
			custom_config_base = custom_config_base,
			hostnames = hostnames,
			config_profile_description = config_profile_description,
			config_profile_contact = config_profile_contact,
			config_profile_url = config_profile_url,
			outputbucket = thuuid.touchedbucket
            }
		output {
			Array[File] results = nfcoretask.results
		}
	}
task make_uuid {
	meta {
		volatile: true
}

command <<<
        python <<CODE
        import uuid
        print("gs://truwl-internal-inputs/nf-cageseq/{}".format(str(uuid.uuid4())))
        CODE
>>>

  output {
    String uuid = read_string(stdout())
  }
  
  runtime {
    docker: "python:3.8.12-buster"
  }
}

task touch_uuid {
    input {
        String outputbucket
    }

    command <<<
        echo "sentinel" > sentinelfile
        gsutil cp sentinelfile ~{outputbucket}/sentinelfile
    >>>

    output {
        String touchedbucket = outputbucket
    }

    runtime {
        docker: "google/cloud-sdk:latest"
    }
}

task fetch_results {
    input {
        String outputbucket
        File execution_trace
    }
    command <<<
        cat ~{execution_trace}
        echo ~{outputbucket}
        mkdir -p ./resultsdir
        gsutil cp -R ~{outputbucket} ./resultsdir
    >>>
    output {
        Array[File] results = glob("resultsdir/*")
    }
    runtime {
        docker: "google/cloud-sdk:latest"
    }
}

task run_nfcoretask {
    input {
        String outputbucket
		File samplesheet = "data/*R1.fastq.gz"
		String outdir = "./results"
		String? email
		Boolean? bigwig
		String aligner = "star"
		Int min_aln_length = 15
		String? genome
		File? fasta
		String igenomes_base = "s3://ngi-igenomes/igenomes/"
		Boolean? igenomes_ignore
		String? gtf
		String? star_index
		String? bowtie_index
		Boolean? save_reference
		Boolean? save_trimmed
		Boolean? trim_ecop
		Boolean? trim_linker
		Boolean? trim_5g
		Boolean? trim_artifacts
		String eco_site = "CAGCAG"
		String linker_seq = "TCGTATGCCGTCTTC"
		String artifacts_5end = "$projectDir/assets/artifacts_5end.fasta"
		String artifacts_3end = "$projectDir/assets/artifacts_3end.fasta"
		Boolean? remove_ribo_rna
		Boolean? save_non_ribo_reads
		String ribo_database_manifest = "$projectDir/assets/rrna-db-defaults.txt"
		Int min_cluster = 30
		Float tpm_cluster_threshold = 0.2
		Boolean? skip_initial_fastqc
		Boolean? skip_trimming
		Boolean? skip_trimming_fastqc
		Boolean? skip_alignment
		Boolean? skip_samtools_stats
		Boolean? skip_ctss_generation
		Boolean? skip_ctss_qc
		Boolean? help
		String publish_dir_mode = "copy"
		String? name
		String? email_on_fail
		Boolean? plaintext_email
		String max_multiqc_email_size = "25.MB"
		Boolean? monochrome_logs
		String? multiqc_config
		String tracedir = "./results/pipeline_info"
		String clusterOptions = "false"
		Int max_cpus = 16
		String max_memory = "128.GB"
		String max_time = "240.h"
		String custom_config_version = "master"
		String custom_config_base = "https://raw.githubusercontent.com/nf-core/configs/master"
		String? hostnames
		String? config_profile_description
		String? config_profile_contact
		String? config_profile_url

	}
	command <<<
		export NXF_VER=21.10.5
		export NXF_MODE=google
		echo ~{outputbucket}
		/nextflow -c /truwl.nf.config run /cageseq-1.0.2  -profile truwl,nfcore-cageseq  --input ~{samplesheet} 	~{"--samplesheet '" + samplesheet + "'"}	~{"--outdir '" + outdir + "'"}	~{"--email '" + email + "'"}	~{true="--bigwig  " false="" bigwig}	~{"--aligner '" + aligner + "'"}	~{"--min_aln_length " + min_aln_length}	~{"--genome '" + genome + "'"}	~{"--fasta '" + fasta + "'"}	~{"--igenomes_base '" + igenomes_base + "'"}	~{true="--igenomes_ignore  " false="" igenomes_ignore}	~{"--gtf '" + gtf + "'"}	~{"--star_index '" + star_index + "'"}	~{"--bowtie_index '" + bowtie_index + "'"}	~{true="--save_reference  " false="" save_reference}	~{true="--save_trimmed  " false="" save_trimmed}	~{true="--trim_ecop  " false="" trim_ecop}	~{true="--trim_linker  " false="" trim_linker}	~{true="--trim_5g  " false="" trim_5g}	~{true="--trim_artifacts  " false="" trim_artifacts}	~{"--eco_site '" + eco_site + "'"}	~{"--linker_seq '" + linker_seq + "'"}	~{"--artifacts_5end '" + artifacts_5end + "'"}	~{"--artifacts_3end '" + artifacts_3end + "'"}	~{true="--remove_ribo_rna  " false="" remove_ribo_rna}	~{true="--save_non_ribo_reads  " false="" save_non_ribo_reads}	~{"--ribo_database_manifest '" + ribo_database_manifest + "'"}	~{"--min_cluster " + min_cluster}	~{"--tpm_cluster_threshold " + tpm_cluster_threshold}	~{true="--skip_initial_fastqc  " false="" skip_initial_fastqc}	~{true="--skip_trimming  " false="" skip_trimming}	~{true="--skip_trimming_fastqc  " false="" skip_trimming_fastqc}	~{true="--skip_alignment  " false="" skip_alignment}	~{true="--skip_samtools_stats  " false="" skip_samtools_stats}	~{true="--skip_ctss_generation  " false="" skip_ctss_generation}	~{true="--skip_ctss_qc  " false="" skip_ctss_qc}	~{true="--help  " false="" help}	~{"--publish_dir_mode '" + publish_dir_mode + "'"}	~{"--name '" + name + "'"}	~{"--email_on_fail '" + email_on_fail + "'"}	~{true="--plaintext_email  " false="" plaintext_email}	~{"--max_multiqc_email_size '" + max_multiqc_email_size + "'"}	~{true="--monochrome_logs  " false="" monochrome_logs}	~{"--multiqc_config '" + multiqc_config + "'"}	~{"--tracedir '" + tracedir + "'"}	~{"--clusterOptions '" + clusterOptions + "'"}	~{"--max_cpus " + max_cpus}	~{"--max_memory '" + max_memory + "'"}	~{"--max_time '" + max_time + "'"}	~{"--custom_config_version '" + custom_config_version + "'"}	~{"--custom_config_base '" + custom_config_base + "'"}	~{"--hostnames '" + hostnames + "'"}	~{"--config_profile_description '" + config_profile_description + "'"}	~{"--config_profile_contact '" + config_profile_contact + "'"}	~{"--config_profile_url '" + config_profile_url + "'"}	-w ~{outputbucket}
	>>>
        
    output {
        File execution_trace = "pipeline_execution_trace.txt"
        Array[File] results = glob("results/*/*html")
    }
    runtime {
        docker: "truwl/nfcore-cageseq:1.0.2_0.1.0"
        memory: "2 GB"
        cpu: 1
    }
}
    