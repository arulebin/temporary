# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/AOSP-whatever/platform_manifest -b staging/du-q10x_asb_2021-06 -g default,-device,-mips,-darwin,-notdefault
git clone https://github.com/RahifM/local_manifests --depth 1 -b staging/du-q10x .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch du_mido-user
export WITH_GMS=true
export TZ=Asia/Kolkata
mka bacon

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
