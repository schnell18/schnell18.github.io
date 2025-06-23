all:    hugo

img:
	./process-image.sh

generate: img
	hugo

draft: img
	rm -fr public resources
	hugo server -D
