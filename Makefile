
EXTRA_SNAPS =
ALL_SNAPS = $(EXTRA_SNAPS) evince firefox gnome-calculator gnome-characters gnome-clocks gnome-logs gnome-system-monitor gnome-text-editor loupe snapd-desktop-integration snap-store alliances-core-desktop-init landscape-client
all: pc.tar.gz

pc.img: alliances-core-desktop-amd64.model $(EXTRA_SNAPS)
	rm -rf img/
	ubuntu-image snap --output-dir img --image-size 20G \
	  $(foreach snap,$(ALL_SNAPS),--snap $(snap)) $<
	mv img/pc.img .

pc-dangerous.img: alliances-core-desktop-amd64-dangerous.model $(EXTRA_SNAPS)
	rm -rf dangerous/
	ubuntu-image snap --output-dir dangerous --image-size 20G \
	  $(foreach snap,$(ALL_SNAPS),--snap $(snap)) $<
	mv dangerous/pc.img pc-dangerous.img

%.tar.gz: %.img
	tar czSf $@ $<

.PHONY: all
