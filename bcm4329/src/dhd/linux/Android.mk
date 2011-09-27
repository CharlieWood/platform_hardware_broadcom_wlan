#Android makefile to build dhd kernel module

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

ifeq ($(BCM4329_WIFI_MOD_CONFIG_NAME),)
BCM4329_WIFI_MOD_CONFIG_NAME := dhd-cdc-sdmmc-imx5x-gpl-debug
endif

BCM4329_ROOT := $(LOCAL_PATH)
BCM4329_OUT := $(ANDROID_BUILD_TOP)/$(PRODUCT_OUT)/obj/bcm4329
bcm4329_mod := $(BCM4329_OUT)/dhd.ko

bcm4329: $(bcm4329_mod)

.PHONY: FORCE
$(bcm4329_mod) : kernelimage FORCE | $(ACP)
	mkdir -p $(ANDROID_BUILD_TOP)/$(TARGET_OUT)/lib/modules
	mkdir -p $(BCM4329_OUT)
	+$(MAKE) -C $(BCM4329_ROOT) \
		ARCH=arm \
		CROSS_COMPILE=${ANDROID_BUILD_TOP}/$(TARGET_TOOLS_PREFIX) \
		LINUXVER=2.6.35 \
		LINUXDIR=${ANDROID_BUILD_TOP}/kernel_imx \
		OBJDIR=$(BCM4329_OUT) \
		$(BCM4329_WIFI_MOD_CONFIG_NAME)

PRODUCT_COPY_FILES += \
	$(bcm4329_mod):system/lib/modules/bcm4329.ko
