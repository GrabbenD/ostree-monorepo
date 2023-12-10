#!/usr/bin/env bash
set -x
set -u
set -e

# [CLI]: TASKS FINECONTROL
CLI_DIR=${0%/*}
CLI_ARG=${1:-}
CLI_ARGS=(${@:2})

# Target
case "${CLI_ARG}" in
    'client')
        "${CLI_DIR}/client/client.sh" "${CLI_ARGS[@]}"
    ;;

    'ostree')
        OPT_KARGS=(
            # KVM
            #'amd_iommu=pt'

            # CPU (EEP)
            'amd_pstate.shared_mem=1'
            'amd_pstate=active'
            'amd_prefcore=enable'

            # GPU (VRR)
            'video=DP-1:3840x1600@143.998'
            'video=DP-2:1920x1080@119.982'
            'amdgpu.freesync_video=1'

            # Performance
            'mitigations=off'
            'gpu_sched.sched_policy=0' # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
            'preempt=full'
        )

        "${CLI_DIR}/ostree/ostree.sh" \
            --cmdline="${OPT_KARGS[*]}" \
            --keymap='sv-latin1' \
            --time='Europe/Stockholm' \
            --no-cache='1' \
            "${CLI_ARGS[@]}"
    ;;

    'server')
        "${CLI_DIR}/server/server.sh" "${CLI_ARGS[@]}"
    ;;

    *)
        printf '%s\n' 'Usage: client.sh {client|ostree|server}'
    ;;
esac
