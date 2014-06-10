
# init
set -e
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export LC_ALL=en_US.UTF8
export DEBIAN_FRONTEND=noninteractive
export CI_JOB_ID=1
export CI_BUILD_ID=12
export CI_BRANCH=master
export VX_ROOT=$(pwd)
mkdir -p ${VX_ROOT}/data/name
mkdir -p ${VX_ROOT}/code/name
(echo LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBdmVpcXpyMG54SkE0OGZrL1Q3cUZyT0RtZFQ5NGx2dDdvbnRHTGhxTlQ3WitHYnFMCnQ0NUY0LzVCeE5neU1iU1FmYUp3MXNHTXVuUWZqS1JkV2Z1S1VRcDB5NmJOaEFqdG5Dbm9WZWwzU01CYVhFMnIKODk2R2toTlhjMS9sejF2LzFUOGJsYy9jaFZlS1p2UVQraER2Qy9LRUNGLyt2ZDd5TDZOUmxvYXlaZHYwa3M3egpDd29JZWVUZkV1MmhkM3JYREVMZ29pTStBQUVjaVllMDhWdXl0RmpiT055MjhFeTNTR0hVUk40MThGSnJKSERzCjdCNXgzUDg5Z2xrU3RhMVRZNEpPUXRvV3V4emE3eWxTOEcxaytzcytUREIrRVQzc3FqRGUxbXhvc1JBZnFTQTcKYXBFWkszQUxiWnJ1M25ZZDI2eCtDRTg0ZHZIN0dpS29CbDBUU1FJREFRQUJBb0lCQUVFQWduYUJDRHVmb2Q0eApFaHFZSFdrdkViTFFKdGFHL2FwL3gyWEFjTjMzK1BHVmlIMHJsWUNVWnE2WjBaUngyWU1uTnJoTFI0QUtmMElFCmdHOXNTY3V6YUliTWNVdmdRblJSWTlVRU5IQVNadHR4T29vZWdMRS9MWSt3STFqMmhIclpQdmZvVGZMV0krbFoKWWYwV0RyeG9KZ2szMGxuckZicDRqRlNaaGphV21zbTFYUTRodHQ5YmZHT0JsZS9nSjZVVHIzMndGMEV5T3B2NAplcmNpMVJTVXp5RFd6MHE3VGphcTZTSGx3UTJKd2NMRzB2bnJacStZbk1KVXdqTGhDNEpBTVpFS0YvNjFLbnNNCnp3UjludU9FMlpESTF4SDV4QUErMHBOa3d6eFdjcXJ5b0tCck9NYXREYSs3Wk9KRW9iT2lxK2dscW1vcHJvdjQKZ1hYUjJJRUNnWUVBK3dQMVNaTTdFMFdudFF5UGdSaVo3RDlUU2lvVit4NTFSUHc5UHV3OEtHM1R1R09McWFNegpyTXdzY2JUb2VqaVpGU3YybEhHRGJTZldzdzc2TVlqK3ZLM1JGNWVkOE14eTNnU2ZWRnhWelNENTBlZnBKY1ZxCmtWNm4vdWEzQUpZR1ZibmVhajU2QmxqeEhieFZ2Y3lYWEZHbmFtbDhJQ1BKMmp5UjhSRTE4NDhDZ1lFQXdhNFMKamdubVJlWStUdXU3VTB4ZDZPbzBYOXRqa3FreXlHcStzdFEzSTJPZll6bXRRdmVGbFdzZmVjbmJDbUVNeWxMeQpuR1Z4WVNpUk5jaWdNb1o3ZXVyZ2RtR0QvTzRtREc4MER5NFBKN2xGOC84WHg3MDFWN1lqZ0duSUkyL1Z3cDFrCnZsUjl4VEo1bFZwQU5YcVNZcTFrd3llU1BuMUtMS3QwRTQyVlA2Y0NnWUVBMmw0T0pDeU9KdXpnd2JNa29FVDcKbXJkWVNOdWw5YWtBa2J2eHQreWhSUGFPU2dsbmRYTUJ3R0I2aFl6QTlacUpLZzd0MnlPSkZ3dWlUbkZJSEpHMgpNZ1B3TTFyMXpvYTlvd0ZZYm5aSk9rTm1zVUhUNU1VQ09XYWtOUzhXb3M3Z3dmRUpXVm55bzlUNkpVa3pPZ05pCjViQXZPWFo4d2lVQU0vZWZhcHp6VjJjQ2dZQmJLdFkvRi9mVjFWQmxFOStFa1VEdlB6ZFNHOUllR2hqMmNCQzkKMnRqdGhwcGpPYVlPRExkTG96WVl2T1NuV1JHTk4waE9TQTM3bnYzalpFSE1Kck4vSTRwdkR1M3pKQ0t5M2JHUwpwNnFvbHpTUGF2ZEZwUkd6N045L05jdm9xbDdqa2ZUM0JveUJRNFlwd0diVEJaUmNjS1FxbkxqaFExYWoranpVCmEyUGlwd0tCZ1FDQ0x1T3JoTzM3VW92TW5tTnJSelhud3U5QytWQ0I0b0dmNlF0akVlaE14L0orNmVodlNZdWIKbExPeGVaUUh6VmtDM0k2clZNYksxcXgwdDhRbmIrNWpIUkFrUjR4L0phVG9qcFpZcW5nZExydFk0L3FMS0pxNwo0YU9MWWpKeUwzWUIwOWczcjY4d2NuVFVIYmNaWWorUTd4VDFZL250WE5wM3BkYlljNDdOVVE9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo= | base64 --decode) > ${VX_ROOT}/data/name/key
chmod 0600 ${VX_ROOT}/data/name/key
export VX_PRIVATE_KEY=${VX_ROOT}/data/name/key
(echo IyEvYmluL3NoCmV4ZWMgL3Vzci9iaW4vc3NoIC1BIC1vIExvZ0xldmVsPXF1aWV0IC1vIFN0cmljdEhvc3RLZXlDaGVja2luZz1ubyAtbyBVc2VyS25vd25Ib3N0c0ZpbGU9L2Rldi9udWxsIC1pICR7VlhfUk9PVH0vZGF0YS9uYW1lL2tleSAkQAo= | base64 --decode) > ${VX_ROOT}/data/name/git_ssh
chmod 0750 ${VX_ROOT}/data/name/git_ssh
export GIT_SSH=${VX_ROOT}/data/name/git_ssh
 echo "$ git clone --depth=50 --branch=master git@github.com:dima-exe/ci-worker-test-repo.git ${VX_ROOT}/code/name" 
