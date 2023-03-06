PKG_NAME:=slowled
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

define Package/slowled
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Slow LED
  DEPENDS:=+nixio.fs +os
endef

define Package/slowled/description
  Slow LED is a program for controlling LED brightness and color using a slow fade effect, similar to Google Wifi LED behavior.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./slowled/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
endef

define Package/slowled/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/init.d/slowled $(1)/etc/init.d/

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/usr/bin/slowLed $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/usr/lib/lua/luci/controller/slow.lua $(1)/usr/lib/lua/luci/controller/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/slowled
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/usr/lib/lua/luci/view/slowled/slow.htm $(1)/usr/lib/lua/luci/view/slowled/
endef

$(eval $(call BuildPackage,slowled))
