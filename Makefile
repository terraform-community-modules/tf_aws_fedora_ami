.PHONEY: all

all: variables.tf.json

variables.tf.json: getvariables.rb 
	ruby getvariables.rb

clean:
	git checkout -- variables.tf.json

