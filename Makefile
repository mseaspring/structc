﻿#
# 前期编译一些目录结构使用宏
# Release : make 
# Debug   : make D=-D_DEBUG
# Clean   : make clean
#
ROOT		?= structc

DMAIN	    ?= main

DSTRUCT	    ?= struct
DSYSTEM	    ?= system
DBASE 	    ?= base

DTEST	    ?= test

OUTS		?= Output
DOBJ		?= obj

#
# DIRS		: 所有可变编译文件目录
# IINC		: -I 需要导入的include 目录
# SRCC		: 所有 .c 文件
#
DIRS	=	$(DSTRUCT) $(DSYSTEM) $(DBASE)

IINC	=	$(foreach v, $(DIRS), -I$(ROOT)/$(v))
SRCC	=	$(wildcard $(foreach v, $(DMAIN) $(DIRS) $(DTEST), $(ROOT)/$(v)/*.c))

OBJC	=	$(wildcard $(foreach v, $(DIRS), $(ROOT)/$(v)/*.c))
OBJO	=	$(foreach v, $(OBJC), $(notdir $(basename $(v))).o)
OBJP	=	$(OUTS)/$(DOBJ)/

TESTC	=	$(wildcard $(ROOT)/$(DTEST)/*.c)
TESTO	=	$(foreach v, $(TESTC), $(notdir $(basename $(v))).o)

#
# 全局编译的设置
#
CC		= gcc
CFLAGS 	= -g -O2 -Wall -Wno-unused-result -std=gnu11 
LIB 	= -lm -l:libuv.a -lpthread

RHAD	= $(CC) $(CFLAGS) $(IINC)
RTAL	= $(foreach v, $^, $(OBJP)$(v)) $(LIB)
RUNO	= $(RHAD) -c -o $(OBJP)$@ $< $(D)
RUN		= $(RHAD) -o $(OUTS)/$@ $(RTAL)

#
# 具体的产品生产								
#
.PHONY : all clean

all : main.out

#
# 主运行程序main
#
main.out : main.o main_run.o main_test.o librunc.a
	$(RUN)

#
# 循环产生 -> 所有 - 链接文件 *.o
#
define CALL_RUNO
$(notdir $(basename $(1))).o : $(1) | $$(OUTS)
	$$(RUNO)
endef

$(foreach v, $(SRCC), $(eval $(call CALL_RUNO, $(v))))

#
# 生成 librunc.a 静态库, 方便处理所有问题
#
librunc.a : $(OBJO) $(TESTO)
	$(CC) $(CFLAGS) -c -o $(OBJP)stdext.o $(ROOT)/$(DSYSTEM)/stdext.c -DJEMALLOC_NO_DEMANGLE $(DPRE)
	ar cr $(OBJP)$@ $(foreach v, $^, $(OBJP)$(v))

#
# 程序的收尾工作,清除,目录构建						
#
$(OUTS):
	-mkdir -p $(OBJP)


# 清除操作
clean :
	-rm -rf $(OUTS)
	-rm -rf Debug Release logs x64
	-rm -rf $(ROOT)/Debug $(ROOT)/logs $(ROOT)/Release $(ROOT)/x64
