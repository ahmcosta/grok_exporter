#!/bin/bash

set -e

# patches are created with
# diff -Naur proj_orig proj_patched

export SRC=$GOPATH/src/github.com/fstab/grok_exporter

cd $SRC
#mv vendor vendor.bak
rm -rf vendor

cd $SRC
mkdir -p vendor/github.com/moovweb
cd vendor/github.com/moovweb
git clone https://github.com/moovweb/rubex.git
cd rubex
git checkout 6.2.256 # cb849acea6148000db8a55743f71476b0897ea41
rm -rf .git
patch -p1 < $SRC/vendor-patches/rubex.patch

###########################################################################
# github.com/prometheus/client_golang
###########################################################################

cd $SRC
mkdir -p vendor/github.com/prometheus
cd vendor/github.com/prometheus
git clone https://github.com/prometheus/client_golang.git
cd client_golang
git checkout d38f1ef46f0d78136db3e585f7ebe1bcc3476f73
rm -rf .git

# Dependency: github.com/prometheus/client_model/go

cd $SRC
mkdir -p vendor/github.com/prometheus
cd vendor/github.com/prometheus
git clone https://github.com/prometheus/client_model.git
cd client_model
git checkout fa8ad6fec33561be4280a8f0514318c79d7f6cb6
ls -A | grep -v go | xargs rm -rf

# Dependency: github.com/prometheus/procfs

cd $SRC
mkdir -p vendor/github.com/prometheus
cd vendor/github.com/prometheus
git clone https://github.com/prometheus/procfs.git
cd procfs
git checkout abf152e5f3e97f2fafac028d2cc06c1feb87ffa5
ls -A | grep -v '.go' | xargs rm -rf

# Dependency: github.com/prometheus/common/expfmt

cd $SRC
mkdir -p vendor/github.com/prometheus
cd vendor/github.com/prometheus
git clone https://github.com/prometheus/common.git
cd common
git checkout a6ab08426bb262e2d190097751f5cfd1cfdfd17d
ls -A | grep -v expfmt | grep -v internal | grep -v model | xargs rm -rf

# Dependency: github.com/matttproud/golang_protobuf_extensions/pbutil

cd $SRC
mkdir -p vendor/github.com/matttproud
cd vendor/github.com/matttproud
git clone https://github.com/matttproud/golang_protobuf_extensions.git
cd golang_protobuf_extensions
git checkout v1.0.0
ls -A | grep -v pbutil | xargs rm -rf

# Dependency: github.com/beorn7/perks/quantile

cd $SRC
mkdir -p vendor/github.com/beorn7
cd vendor/github.com/beorn7
git clone https://github.com/beorn7/perks.git
cd perks
git checkout 3ac7bf7a47d159a033b107610db8a1b6575507a4
rm -rf .git .gitignore histogram topk README.md

# Dependency: github.com/golang/protobuf/proto

cd $SRC
mkdir -p vendor/github.com/golang
cd vendor/github.com/golang
git clone https://github.com/golang/protobuf.git
cd protobuf
git checkout 9e6977f30c91c78396e719e164e57f9287fff42c
rm -rf .git .gitignore Make* jsonpb protoc-gen-go ptypes

###########################################################################
# github.com/google/mtail/tailer
###########################################################################

cd $SRC
mkdir -p vendor/github.com/google
cd vendor/github.com/google
git clone https://github.com/google/mtail.git
cd mtail
git checkout a54f860fe8b14440320014ed608e438a790f19ac
ls -A | grep -v tailer | grep -v watcher | xargs rm -r
patch -p1 < $SRC/vendor-patches/mtail.patch

# Dependency: gopkg.in/fsnotify.v1

cd $SRC
mkdir -p vendor/gopkg.in
cd vendor/gopkg.in
git clone https://gopkg.in/fsnotify.v1
cd fsnotify.v1
git checkout v1.3.0
rm -rf .git .gitignore .travis.yml

# Dependency: golang.org/x/sys/unix

cd $SRC
mkdir -p vendor/golang.org/x
cd vendor/golang.org/x
git clone https://github.com/golang/sys.git
cd sys
git checkout d4feaf1a7e61e1d9e79e6c4e76c6349e9cab0a03
rm -rf .git .gitattributes .gitignore

# Dependency: github.com/spf13/afero

cd $SRC
mkdir -p vendor/github.com/spf13
cd vendor/github.com/spf13
git clone https://github.com/spf13/afero.git
cd afero
git checkout f0b36a98d372af4038e20729956792ec38df54e2
rm -rf .git .travis.yml sftp*
patch -p1 < $SRC/vendor-patches/afero.patch

###########################################################################
# gopkg.in/yaml.v2
###########################################################################

cd $SRC
mkdir -p vendor/gopkg.in
cd vendor/gopkg.in
git clone https://gopkg.in/yaml.v2
cd yaml.v2
git checkout v2
rm -rf .git .travis.yml

###########################################################################

find $SRC/vendor -type f -name '*_test.go'  | xargs rm
