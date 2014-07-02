
# init
set -e
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export LC_ALL=en_US.UTF8
export DEBIAN_FRONTEND=noninteractive
export CI=1
export CI_JOB_ID=1
export CI_JOB_NUMBER=100
export CI_BUILD_ID=12
export CI_BUILD_NUMBER=101
export CI_PROJECT_NAME=project/name
export CI_BUILD_SHA=b665f90239563c030f1b280a434b3d84daeda1bd
export CI_BRANCH=master
export VX_ROOT=$(pwd)
export PATH=$VX_ROOT/bin:$PATH
mkdir -p $VX_ROOT/bin
mkdir -p ${VX_ROOT}/data/project/name
mkdir -p ${VX_ROOT}/code/project/name
(echo LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBdmVpcXpyMG54SkE0OGZrL1Q3cUZyT0RtZFQ5NGx2dDdvbnRHTGhxTlQ3WitHYnFMCnQ0NUY0LzVCeE5neU1iU1FmYUp3MXNHTXVuUWZqS1JkV2Z1S1VRcDB5NmJOaEFqdG5Dbm9WZWwzU01CYVhFMnIKODk2R2toTlhjMS9sejF2LzFUOGJsYy9jaFZlS1p2UVQraER2Qy9LRUNGLyt2ZDd5TDZOUmxvYXlaZHYwa3M3egpDd29JZWVUZkV1MmhkM3JYREVMZ29pTStBQUVjaVllMDhWdXl0RmpiT055MjhFeTNTR0hVUk40MThGSnJKSERzCjdCNXgzUDg5Z2xrU3RhMVRZNEpPUXRvV3V4emE3eWxTOEcxaytzcytUREIrRVQzc3FqRGUxbXhvc1JBZnFTQTcKYXBFWkszQUxiWnJ1M25ZZDI2eCtDRTg0ZHZIN0dpS29CbDBUU1FJREFRQUJBb0lCQUVFQWduYUJDRHVmb2Q0eApFaHFZSFdrdkViTFFKdGFHL2FwL3gyWEFjTjMzK1BHVmlIMHJsWUNVWnE2WjBaUngyWU1uTnJoTFI0QUtmMElFCmdHOXNTY3V6YUliTWNVdmdRblJSWTlVRU5IQVNadHR4T29vZWdMRS9MWSt3STFqMmhIclpQdmZvVGZMV0krbFoKWWYwV0RyeG9KZ2szMGxuckZicDRqRlNaaGphV21zbTFYUTRodHQ5YmZHT0JsZS9nSjZVVHIzMndGMEV5T3B2NAplcmNpMVJTVXp5RFd6MHE3VGphcTZTSGx3UTJKd2NMRzB2bnJacStZbk1KVXdqTGhDNEpBTVpFS0YvNjFLbnNNCnp3UjludU9FMlpESTF4SDV4QUErMHBOa3d6eFdjcXJ5b0tCck9NYXREYSs3Wk9KRW9iT2lxK2dscW1vcHJvdjQKZ1hYUjJJRUNnWUVBK3dQMVNaTTdFMFdudFF5UGdSaVo3RDlUU2lvVit4NTFSUHc5UHV3OEtHM1R1R09McWFNegpyTXdzY2JUb2VqaVpGU3YybEhHRGJTZldzdzc2TVlqK3ZLM1JGNWVkOE14eTNnU2ZWRnhWelNENTBlZnBKY1ZxCmtWNm4vdWEzQUpZR1ZibmVhajU2QmxqeEhieFZ2Y3lYWEZHbmFtbDhJQ1BKMmp5UjhSRTE4NDhDZ1lFQXdhNFMKamdubVJlWStUdXU3VTB4ZDZPbzBYOXRqa3FreXlHcStzdFEzSTJPZll6bXRRdmVGbFdzZmVjbmJDbUVNeWxMeQpuR1Z4WVNpUk5jaWdNb1o3ZXVyZ2RtR0QvTzRtREc4MER5NFBKN2xGOC84WHg3MDFWN1lqZ0duSUkyL1Z3cDFrCnZsUjl4VEo1bFZwQU5YcVNZcTFrd3llU1BuMUtMS3QwRTQyVlA2Y0NnWUVBMmw0T0pDeU9KdXpnd2JNa29FVDcKbXJkWVNOdWw5YWtBa2J2eHQreWhSUGFPU2dsbmRYTUJ3R0I2aFl6QTlacUpLZzd0MnlPSkZ3dWlUbkZJSEpHMgpNZ1B3TTFyMXpvYTlvd0ZZYm5aSk9rTm1zVUhUNU1VQ09XYWtOUzhXb3M3Z3dmRUpXVm55bzlUNkpVa3pPZ05pCjViQXZPWFo4d2lVQU0vZWZhcHp6VjJjQ2dZQmJLdFkvRi9mVjFWQmxFOStFa1VEdlB6ZFNHOUllR2hqMmNCQzkKMnRqdGhwcGpPYVlPRExkTG96WVl2T1NuV1JHTk4waE9TQTM3bnYzalpFSE1Kck4vSTRwdkR1M3pKQ0t5M2JHUwpwNnFvbHpTUGF2ZEZwUkd6N045L05jdm9xbDdqa2ZUM0JveUJRNFlwd0diVEJaUmNjS1FxbkxqaFExYWoranpVCmEyUGlwd0tCZ1FDQ0x1T3JoTzM3VW92TW5tTnJSelhud3U5QytWQ0I0b0dmNlF0akVlaE14L0orNmVodlNZdWIKbExPeGVaUUh6VmtDM0k2clZNYksxcXgwdDhRbmIrNWpIUkFrUjR4L0phVG9qcFpZcW5nZExydFk0L3FMS0pxNwo0YU9MWWpKeUwzWUIwOWczcjY4d2NuVFVIYmNaWWorUTd4VDFZL250WE5wM3BkYlljNDdOVVE9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo= | base64 --decode) > ${VX_ROOT}/data/project/name/key
chmod 0600 ${VX_ROOT}/data/project/name/key
export VX_PRIVATE_KEY=${VX_ROOT}/data/project/name/key
(echo IyEvYmluL3NoCmV4ZWMgL3Vzci9iaW4vc3NoIC1BIC1vIExvZ0xldmVsPXF1aWV0IC1vIFN0cmljdEhvc3RLZXlDaGVja2luZz1ubyAtbyBVc2VyS25vd25Ib3N0c0ZpbGU9L2Rldi9udWxsIC1pICR7VlhfUk9PVH0vZGF0YS9wcm9qZWN0L25hbWUva2V5ICRACg== | base64 --decode) > ${VX_ROOT}/data/project/name/git_ssh
chmod 0750 ${VX_ROOT}/data/project/name/git_ssh
export GIT_SSH=${VX_ROOT}/data/project/name/git_ssh
 echo "$ git clone --depth=50 --branch=master git@github.com:dima-exe/ci-worker-test-repo.git ${VX_ROOT}/code/project/name" 
