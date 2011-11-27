# Copyright 2003 Tematic Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Makefile for SCSISoftUSB
#
# ***********************************
# ***    C h a n g e   L i s t    ***
# ***********************************
# Date         Name    Description
# ----         ----    -----------
# 29-Apr-2003  BJGA    Created.

DEBUG ?= FALSE

ifeq ($(DEBUG),TRUE)
CFLAGS += -DDEBUGLIB -DUMASS_DEBUG -DUSB_DEBUG
CMHGFLAGS += -DDEBUGLIB -DUMASS_DEBUG -DUSB_DEBUG
LIBS = ${DEBUGLIBS} ${NET5LIBS}
endif

COMPONENT   = SCSISoftUSB
TARGET      = SCSISoftUSB
OBJS        = global glue module umass umass_quirks asm
CMHGFILE    = modhdr
HDRS        =

CINCLUDES   = -ITCPIPLibs:,C:USB
CFLAGS      += -ffah -wp -wc -we -zM -zps1 -DDISABLE_PACKED -D_KERNEL
CMHGDEPENDS = glue module
RAMCDEFINES = -DSTANDALONE

RES_OBJ = resmess
RES_AREA = resmess_ResourcesFiles

include StdTools
include ModStdRule
include ModuleLibs
include DbgRules
include CModule

# Dynamic dependencies:
