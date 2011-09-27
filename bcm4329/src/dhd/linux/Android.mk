#Android makefile to build kernel module

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

ifeq ($(BCM4329_WIFI_MOD_CONFIG_NAME),)
BCM4329_WIFI_MOD_CONFIG_NAME := dhd-cdc-sdmmc-imx5x-gpl-debug
endif

BCM4329_ROOT := $(LOCAL_PATH)
BCM4329_OUT := $(ANDROID_BUILD_TOP)/$(PRODUCT_OUT)/obj/bcm4329

bcm4329_mod := $(ANDROID_BUILD_TOP)/$(TARGET_OUT)/lib/modules/bcm4329.ko

bcm4329: $(bcm4329_mod)

.PHONY: FORCE
$(bcm4329_mod) : kernelimage FORCE | $(ACP)
	mkdir -p $(ANDROID_BUILD_TOP)/$(TARGET_OUT)/lib/modules
	mkdir -p $(BCM4329_OUT)
	+$(MAKE) -C $(BCM4329_ROOT) \
		ARCH=arm \
		CROSS_COMPILE=${ANDROID_BUILD_TOP}/$(TARGET_TOOLS_PREFIX) \
		LINUXVER=2.6.35 \
		LINUXDIR=${ANDROID_BUILD_TOP}/$(PRODUCT_OUT)/obj/kernel \
		OBJDIR=$(BCM4329_OUT) \
		$(BCM4329_WIFI_MOD_CONFIG_NAME)
	@echo "Install: $@"
	$(hide) $(ACP) $(BCM4329_OUT)/dhd.ko $@

ALL_PREBUILT += bcm4329
