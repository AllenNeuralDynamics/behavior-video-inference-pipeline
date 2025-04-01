#!/usr/bin/env nextflow
// hash:sha256:cb0184636b45a3f328b15043ef7747c96b365337c24d6f62861c61bccb3eec0b

nextflow.enable.dsl = 1

params.ecephys_713655_2024_08_08_11_52_03_url = 's3://aind-private-data-prod-o5171v/ecephys_713655_2024-08-08_11-52-03'

ecephys_713655_2024_08_08_11_52_03_to_lightning_pose_inference_and_evaluation_1 = channel.fromPath(params.ecephys_713655_2024_08_08_11_52_03_url + "/", type: 'any')
capsule_lightning_pose_inference_evaluation_asset_registration_3_to_capsule_upload_derived_data_asset_4_2 = channel.create()
ecephys_713655_2024_08_08_11_52_03_to_upload_derived_data_asset_3 = channel.fromPath(params.ecephys_713655_2024_08_08_11_52_03_url + "/", type: 'any')

// capsule - Lightning Pose Inference and Evaluation
process capsule_lightning_pose_inference_evaluation_asset_registration_3 {
	tag 'capsule-6146766'
	container "$REGISTRY_HOST/capsule/d57d4611-b49a-41de-ba60-7f28ae5cc05a"

	cpus 16
	memory '61 GB'
	accelerator 1
	label 'gpu'

	input:
	path 'capsule/data/behavior_mount' from ecephys_713655_2024_08_08_11_52_03_to_lightning_pose_inference_and_evaluation_1.collect()

	output:
	path 'capsule/results/*' into capsule_lightning_pose_inference_evaluation_asset_registration_3_to_capsule_upload_derived_data_asset_4_2

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
	git -C capsule-repo checkout edd3e8c97e6eb03f04efffaa75e75f1224ed30e5 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_lightning_pose_inference_evaluation_asset_registration_3_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Upload Derived Data Asset
process capsule_upload_derived_data_asset_4 {
	tag 'capsule-3310875'
	container "$REGISTRY_HOST/capsule/155077de-0d66-49a7-8c0c-a86c8ca54e72"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/lp_output/' from capsule_lightning_pose_inference_evaluation_asset_registration_3_to_capsule_upload_derived_data_asset_4_2.collect()
	path 'capsule/data' from ecephys_713655_2024_08_08_11_52_03_to_upload_derived_data_asset_3.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=155077de-0d66-49a7-8c0c-a86c8ca54e72
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3310875.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
