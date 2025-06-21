all:    hugo

img:
	./process-image.sh

generate: img
	hugo

draft: img
	hugo server -D
