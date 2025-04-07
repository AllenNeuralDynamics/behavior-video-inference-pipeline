#!/usr/bin/env nextflow
// hash:sha256:679a7b2c0b65a795acb9b052aebab35efbeaf887b401e93760c251bf83619c51

nextflow.enable.dsl = 1

params.behavior_mount_url = 's3://aind-private-data-prod-o5171v/multiplane-ophys_749315_2024-11-18_14-47-15'

behavior_mount_to_upload_derived_data_asset_1 = channel.fromPath(params.behavior_mount_url + "/", type: 'any')
capsule_lightning_pose_inference_and_evaluation_5_to_capsule_upload_derived_data_asset_4_2 = channel.create()
behavior_mount_to_lightning_pose_inference_and_evaluation_3 = channel.fromPath(params.behavior_mount_url + "/", type: 'any')
behavior_mount_to_preview_inference_video_4 = channel.fromPath(params.behavior_mount_url + "/", type: 'any')

// capsule - Upload Derived Data Asset
process capsule_upload_derived_data_asset_4 {
	tag 'capsule-3310875'
	container "$REGISTRY_HOST/capsule/155077de-0d66-49a7-8c0c-a86c8ca54e72:83f37d2cd6520a54625c12062dc35042"

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/behavior_mount' from behavior_mount_to_upload_derived_data_asset_1.collect()
	path 'capsule/data/lp_output/' from capsule_lightning_pose_inference_and_evaluation_5_to_capsule_upload_derived_data_asset_4_2.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=155077de-0d66-49a7-8c0c-a86c8ca54e72
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3310875.git" capsule-repo
	git -C capsule-repo checkout b03002f1b26308a8c8c8e45356866fa4ad2732f0 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Lightning Pose Inference and Evaluation
process capsule_lightning_pose_inference_and_evaluation_5 {
	tag 'capsule-6146766'
	container "$REGISTRY_HOST/capsule/d57d4611-b49a-41de-ba60-7f28ae5cc05a:6c506baf9fe56abd333af5707532c7a6"

	cpus 16
	memory '61 GB'
	accelerator 1
	label 'gpu'

	input:
	path 'capsule/data/behavior_mount' from behavior_mount_to_lightning_pose_inference_and_evaluation_3.collect()

	output:
	path 'capsule/results/*' into capsule_lightning_pose_inference_and_evaluation_5_to_capsule_upload_derived_data_asset_4_2

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

	ln -s "/tmp/data/model_mount" "capsule/data/model_mount" # id: c63238ff-a4ad-422b-8359-09752abda63a

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6146766.git" capsule-repo
	git -C capsule-repo checkout 0b83ee679a9cd4b9c0d82755bce875164d6066f7 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_lightning_pose_inference_and_evaluation_5_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Preview Inference Video
process capsule_preview_inference_video_6 {
	tag 'capsule-6942612'
	container "$REGISTRY_HOST/capsule/06f5bd82-6294-4265-a19c-ed091cf6ee91:2faaa370733ebaff6632059b71a68c97"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/behavior_mount' from behavior_mount_to_preview_inference_video_4.collect()

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
	git -C capsule-repo checkout 9ee0544c5014d391966a201840ce0fe2878b70f3 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
