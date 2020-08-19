DEST_DIR="../graphics/footprints/outputs"

make clean:
	rm -rfv $(DEST_DIR)/*.* log.txt

make build:
	mkdir $(DEST_DIR)
	touch log.txt

make run:
	./unit_test.sh

make test:
	make clean
	make build
	./unit_test.sh 