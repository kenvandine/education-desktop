
EXTRA_SNAPS =
ALL_SNAPS = $(EXTRA_SNAPS) snapd-desktop-integration ubuntu-desktop-init firefox gnome-calculator gnome-text-editor evince loupe
all: pc.tar.gz

education-desktop.img: education-desktop-amd64.model $(EXTRA_SNAPS)
	rm -rf img/
	UBUNTU_STORE_AUTH=$(shell cat store.auth) ubuntu-image snap --output-dir img \
			  --image-size 25G  $(foreach snap,$(ALL_SNAPS),--snap $(snap)) $<
	mv img/pc.img education-desktop.img

%.tar.gz: %.img
	tar czSf $@ $<

education-desktop.img.xz: education-desktop.img
	xz --force --threads=0 -vv $<

education-desktop-installer.img: education-desktop.img.xz
	-rm -rf output/
	cat image/install-sources.yaml.in |sed "s/@SIZE@/$(shell stat -c%s education-desktop.img.xz)/g" > image/install-sources.yaml
	sudo ubuntu-image classic --debug -O output/ image/core-desktop.yaml
	sudo chown -R $(shell id -u):$(shell id -g) output
	mv output/education-desktop-installer.img .

education-desktop-installer.img.xz: education-desktop-installer.img
	xz --force --threads=0 -vv $<

.PHONY: all