git clone --depth=50 --branch=master git@github.com:dima-exe/ci-worker-test-repo.git ${VX_ROOT}/code/project/name
 echo "$ git checkout -qf b665f90239563c030f1b280a434b3d84daeda1bd" 
 ( cd ${VX_ROOT}/code/project/name && git checkout -qf b665f90239563c030f1b280a434b3d84daeda1bd ) 
unset GIT_SSH
echo "starting SSH Agent"
eval "$(ssh-agent)" > /dev/null
ssh-add $VX_PRIVATE_KEY 2> /dev/null
cd ${VX_ROOT}/code/project/name
echo "download latest version of vxvm"
curl --fail --silent --show-error https://raw.githubusercontent.com/vexor/vx-packages/master/vxvm > $VX_ROOT/bin/vxvm
chmod +x $VX_ROOT/bin/vxvm

# before install
echo \$\ sudo\ vxvm\ install\ go\ 1.2
VX_VM_SOURCE="$(sudo vxvm install go 1.2)"
source "$VX_VM_SOURCE"
echo \$\ export\ VX_GOPATH\=\$VX_ROOT/gopath:\$GOPATH
export VX_GOPATH=$VX_ROOT/gopath:$GOPATH
echo \$\ export\ PATH\=\$VX_GOPATH/bin:\$PATH
export PATH=$VX_GOPATH/bin:$PATH
echo \$\ export\ VX_ORIG_CODE_ROOT\=\$\(pwd\)
export VX_ORIG_CODE_ROOT=$(pwd)
echo \$\ export\ VX_NEW_CODE_ROOT\=\$VX_GOPATH/src/github.com/project/name
export VX_NEW_CODE_ROOT=$VX_GOPATH/src/github.com/project/name
echo \$\ mkdir\ -p\ \$VX_NEW_CODE_ROOT
mkdir -p $VX_NEW_CODE_ROOT
echo \$\ rmdir\ \$VX_NEW_CODE_ROOT
rmdir $VX_NEW_CODE_ROOT
echo \$\ mv\ \$VX_ORIG_CODE_ROOT\ \$VX_NEW_CODE_ROOT
mv $VX_ORIG_CODE_ROOT $VX_NEW_CODE_ROOT
echo \$\ ln\ -s\ \$VX_NEW_CODE_ROOT\ \$VX_ORIG_CODE_ROOT
ln -s $VX_NEW_CODE_ROOT $VX_ORIG_CODE_ROOT
echo \$\ cd\ \$VX_NEW_CODE_ROOT
cd $VX_NEW_CODE_ROOT

# announce
echo \$\ go\ version
go version
echo \$\ go\ env
go env

# install
echo \$\ go\ get\ -v\ ./...
go get -v ./...

# before script