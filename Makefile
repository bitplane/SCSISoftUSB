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

COMPONENT = SCSISoftUSB
TARGET    = SCSISoftUSB
DIRS      = local_dirs
CFLAGS    = -ffah -wp -wc -we -zM -zps1 -ITCPIPLibs:,C:USB -DDISABLE_PACKED -D_KERNEL ${DEFINES}
RAM_OBJS  = o.module ${OBJS}
ROM_OBJS  = o.moduleROM ${OBJS}
OBJS      =            o.svcprint  o.glue  o.umass  o.umass_quirks  o.global o.asm o.modhdr #o.resmess
DBG_OBJS  = do.module do.svcprint do.glue do.umass do.umass_quirks do.global o.asm o.modhdr #o.resmess
LIBDIR    = <Lib$Dir>
LIBS      = 
DBG_LIBS  = ${DEBUGLIB} ${LIBS} ${MODMALLOCLIB} ${WILDLIB} ${DDTLIB} ${DESKLIB} ${CALLXLIB} ${ASMUTILS} ${TBOXLIBS} ${LIBDIR}.DebugLib.o.debuglibzm TCPIPLibs:o.socklib5zm TCPIPLibs:o.inetlibzm
DBG_MODULE = drm.${TARGET}
EXPORTS   = 
#MERGEDMDIR = o.${MACHINE}._Messages_
#MERGEDMSGS = ${MERGEDMDIR}.${TARGET}

include Makefiles:StdTools
include Makefiles:ModuleLibs
include Makefiles:ModStdRule
include Makefiles:RAMCModule
include Makefiles:ROMCModule

.SUFFIXES: .do
.c.do:; ${CC} ${CFLAGS} -DDEBUGLIB -DUMASS_DEBUG -o $@ $<

local_dirs:
        ${MKDIR} gpa
        ${MKDIR} aif
        ${MKDIR} do
        ${MKDIR} o

export: ${EXPORTS}
        @${ECHO} ${COMPONENT}: export complete

${EXPORTS}: 

#resources: Messages${CMDHELP}
#        ${MKDIR} ${RESDIR}.${COMPONENT}
#        ${CP} Messages${CMDHELP} ${RESDIR}.${COMPONENT}.Messages ${CPFLAGS}
#        ${RM} Messages${CMDHELP}
#        @${ECHO} ${COMPONENT}: resource files copied

aif.${COMPONENT}: ${RAM_OBJS} ${RAM_LIBS} ${CLIB} ${DIRS}
        link -base 0 -aif -bin -d -o $@ ${RAM_OBJS} ${RAM_LIBS} ${CLIB}

gpa.${COMPONENT}: aif.${COMPONENT}
        togpa -s aif.${COMPONENT} $@



clean:
        ${RM} Messages
        ${RM} h.modhdr
        ifthere linked then wipe linked ${WFLAGS}
        ifthere aof    then wipe aof    ${WFLAGS}
        ifthere aif    then wipe aif    ${WFLAGS}
        ifthere gpa    then wipe gpa    ${WFLAGS}
        ifthere drm    then wipe drm    ${WFLAGS}
        ifthere do     then wipe do     ${WFLAGS}
        ifthere rm     then wipe rm     ${WFLAGS}
        ifthere o      then wipe o      ${WFLAGS}
        @${ECHO} ${COMPONENT}: cleaned

debug: ${DBG_MODULE}
        @${ECHO} ${COMPONENT}: debug module built

${DBG_MODULE}: ${DBG_OBJS} ${DBG_LIBS} ${CLIB} ${DIRS}
        ${MKDIR} drm
        ${LD} ${LDFLAGS} -o $@ -rmf ${DBG_OBJS} ${DBG_LIBS} ${CLIB}
        ${CHMOD} -R a+rx drm

o.module: modhdr.h
do.module: modhdr.h
o.glue: modhdr.h
do.glue: modhdr.h

moduleROM.o: module.c modhdr.h
        ${CC} ${CFLAGS} -DROM_MODULE -o moduleROM.o module.c

#resmess.o: ${MERGEDMSGS}
#	ResGen resmess_ResourcesFiles o.resmess ${MERGEDMSGS} Resources.SCSISoftUSB.Messages
#
#${MERGEDMSGS}:
#        ${MKDIR} ${MERGEDMDIR}
#        IfThere LocalRes:Messages Then ${CP} LocalRes:Messages $@ ${CPFLAGS} Else Create $@
#        IfThere LocalRes:CmdHelp Then FAppend $@ $@ LocalRes:CmdHelp

# Dynamic dependencies:
