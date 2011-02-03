[+ autogen5 template +]

## Created by Anjuta

ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif

ifeq ($(GNUSTEP_MAKEFILES),)
  $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif



include $(GNUSTEP_MAKEFILES)/common.make

PACKAGE_NAME = [+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]
VERSION = 0.0.1
APP_NAME = [+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]


GNUSTEP_INSTALLATION_DOMAIN=SYSTEM


COCOSTEPRESOURCEDIR = ./Resources/
COCOSTEPINCLUDEDIR=$(GNUSTEP_HEADERS)/CoCoStep

[+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_APPLICATION_ICON = Icon.png
[+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_OBJC_FILES = [+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+].m main.m
[+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_INCLUDE_DIRS= -I . -I $(COCOSTEPINCLUDEDIR)

[+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_TOOL_LIBS += -lCoCoStep 
[+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_LIB_DIRS =  -L $(COCOSTEPDIR) 
[+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_LD_LIBRARY_PATH = $(COCOSTEPDIR)

[+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_TOOL_LIBS += -lGL  -lm

[+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_OBJCFLAGS = -Wno-unknown-pragmas


[+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_OBJC_PRECOMPILED_HEADERS = [+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_Prefix.h
[+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_OBJCFLAGS  += -include [+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_Prefix.h -Winvalid-pch


[+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_RESOURCE_FILES =  $(COCOSTEPRESOURCEDIR)/Icon.png \
				 $(COCOSTEPRESOURCEDIR)/fps_images.png\
				 $(COCOSTEPRESOURCEDIR)/arial16.fnt\
				 $(COCOSTEPRESOURCEDIR)/arial16.png


-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/application.make
run: 
	export LD_LIBRARY_PATH=$([+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]_LD_LIBRARY_PATH) && openapp ./$([+(string-substitute (string->c-name! (string-downcase (get "Name"))) " " "-")+]).app

-include GNUmakefile.postamble
