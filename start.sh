#!/bin/sh
erl +stbt db -pa ../esdl2/ebin -eval "dot:run()."