git clone --depth=50 --branch=master git@github.com:dima-exe/ci-worker-test-repo.git ${VX_ROOT}/code/name
 echo "$ git checkout -qf b665f90239563c030f1b280a434b3d84daeda1bd" 
 ( cd ${VX_ROOT}/code/name && git checkout -qf b665f90239563c030f1b280a434b3d84daeda1bd ) 
unset GIT_SSH
echo "Starting SSH Agent"
eval "$(ssh-agent)"
ssh-add $VX_PRIVATE_KEY
cd ${VX_ROOT}/code/name
 export CASHER_DIR=$HOME/.casher && ( mkdir -p $CASHER_DIR/bin && /usr/bin/curl https://raw2.github.com/dima-exe/casher/master/bin/casher -s -o $HOME/.casher/bin/casher && chmod +x $HOME/.casher/bin/casher ) || true 
test -f $HOME/.casher/bin/casher && /opt/rbenv/versions/1.9.3-p547/bin/ruby $HOME/.casher/bin/casher fetch http://example.com/master/rvm-1.9.3-gemfile.tgz || true
test -f $HOME/.casher/bin/casher && /opt/rbenv/versions/1.9.3-p547/bin/ruby $HOME/.casher/bin/casher add ~/.rubygems || true
unset CASHER_DIR

# before install
eval "$(rbenv init -)" || true
rbenv shell $(rbenv versions | sed -e 's/^*/ /' | awk '{print $1}' | grep -v 'system' | grep '1.9.3' | tail -n1)
echo \$\ export\ BUNDLE_GEMFILE\=\$\{PWD\}/Gemfile
export BUNDLE_GEMFILE=${PWD}/Gemfile
echo \$\ export\ GEM_HOME\=\~/.rubygems
export GEM_HOME=~/.rubygems

# announce
echo \$\ ruby\ --version
ruby --version
echo \$\ gem\ --version
gem --version
echo \$\ bundle\ --version
bundle --version

# install
echo \$\ bundle\ install\ 
bundle install 
echo \$\ bundle\ clean\ --force
bundle clean --force

# before deploy