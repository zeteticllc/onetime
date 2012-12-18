.DEFAULT_GOAL := all

YUBICOC := yubico-c
SRCDIR := OneTime
TARGET := OneTimeTests
CONFIGURATION := Debug
BUILD_TARGETS := clean build
CLEAN_TARGETS := clean

init:
	git submodule update --init --recursive

# Building on MacOS $to_tool_file_cmd is empty
# sed -i '/#! \/bin\/sh/s|$|\n\nto_tool_file_cmd=func_convert_file_noop\n|'  libtool 
# https://lists.gnu.org/archive/html/bug-libtool/2012-03/msg00010.html

all:
	cd ${YUBICOC} && \
	autoreconf --install && \
	./configure && \
  head -n 1 libtool>libtool.tmp && \
  echo ''>>libtool.tml && \
  echo 'to_tool_file_cmd=func_convert_file_noop'>>libtool.tmp && \
  tail -n +3 libtool>>libtool.tmp && \
  mv libtool.tmp libtool && \
	make
	cd ${SRCDIR} && \
	xcodebuild -project OneTime.xcodeproj -target ${TARGET} -configuration ${CONFIGURATION} ${BUILD_TARGETS}

clean:
	cd ${YUBICOC} && \
	make clean
	cd ${SRCDIR} && \
	xcodebuild -project OneTime.xcodeproj -target ${TARGET} -configuration ${CONFIGURATION} ${CLEAN_TARGETS}
