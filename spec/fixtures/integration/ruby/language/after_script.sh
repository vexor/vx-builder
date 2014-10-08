
# after script init
export CI=1
export CI_JOB_ID=1
export CI_JOB_NUMBER=100
export CI_BUILD_ID=12
export CI_BUILD_NUMBER=101
export CI_PROJECT_NAME=vexor/vx-test-repo
export CI_BUILD_SHA=8f53c077072674972e21c82a286acc07fada91f5
export CI_BRANCH=test/pull-request
export VX_ROOT=$(pwd)
test -d ${VX_ROOT}/code/vexor/vx-test-repo || exit 1
cd ${VX_ROOT}/code/vexor/vx-test-repo

# after script
test -f $HOME/.casher/bin/casher && casher-ruby $HOME/.casher/bin/casher push http://example.com/test/pull-request/rvm-1.9.3-gemfile.tgz