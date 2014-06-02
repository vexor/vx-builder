
# after script init
export CI_JOB_ID=1
export CI_BUILD_ID=12
export CI_BRANCH=master
export VX_ROOT=$(pwd)
cd ${VX_ROOT}/code/name

# after script
test -f $HOME/.casher/bin/casher && /opt/rbenv/versions/1.9.3-p547/bin/ruby $HOME/.casher/bin/casher push http://example.com/master/rvm-2.0.0-gemfile.tgz