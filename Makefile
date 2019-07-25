BIONIC_DIR = https://launchpad.net/~canonical-chromium-builds/+archive/ubuntu/stage/+build/17277616/+files
LIBC_DIR = https://snapshot.debian.org/archive/debian/20190701T031013Z/pool/main/g/glibc

CHROMIUM_BROWSER = chromium-browser_75.0.3770.142-0ubuntu0.18.04.1_armhf.deb
CHROMIUM_CODECS = chromium-codecs-ffmpeg-extra_75.0.3770.142-0ubuntu0.18.04.1_armhf.deb
LIBC = libc6_2.28-10_armhf.deb
RASPBIAN_CHROMIUM_BROWSER = $(subst _armhf,+rpi1_armhf,$(CHROMIUM_BROWSER))
RASPBIAN_CHROMIUM_CODECS = $(subst _armhf,+rpi1_armhf,$(CHROMIUM_CODECS))

all: $(RASPBIAN_CHROMIUM_BROWSER) $(RASPBIAN_CHROMIUM_CODECS)
	@echo "Successfully generated:"
	@echo "    $(RASPBIAN_CHROMIUM_BROWSER)"
	@echo "    $(RASPBIAN_CHROMIUM_CODECS)"

$(LIBC):
	curl -O -L $(LIBC_DIR)/$(LIBC)

$(CHROMIUM_BROWSER):
	curl -O -L $(BIONIC_DIR)/$(CHROMIUM_BROWSER)

$(CHROMIUM_CODECS):
	curl -O -L $(BIONIC_DIR)/$(CHROMIUM_CODECS)

# Downgrade libc dependency to 2.24, tag with +rpi1 suffix
$(RASPBIAN_CHROMIUM_CODECS): $(CHROMIUM_CODECS)
	mkdir -p .codecs-tmp
	cd .codecs-tmp && \
	  ar x ../$< && \
	  tar xf control.tar.xz && \
	  sed -i.bak 's/0ubuntu0.18.04.1/0ubuntu0.18.04.1+rpi1/; s/ 2.27)/ 2.24)/' control && \
	  tar cJf control.tar.xz control md5sums && \
	  ar cr ../$@ debian-binary control.tar.xz data.tar.xz

# Downgrade libc dependency to 2.24, tag with +rpi1 suffix, embed libm.so 2.28
$(RASPBIAN_CHROMIUM_BROWSER): $(CHROMIUM_BROWSER) $(LIBC)
	mkdir -p .browser-tmp
	cd .browser-tmp && \
	  ar x ../$(LIBC) && \
	  tar xf data.tar.xz ./lib/arm-linux-gnueabihf/libm.so.6 ./lib/arm-linux-gnueabihf/libm-2.28.so && \
	  ar x ../$<
	cd .browser-tmp && \
	  tar xf control.tar.xz && \
	  sed -i.bak 's/0ubuntu0.18.04.1/0ubuntu0.18.04.1+rpi1/; s/ 2.27)/ 2.24)/' control && \
	  tar cJf control.tar.xz conffiles control md5sums postinst prerm
	cd .browser-tmp && \
	  tar xf data.tar.xz && \
	  mv lib/arm-linux-gnueabihf/libm.so.6 usr/lib/chromium-browser && \
	  mv lib/arm-linux-gnueabihf/libm-2.28.so usr/lib/chromium-browser && \
	  tar cJf data.tar.xz etc usr && \
	  ar cr ../$@ debian-binary control.tar.xz data.tar.xz

clean:
	rm -rf .codecs-tmp .browser-tmp
	rm -f $(CHROMIUM_BROWSER) $(CHROMIUM_CODECS) $(LIBC) $(RASPBIAN_CHROMIUM_BROWSER) $(RASPBIAN_CHROMIUM_CODECS)
