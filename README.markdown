# Oodle Ruby API
---

## This software is licensed using the MIT License (see LICENSE for details)

## Description of use

This is a wrapper for the Oodle API (http://developer.oodle.com/). It follows very tightly against the documentation provided by Oodle and it works like this:

    require 'rubygems'
    require 'oodle'
    
    oodle = Oodle::API.new('625C7AB37B12',:v2)
    oodle.region = 'chicago'
    oodle.category = 'personals'
    oodle.fetch_listings['meta']['total'].inspect
