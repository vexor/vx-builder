
# after script init
export CI=1
export CI_JOB_ID=1
export CI_JOB_NUMBER=100
export CI_BUILD_ID=12
export CI_BUILD_NUMBER=101
export CI_PROJECT_NAME=project/name
export CI_BUILD_SHA=b665f90239563c030f1b280a434b3d84daeda1bd
export CI_BRANCH=master
export VX_ROOT=$(pwd)
cd ${VX_ROOT}/code/project/name

# after script
test -f $HOME/.casher/bin/casher && /opt/rbenv/versions/1.9.3-p547/bin/ruby $HOME/.casher/bin/casher push http://example.com/master/rvm-1.9.3-gemfile.tgz