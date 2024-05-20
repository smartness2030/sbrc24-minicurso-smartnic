#
# Copyright (c) 2022-2024 NVIDIA CORPORATION & AFFILIATES, ALL RIGHTS RESERVED.
#
# This software product is a proprietary product of NVIDIA CORPORATION &
# AFFILIATES (the "Company") and all right, title, and interest in and to the
# software product, including all associated intellectual property rights, are
# and shall remain exclusively with the Company.
#
# This software product is governed by the End User License Agreement
# provided with the software product.
#

project('DOCA_SAMPLE', 'C', 'CPP',
        # Get version number from file.
        version: run_command(find_program('cat'),
                files('/opt/mellanox/doca/applications/VERSION'), check: true).stdout().strip(),
        license: 'Proprietary',
        default_options: ['buildtype=debug'],
        meson_version: '>= 0.61.2'
)

SAMPLE_NAME = 'flow_hairpin_vnf'

# Comment this line to restore warnings of experimental DOCA features
add_project_arguments('-D DOCA_ALLOW_EXPERIMENTAL_API', language: ['c', 'cpp'])

sample_dependencies = []
# Required for all DOCA programs
sample_dependencies += dependency('doca-common')
# The DOCA library of the sample itself
sample_dependencies += dependency('doca-flow')
# Utility DOCA library for executables
sample_dependencies += dependency('doca-argp')
# Required DOCA Driver
sample_dependencies += dependency('libdpdk')

sample_srcs = [
        # The sample itself
        SAMPLE_NAME + '_sample.c',
        # Main function for the sample's executable
        SAMPLE_NAME + '_main.c',
        # Common code for the DOCA library samples
        '/opt/mellanox/doca/samples/common.c',
        # Common code for all DOCA applications
        '/opt/mellanox/doca/applications/common/dpdk_utils.c',
]

sample_inc_dirs  = []
# Common DOCA library logic
sample_inc_dirs += include_directories('/opt/mellanox/doca/samples/')
# Common DOCA logic (applications)
sample_inc_dirs += include_directories('/opt/mellanox/doca/applications/common/')

executable('doca_' + SAMPLE_NAME, sample_srcs,
        c_args : '-Wno-missing-braces',
        dependencies : sample_dependencies,
        include_directories: sample_inc_dirs,
        install: false)
