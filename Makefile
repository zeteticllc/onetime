.DEFAULT_GOAL := all

YUBICOC := yubico-c
SRCDIR := OneTime
TARGET := OneTimeTests
CONFIGURATION := Debug
BUILD_TARGETS := clean build
CLEAN_TARGETS := clean

init:
	git submodule update --init --recursive

all:
	cd ${YUBICOC} && \
	autoreconf --install && \
	./configure && \
	make
	cd ${SRCDIR} && \
	xcodebuild -project OneTime.xcodeproj -target ${TARGET} -configuration ${CONFIGURATION} ${BUILD_TARGETS}

clean:
	cd ${YUBICOC} && \
	make clean
	cd ${SRCDIR} && \
	xcodebuild -project OneTime.xcodeproj -target ${TARGET} -configuration ${CONFIGURATION} ${CLEAN_TARGETS}
