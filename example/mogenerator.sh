#!/bin/sh

# Download mogenerator here: http://rentzsch.github.com/mogenerator/

mkdir -p Classes/Models
mogenerator --model CoreDataTalk.xcdatamodeld/CoreDataTalk.xcdatamodel --base-class BaseManagedObject --output-dir Classes/Models
