#!/usr/bin/env nextflow
// hash:sha256:44243a50c28375b7d67552c1c58fb2e96aacd40afac8b60500a6b58030c21ff4

nextflow.enable.dsl = 1

params.ecephys_713655_2024_08_08_11_52_03_url = 's3://aind-private-data-prod-o5171v/ecephys_713655_2024-08-08_11-52-03'

ecephys_713655_2024_08_08_11_52_03_to_lightning_pose_inference_evaluation_asset_registration_1 = channel.fromPath(params.ecephys_713655_2024_08_08_11_52_03_url + "/", type: 'any')
ecephys_713655_2024_08_08_11_52_03_to_preview_inference_video_2 = channel.fromPath(params.ecephys_713655_2024_08_08_11_52_03_url + "/", type: 'any')

// capsule - Lightning Pose Inference, Evaluation, Asset Registration
process capsule_lightning_pose_inference_evaluation_asset_registration_1 {
	tag 'capsule-6146766'
	container "$REGISTRY_HOST/capsule/d57d4611-b49a-41de-ba60-7f28ae5cc05a:29cd96ba6106a02e6cfa21cbf2a61cce"

	cpus 16
	memory '61 GB'
	accelerator 1
	label 'gpu'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/behavior_mount' from ecephys_713655_2024_08_08_11_52_03_to_lightning_pose_inference_evaluation_asset_registration_1.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=d57d4611-b49a-41de-ba60-7f28ae5cc05a
	export CO_CPUS=16
	export CO_MEMORY=65498251264

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	ln -s "/tmp/data/342_NP.3_327_NP.2_Front_Face" "capsule/data/model_mount" # id: 64eb740a-a74d-4e9b-8bff-c78c953bf32a

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6146766.git" capsule-repo
	git -C capsule-repo checkout 62f68466cb31090a3a05dbe8f5460426092aa9ab --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_lightning_pose_inference_evaluation_asset_registration_1_args}

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
	path 'capsule/data/behavior_mount' from ecephys_713655_2024_08_08_11_52_03_to_preview_inference_video_2.collect()

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
