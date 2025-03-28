#!/usr/bin/env nextflow
// hash:sha256:48a80a5e616c367027bd56e26d62c4a2b5b3ca4c8bfd28edb4d7b5a7f216f5aa

nextflow.enable.dsl = 1

params.ecephys_713655_2024_08_08_11_52_03_url = 's3://aind-private-data-prod-o5171v/ecephys_713655_2024-08-08_11-52-03'

ecephys_713655_2024_08_08_11_52_03_to_copy_of_lightning_pose_inference_evaluation_asset_registration_1 = channel.fromPath(params.ecephys_713655_2024_08_08_11_52_03_url + "/", type: 'any')
ecephys_713655_2024_08_08_11_52_03_to_preview_inference_video_2 = channel.fromPath(params.ecephys_713655_2024_08_08_11_52_03_url + "/", type: 'any')

// capsule - Copy of Lightning Pose Inference, Evaluation, Asset Registration
process capsule_copy_of_lightning_pose_inference_evaluation_asset_registration_1 {
	tag 'capsule-9969331'
	container "$REGISTRY_HOST/capsule/ac53c6d1-1265-4458-82e7-310c256a9dbb:85186d594cb4a57f66e8fcb36a0e87e4"

	cpus 16
	memory '61 GB'
	accelerator 1
	label 'gpu'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/ecephys_713655_2024-08-08_11-52-03' from ecephys_713655_2024_08_08_11_52_03_to_copy_of_lightning_pose_inference_evaluation_asset_registration_1.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=ac53c6d1-1265-4458-82e7-310c256a9dbb
	export CO_CPUS=16
	export CO_MEMORY=65498251264

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	ln -s "/tmp/data/342_NP.3_327_NP.2_Front_Face" "capsule/data/342_NP.3_327_NP.2_Front_Face" # id: 64eb740a-a74d-4e9b-8bff-c78c953bf32a

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9969331.git" capsule-repo
	git -C capsule-repo checkout 2f5e5a5f964b69f325dc33849113f3aebbca69df --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_copy_of_lightning_pose_inference_evaluation_asset_registration_1_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Preview Inference Video
process capsule_preview_inference_video_2 {
	tag 'capsule-6942612'
	container "$REGISTRY_HOST/capsule/06f5bd82-6294-4265-a19c-ed091cf6ee91:825590e9445432ef2e5ca294cc7288d7"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/ecephys_713655_2024-08-08_11-52-03' from ecephys_713655_2024_08_08_11_52_03_to_preview_inference_video_2.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=06f5bd82-6294-4265-a19c-ed091cf6ee91
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6942612.git" capsule-repo
	git -C capsule-repo checkout de6f0337966668af3bbc5aac411e70c74cb0fd21 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
