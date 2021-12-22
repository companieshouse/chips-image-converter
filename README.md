# chips-image-converter

Docker build for container used to convert PDF &amp; PCL files to TIFF files

Dockerfile will get software from repository, install the software, then start the daemons used to convert the images. The images are picked up from a shared volume.

This will run alongside of the chips-weblogic application layer images, which drop PDF &amp; PCL files into the shared volume for the chips-image-converter to convert.
